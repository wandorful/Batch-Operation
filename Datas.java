package com.atguigu.funding.bean;

import java.util.List;

/**
 * 数据包装类，封装多个用户
 * @author Jane
 *
 */
public class Datas {

	private List<User> users;
	private List<Integer> ids;
	private List<CertImg> certImgs;

	public List<Integer> getIds() {
		return ids;
	}

	public void setIds(List<Integer> ids) {
		this.ids = ids;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

    public List<CertImg> getCertImgs() {
        return certImgs;
    }

    public void setCertImgs(List<CertImg> certImgs) {
        this.certImgs = certImgs;
    }

}
