package com.dev24.client.pdetail.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PdetailVO {
	private int pd_num = 0;
	private int pd_price = 0; // 구매도서 단가(1권씩 저장되므로)
	private String pd_orderstate = ""; // 주문상태(처음엔 무조건 '배송예정')
	private int p_num = 0; // 구매번호
	private int c_num = 0; // 회원번호
	private int b_num = 0; // 도서번호
	
}
