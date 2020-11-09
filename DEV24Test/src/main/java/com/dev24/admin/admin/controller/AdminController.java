package com.dev24.admin.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.dev24.admin.admin.service.AdminService;
import com.dev24.admin.admin.vo.AdminVO;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("admin/*")
@AllArgsConstructor
//@SessionAttributes({"adm_id", "adm_num", "adm_name"})
public class AdminController {
	
	private AdminService adminService;
	
	@RequestMapping(value="/admin/adminLoginForm")
	public String adminLoginForm() {
		return "/admin/adminLoginForm";
	}
	
	@ResponseBody
	@RequestMapping(value="/pwdConfirm", method=RequestMethod.POST, produces="text/plain; charset=UTF-8")
	public String adminPasswordCheck(@ModelAttribute("data") AdminVO avo, Model model, HttpSession session) {
		log.info("pwdConfirm ȣ�� ����");
		AdminVO advo;
		String result ="";
		
		advo = adminService.adminPasswdChk(avo);
		
		log.info(avo.getAdm_id());
		
		if(!advo.getAdm_name().isEmpty()) {
			/*model.addAttribute("adm_id", advo.getAdm_id());
			model.addAttribute("adm_num", advo.getAdm_num());
			model.addAttribute("adm_name", advo.getAdm_name());*/
			session.setAttribute("adm_id", advo.getAdm_id());
			session.setAttribute("adm_num", advo.getAdm_num());
			session.setAttribute("adm_name", advo.getAdm_name());
			
			log.info(advo.toString());
			result="success";
		}else {
			result="fail";
		}
		return result;
	}
	
	@RequestMapping(value="/adminIndex", method=RequestMethod.GET)
	public String adminIndex(HttpSession session) {
		String abc = session.getAttribute("adm_num") + "";
		int result = Integer.parseInt(abc);
		log.info("=========="+result+"==================");
		return "/admin/adminIndex";
	}
	
}
