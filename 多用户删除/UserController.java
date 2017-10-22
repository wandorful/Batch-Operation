package com.atguigu.funding.manager.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.funding.bean.AJAXResult;
import com.atguigu.funding.bean.Datas;
import com.atguigu.funding.bean.Page;
import com.atguigu.funding.bean.Role;
import com.atguigu.funding.bean.User;
import com.atguigu.funding.manager.service.RoleService;
import com.atguigu.funding.manager.service.UserService;
import com.atguigu.funding.util.MD5Util;
import com.atguigu.funding.util.StringUtil;

@Controller
@RequestMapping("/manager/user")
public class UserController {

	@Autowired
	private UserService userService;

	@Autowired
	private RoleService roleService;

	@ResponseBody
	@RequestMapping("/revokeRole")
	public Object revokeRole(Integer id, Datas datas) {
	    AJAXResult<Integer> result = new AJAXResult<>();
	    Map<String, Object> map = new HashMap<>();
        map.put("userid", id);
        map.put("roleids", datas.getIds());
        try {
            int count = userService.revokeRole(map);
            result.setSuccess(count == datas.getIds().size());
        } catch (Exception e) {
            result.setSuccess(false);
            e.printStackTrace();
        }
        return result;
	}

	@ResponseBody
	@RequestMapping("/assignRole")
	public Object assignRole(Integer id, Datas datas) {
	    AJAXResult<Integer> result = new AJAXResult<>();
	    Map<String, Object> map = new HashMap<>();
	    map.put("userid", id);
	    map.put("roleids", datas.getIds());
	    try {
            int count = userService.assignRole(map);
            result.setSuccess(count == datas.getIds().size());
        } catch (Exception e) {
            result.setSuccess(false);
            e.printStackTrace();
        }
	    return result;
	}

	@RequestMapping("/toAssignRole")
	public String toAssignRole(Integer id, Model model) {
	    List<Role> roles = roleService.getRoles();

	    List<Integer> assigned = userService.getRoleIdsByUserId(id);

	    List<Role> assignedRoles = new ArrayList<>();
	    List<Role> unassignedRoles = new ArrayList<>();

	    for (Role role : roles) {
            if (assigned.contains(role.getId())) {
                assignedRoles.add(role);
            } else {
                unassignedRoles.add(role);
            }
        }

	    model.addAttribute("assignedRoles", assignedRoles);
	    model.addAttribute("unassignedRoles", unassignedRoles);
	    model.addAttribute("usr", userService.getUserById(id));
	    
	    return "manager/user/assignRole";
	}

	@RequestMapping("/list")
	public String list() {
		return "manager/user/list";
	}

	@ResponseBody
	@RequestMapping("/pageQuery")
	public Object pageQuery(String condLine, Integer pageNo, Integer pageSize) {
		AJAXResult<User> ajaxResult = new AJAXResult<User>();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("start", (pageNo-1) * pageSize);
		param.put("size", pageSize);
		if(StringUtil.isNotEmpty(condLine)) {
			System.out.println("条件查询：" + condLine);
			param.put("condLine", condLine);
		}
		List<User> users = userService.getPageUsers(param);
		int totalCount = userService.getTotalCount(param);
		//System.out.println("总的条目数：" + totalCount);
		Page<User> page = new Page<User>();
		page.setList(users);
		page.setTotalRecord(totalCount);
		page.setPageNo(pageNo);

		ajaxResult.setPage(page);
		ajaxResult.setSuccess(true);
		return ajaxResult;
	}

	@RequestMapping("/add")
	public String toAdd() {
		return "manager/user/add";
	}

	@RequestMapping("/multiadd")
	public String toMulAdd() {
		return "manager/user/multiadd";
	}

	@RequestMapping("/insert")
	public String insert(User user) {
		user.setPassword(MD5Util.digest("123456"));
		user.setCreatetime(StringUtil.getSystemTime());
		System.out.println(user);
		userService.addUser(user);
		return "redirect:/manager/user/list.htm";
	}

	@RequestMapping("/batchInsert")
	public String batchInsert(Datas datas) {
		List<User> users = datas.getUsers();
		System.out.println(users);
		Iterator<User> iterator = users.iterator();
		while(iterator.hasNext()) {
			User user = iterator.next();
			if(StringUtil.isEmpty(user.getAccount())) {
				iterator.remove();
			}
		}
		return "success";
	}

	@RequestMapping("/edit")
	public String edit(Integer pageNo, Integer id, Model model) {
		//System.out.println("id = " + id);
		model.addAttribute("usr", userService.getUserById(id));
		model.addAttribute("pageNo", pageNo);
		return "manager/user/edit";
	}

	@ResponseBody
	@RequestMapping("/update")
	public Object updateUser(User user) {
		System.out.println(user);
		AJAXResult<User> result = new AJAXResult<User>();
		try {
			int count = userService.updateUser(user);
			result.setSuccess(count == 1);
		}
		catch(Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}

	@RequestMapping("/delUser")
	public String delUser(Integer id) {
		//System.out.println(id);
		userService.delUser(id);
		return "redirect:/manager/user/list.htm";
	}

	@ResponseBody
	@RequestMapping("/deleteUsers")
	public Object deleteUsers(Datas datas) {
		List<Integer> ids = datas.getIds();
		AJAXResult<Integer> result = new AJAXResult<>();
		try {
			int count = userService.deleteUsers(datas);
			result.setSuccess(count == ids.size());
		}
		catch(Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
}
