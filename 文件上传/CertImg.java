package com.atguigu.funding.bean;

import org.springframework.web.multipart.MultipartFile;

public class CertImg {

    private Integer id;
    private Integer memberid;
    private Integer certid;
    private String iconpath;
    private MultipartFile certImgFile;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMemberid() {
        return memberid;
    }

    public void setMemberid(Integer memberid) {
        this.memberid = memberid;
    }

    public Integer getCertid() {
        return certid;
    }

    public void setCertid(Integer certid) {
        this.certid = certid;
    }

    public String getIconpath() {
        return iconpath;
    }

    public void setIconpath(String iconpath) {
        this.iconpath = iconpath;
    }

    public MultipartFile getCertImgFile() {
        return certImgFile;
    }

    public void setCertImgFile(MultipartFile certImgFile) {
        this.certImgFile = certImgFile;
    }

}
