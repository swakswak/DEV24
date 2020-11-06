package com.dev24.client.cart.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.dev24.client.cart.service.CartService;
import com.dev24.client.cart.vo.CartVO;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/cart/*")
@Log4j
@AllArgsConstructor
public class CartController {
	private CartService cartService;
	
	/************************************************
	 * cart_view�� �̿��� ��ٱ��� ����Ʈ ���
	 * �Ϲݵ���, ebook (��з�) ���� ����ϱ�
	 * **************/
	@GetMapping("/cartList")
	public String CartList(@ModelAttribute("data") CartVO cvo, Model model) {
		log.info("cartList() �޼��� ȣ��");
		
		List<CartVO> list = cartService.cartList(cvo);
		List<CartVO> list1 = new ArrayList<CartVO>();
		List<CartVO> list2 = new ArrayList<CartVO>();
		
		for(int i=0; i<list.size(); i++) {
			int cate = list.get(i).getCateone_num();
			if(cate == 1) { // �Ϲݵ����϶�
				CartVO vo1 = list.get(i);
				list1.add(vo1);
			}else if(cate == 2){ // ebook�϶�
				CartVO vo2 = list.get(i);
				list2.add(vo2);
			}
		}
		
		model.addAttribute("cartList1", list1);
		model.addAttribute("cartList2", list2);
		
		return "cart/cartList";
	}
	
	/************************************************
	 * ��ٱ��� ���� ����
	 * REST��Ŀ��� UPDATE�۾��� PUT, PATCH����� �̿��ؼ� ó��.
	 * **************/
	@RequestMapping(value="/{crt_num}", method= {RequestMethod.PUT, RequestMethod.PATCH}, consumes="application/json", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> cartUpdate(@PathVariable("crt_num") int crt_num, @RequestBody CartVO cvo){
		log.info("cartUpdate() ȣ�� ����");
		cvo.setCrt_num(crt_num);
		int result = cartService.cartUpdate(cvo);
		return result==1 ? new ResponseEntity<String>("SUCCESS", HttpStatus.OK) : new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	/************************************************
	 * ��ٱ��� ��ǰ ����
	 * REST��Ŀ��� DELETE�۾���  DELETE����� �̿��ؼ� ó��.
	 * **************/
	@DeleteMapping(value="/{crt_num}", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> cartDelete(@PathVariable("crt_num") int crt_num){
		log.info("cartDelete() ȣ�� ����");
		log.info("crt_num : "+crt_num);
		int result = cartService.cartDelete(crt_num);
		return result==1 ? new ResponseEntity<String>("SUCCESS", HttpStatus.OK) : new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
}