package com.atguigu.funding.protal.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.atguigu.funding.bean.AJAXResult;
import com.atguigu.funding.bean.Cert;
import com.atguigu.funding.bean.CertImg;
import com.atguigu.funding.bean.Datas;
import com.atguigu.funding.bean.Member;
import com.atguigu.funding.bean.Ticket;
import com.atguigu.funding.common.Const;
import com.atguigu.funding.manager.service.CertService;
import com.atguigu.funding.protal.listener.DenyListener;
import com.atguigu.funding.protal.listener.PassListener;
import com.atguigu.funding.protal.service.MemberService;
import com.atguigu.funding.protal.service.TicketService;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private TicketService ticketService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private CertService certService;

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private TaskService taskService;

    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/index.htm";
    }

    @RequestMapping("/apply")
    private String apply(HttpSession session, Model model) {
        Member loginMember = (Member) session.getAttribute(Const.LOGIN_MEMBER);
        Ticket ticket = ticketService.getTicketByMember(loginMember);
        if (ticket == null) {
            ticket = new Ticket();
            ticket.setMemberid(loginMember.getId());
            ticket.setStatus("0");
            ticket.setPstep("accttype");
            ticketService.saveTicketForMember(ticket);
        } else {
            String procStep = ticket.getPstep();
            if ("accttype".equals(procStep)) {

                return "member/basicinfo";
            } else if ("basicinfo".equals(procStep)) {

                List<Cert> certs = certService.queryCertsByAccttype(loginMember.getAccttype());
                model.addAttribute("requiredCerts", certs);
                return "member/uploadfile";
            } else if ("uploadfile".equals(procStep)) {

                return "member/checkemail";
            } else if ("checkemail".equals(procStep)) {

                return "member/applyconfirm";
            }
        }
        return "member/accttype";
    }

    @ResponseBody
    @RequestMapping("/updateAcctType")
    public Object updateAcctType(String accttype, HttpSession session) {
        AJAXResult<Member> result = new AJAXResult<>();
        try {
            Member loginMember = (Member) session.getAttribute(Const.LOGIN_MEMBER);
            loginMember.setAccttype(accttype);
            int count = memberService.updateAccttype(loginMember);
            if (count == 1) {
                Ticket ticket = ticketService.getTicketByMember(loginMember);
                ticket.setPstep("accttype");
                int num = ticketService.updatePstep(ticket);
                if (num == 1) {
                    result.setSuccess(true);
                } else {
                    result.setSuccess(false);
                }
            } else {
                result.setSuccess(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.setSuccess(false);
        }
        return result;
    }

    @ResponseBody
    @RequestMapping("/updateMemberBasicInfo")
    public Object updateMemberBasicInfo(Member member, HttpSession session) {
        AJAXResult<Member> result = new AJAXResult<>();
        try {
            Member loginMember = (Member) session.getAttribute(Const.LOGIN_MEMBER);
            loginMember.setPhone(member.getPhone());
            loginMember.setCardnum(member.getCardnum());
            loginMember.setRealname(member.getRealname());
            int count = memberService.updateMemberBasicInfo(loginMember);
            if (count == 1) {
                Ticket ticket = ticketService.getTicketByMember(loginMember);
                ticket.setPstep("basicinfo");
                int num = ticketService.updatePstep(ticket);
                if (num == 1) {
                    result.setSuccess(true);
                } else {
                    result.setSuccess(false);
                }
            } else {
                result.setSuccess(false);
            }
        } catch (Exception e) {
            result.setSuccess(false);
            e.printStackTrace();
        }
        return result;
    }

    @ResponseBody
    @RequestMapping("/uploadCertFile")
    public Object uploadCertFile(HttpSession session, Datas datas) {
        AJAXResult<Boolean> result = new AJAXResult<>();
        try {
            ServletContext application = session.getServletContext();
            String realPath = application.getRealPath("pics");

            Member loginMember = (Member) session.getAttribute(Const.LOGIN_MEMBER);
            List<CertImg> certImgs = datas.getCertImgs();

            for (CertImg certImg : certImgs) {
                certImg.setMemberid(loginMember.getId());
                MultipartFile certImgFile = certImg.getCertImgFile();
                String filename = certImgFile.getOriginalFilename();
                String tempName = UUID.randomUUID().toString() + filename.substring(filename.lastIndexOf("."));
                certImg.setIconpath(tempName);
                String filePath = realPath + "/cert/" + tempName;
                certImgFile.transferTo(new File(filePath));
            }
            int count = memberService.addMemberCertFile(datas);
            if (count == certImgs.size()) {
                Ticket ticket = ticketService.getTicketByMember(loginMember);
                ticket.setPstep("uploadfile");
                int num = ticketService.updatePstep(ticket);
                if (num == 1) {
                    result.setSuccess(true);
                } else {
                    result.setSuccess(false);
                }
            } else {
                result.setSuccess(false);
            }
        } catch (Exception e) {
            result.setSuccess(false);
            e.printStackTrace();
        }
        return result;
    }

    @ResponseBody
    @RequestMapping("/startProcess")
    public Object startProcess(String email, HttpSession session) {
        AJAXResult<Boolean> result = new AJAXResult<>();
        try {
            Member loginMember = (Member) session.getAttribute(Const.LOGIN_MEMBER);
            if (!email.equals(loginMember.getEmail())) {
                loginMember.setEmail(email);
                memberService.updateEmail(loginMember);
            }
            // 开启实名认证流程
            // 生成4位的随机验证码，需要保存到流程审批单中
            StringBuilder authcode = new StringBuilder();
            Random random = new Random();
            for(int i = 0; i < 4; i++) {
                authcode.append(random.nextInt(10));
            }

            // 流程定义中的参数
            Map<String, Object> variables = new HashMap<>();
            variables.put("toEmail", email);
            variables.put("authcode", authcode.toString());
            variables.put("account", loginMember.getAccount());
            variables.put("passListener", new PassListener());
            variables.put("denyListener", new DenyListener());

            ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                    .processDefinitionKey("auth").latestVersion().singleResult();
            //ProcessInstance pi = runtimeService.startProcessInstanceByKey("auth", variables);
            ProcessInstance pi = runtimeService.startProcessInstanceById(pd.getId(), variables);
            if (pi != null) {
                Ticket ticket = ticketService.getTicketByMember(loginMember);
                ticket.setAuthcode(authcode.toString());
                ticket.setPiid(pi.getId());
                ticket.setPstep("checkemail");
                int count = ticketService.updateAfterStartProc(ticket);
                if (count == 1) {
                    result.setSuccess(true);
                } else {
                    result.setSuccess(false);
                }
            }
        } catch (Exception e) {
            result.setSuccess(false);
            e.printStackTrace();
        }
        return result;
    }

    @ResponseBody
    @RequestMapping("/checkAuthCode")
    public Object checkAuthCode(String authcode, HttpSession session) {
        AJAXResult<Boolean> result = new AJAXResult<>();
        try {
            Member loginMember = (Member) session.getAttribute(Const.LOGIN_MEMBER);
            loginMember.setAuthstatus("1");
            Ticket ticket = ticketService.getTicketByMember(loginMember);
            if (ticket.getAuthcode().equals(authcode)) {
                int count = memberService.updateAuthStatus(loginMember);
                if (count == 1) {
                    Task task = taskService.createTaskQuery()
                            .processInstanceId(ticket.getPiid())
                            .taskAssignee(loginMember.getAccount())
                            .singleResult();
                    taskService.complete(task.getId());
                    result.setSuccess(true);
                } else {
                    result.setSuccess(false);
                }
            } else {
                result.setSuccess(false);
            }
        } catch (Exception e) {
            result.setSuccess(false);
            e.printStackTrace();
        }
        return result;
    }

}
