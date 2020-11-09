<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<!-- 문서 유형 : 현재 웹 문서가 어떤 HTML 버전에 맞게 작성되었는지를 알려준다. -->

<!--<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
     DTD 선언문이 HTML 페이지의 가장 첫 라인에 명시되어야 웹 브라우저가 HTML 버전을 인식.
     HTML태그나 CSS를 해당 버전에 맞도록 처리하므로 웹 표준 준수를 위하여 반드시 명시되어야 한다.-->
<html lang="ko">
   <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
      
      <title>DEV 24 Stock Admin page</title>
         
         <link rel="stylesheet" type="text/css" href="/resources/include/dist/css/bootstrap.min.css" />
         <link rel="stylesheet" type="text/css" href="/resources/include/dist/css/bootstrap-theme.css" />
    
         <script type="text/javascript" src="/resources/include/js/jquery-1.12.4.min.js"></script>
         <script type="text/javascript" src="/resources/include/dist/js/bootstrap.js"></script>
         <script type="text/javascript" src="/resources/include/js/common.js"></script>
		 <!-- 부트스트랩  -->         
      <!--[if lt IE 9]>
      <script src="../js/html5shiv.js"></script>
      <![endif]-->
      
      <script type="text/javascript">
      
	      $(function(){
	    	  var d = new Date();

	    	  var month = d.getMonth()+1;
	    	  var day = d.getDate();
	    	  var time = d.getTime();
	    	  
	    	  var now = new Date(Date.now());
	    	  var formatted = now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
	    	  if(now.getHours() == 0){
	    		  formatted = "0"+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	    	  }
	    	  if(now.getMinutes()<10){
	    		  formatted = now.getHours()+":"+"0"+now.getMinutes()+":"+now.getSeconds();
	    	  }
	    	  if(now.getSeconds()<10){
	    		  formatted = now.getHours()+":"+"0"+now.getMinutes()+":"+"0"+now.getSeconds();
	    	  }
	    		  
	    	  
	    	  // 20:10:58
	    	  var output = d.getFullYear() + '/' +
	    	      (month<10 ? '0' : '') + month + '/' +
	    	      (day<10 ? '0' : '') + day+':' +formatted;
	    	  
	    	  $("#date").text(output); //가공된 형식으로 출력한다. (2020/11/01[12:36:42])
	    	  //$("#date").text(d);
	    	  
	    	  $("#goHome").click(function(){
	    		  location.href="/admin/adminIndex";
	    	  });
	    	  
	    	  	    	      
	    	  // 재고 확인용 함수 chkStock 
	    	  
	    	 function chkStock(item, msg) {
				if($(item).val().replace(/\s/g,"")=="" || parseInt($(item).val()) <0 ) {
					alert(msg+" 입력해주세요.");
					item.val("");
					item.focus();
					return false; //값이 비어있을 경우 false를 반환
				} else {
					return true;
				}
			}
	    	  
	    	  //재고 등록 값 전달하는 ajax
	    	  
	    	  $("#submitBtn").click(function(){
	    		 console.log($("#b_num").val()); 
	    		 console.log($("#stk_qty").val()); 
	    		 console.log($("#adm_num").val()); 
	    		 console.log($("#stk_salp").val()); 
	    		 
	    		 if(!chkSubmit("#stk_qty", "입고수량을")) return;
	    		 else if (!chkSubmit("#stk_salp", "판매가격을"))return;
	    		 else if(!chkStock("#stk_qty", "판매")) return;
	    			 
	    		 else{
	    			 $.ajax({
	    				url: "/admin/stockAdmin.jsp", 
	    				type: "post",
	    				data: {
	    					b_num : $("#b_bum").val(), 
	    					stk_qty: $("#stk_qty").val(), 
	    					adm_num: $("#adm_num").val(), 
	    					stk_salp: $("#stk_salp").val()
	    				},
	    				dataType:"text",
	    				success:function(){
	    					alert("데이터 전송 완료");
	    				},
	    			 });
	    		 }
	    	  });
	    	  
	    	 

				/*검색 대상이 변경될 때마다 처리 이번트*/
				$("#searchData").change(function(){
					if($("#search").val() == "all"){
						$("#keyword").val("전체 데이터 조회 합니다.");
					}else if ($("#search").val()!="all"){
						$("keyword").val();
						$("#keyword").focus();
					}
				});
	    	  
	    	  /*검색 버튼 클릭시 처리 이번트*/
	    	  
	    	  	//도서명, 작가, 도서코드 검색버튼
				$("#searchData").click(function(){
					if($("#search").val()!="all"){
						if(!chkSubmit("#keyword", "검색어를")) return;
					}
					goPage();
				});
	    	  
	    	  //도서 카테고리 검색 버튼
	    	  $("#searchStkCate").click(function(){
	    		 goCate(); 
	    	  });
	    	  
	    	  
	    	  
	    	  //도서 제목을 클릭시 도서코드를 전달해주는 구문
	    	  $(".stkDetail").click(function(){
	    		 var stockcode= $(this).parents("tr").attr("data-num");
	    		 $("#stk_incp").val(stockcode);
	    		 console.log("도서 코드= "+ $("#stk_incp").val());
	    		 
	    		 $("#detailForm").attr({
						"method":"get", 
						"action":"/admin/stockDetail"
					});
					$("#detailForm").submit()
	    	  });
	    	  
	    	  $(".stkbInfo").click(function(){
	    		  var stockcode= $(this).parents("tr").attr("data-num");
		    		 $("#stk_incp").val(stockcode);
		    		 console.log("도서 코드= "+ stockcode);
	    	  });
	    	  
	      });
	      
	      /*검색 버튼을 위한 함수*/
	      function goPage(){
				$("#searchForm").attr({
					"method":"get", 
					"action":"/admin/stockList"
				});
				$("#searchForm").submit();
			}
			
	      /*책 소분류별 검색버튼을 위한 함수*/
	      function goCate(){
	    	  $("#categorySearch").attr({
					"method":"get", 
					"action":"/admin/stockList"
				});
				$("#categorySearch").submit();
	      }
      	
	      
	     
	     </script>
      
      
      <style type="text/css">
			.panel-body{background-color: white;}     
			#keyword, #search, #searchTerm, #searchData, #searchTerm, #category, #stk_regdate {height:33px;}
			
			.searchCategory{padding:15px; float:left;}
			
			#table{ padding:10px;}
			
			.bookStockImg{
				display: block;
				margin-left: auto;
				margin-right: auto;
				width: 30%;
				height:30%;
			}
			
			#title{
				text-align: center;
			}
			
			.stkDetail {
            cursor: pointer;
         	}
			  
			#searchArea{
			margin:10px;
			/*float:right;*/ 
			} 
			
			td{ text-align: left;}
      </style>
      
      
      
   </head>
   <body>
   		
   		<form id="detailForm" name="detailForm">
			<input type="hidden" id="stk_incp" name="stk_incp"/>
		</form>
   		
		<!-- model form -->
		<h1 id="title"> 재고관리 페이지</h1>
		
		<div class="row">
			<div class="col-sm-5">
				<div class="panel-body">
				    <!-- button to generate model form -->
				    <a href="#myModal" data-toggle="modal" class="btn btn-s btn-success">재고등록</a>
				    <input type="button" name="goHome" id="goHome" class="btn btn-s btn-success" value="관리자페이지 "/>
				
				    <!-- model form settings-->
				
				    <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="myModal" class="modal fade">
				        <%-- <div class="modal-dialog"> --%>
				        <div class="modal-dialog modal-lg">
				            <div class="modal-content">
				                <div class="modal-header">
				                    <button aria-hidden="true" data-dismiss="modal" class="close" type="button">&times;</button>
				                    <h4 class="modal-title">도서 재고 신규 등록</h4>
				                </div>
				                <div class="modal-body">
				
				    <!-- actual form  -->
				    				<%-- jstl 호황 테스팅을 위한 표현식 변수 선언 
				    				<c:set var="b_title" scope="session" value="강자바의 자바 조지기"/>
				    				<c:set var="b_author" scope="session" value="강자바"/>
				    				<c:set var="b_pub" scope="session" value="강자바 컴퍼니"/>
				    				<c:set var="b_num" scope="session" value="411"/>
				    				<c:set var="adm_name" scope="session" value="강자바"/>
				    				<c:set var="adm_num" scope="session" value="2"/>
				    				--%>
				    				
				    				
				                    <form role="form">
				                        <div class="form-group">
				                            <label>상품코드</label>
				                           	<select class="form-control" name="b_num" id="b_num">
					                            <c:choose>
						                           	<c:when test="${not empty bookstockList}">
														<c:forEach var="bookinfo" items="${bookstockList}">
					                            			<option value="${bookinfo.b_num}"> ${bookinfo.b_name} / ${bookinfo.b_author} / ${bookinfo.b_pub} </option>
														</c:forEach>
						                            </c:when>
					                            </c:choose>
				                            </select>
				                        </div>
				                        <div class="form-group">
				                            <label>입고수량</label>
				                            <input class="form-control" placeholder="재고수량 입력" type="number" min="1" name="stk_qty" id="stk_qty">
				                        </div>
				                        <div class="form-group">
				                            <label for="exampleInputFile">재고 등록자명</label>
				                            <input type="hidden" value="${adm_num}" name="adm_num" id="adm_num"/>
				                            <p>${adm_name} 관리자</p>
				                            <p class="help-block" style=color:red;>도서의 재고는 한번 입력시 수정이 불가합니다. 신중히 등록을 해주세요</p>
				                        </div>
				                        
				                        <div class="form-group">
				                        	<label>등록일자</label>
				                        	 <p id="date"></p>
				                        </div>
				                        
				                        <div class="form-group">
				                        	<label>판매가격</label>
				                        	<input type="number" class="form-control" placeholder="판매가격 입력 " name="stk_salp" id="stk_salp"/>
				                        </div>
				                        <input type="button" class="btn btn-default" value="도서등록" name="submitBtn" id="submitBtn"/>
				                    </form>
				    <!-- actual form ends -->
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
			</div>
		</div>
		
		 <!-- 여기서부터가 우리가 입력할 body 부분 시작. 재고 리스트를 여기에 출력 -->
		<div>
			<div>
			<%-- 검색기능 시작 --%>
				<div id="searchArea">
					<form name="searchForm" id="searchForm">
						<div class="searchCategory">
						<label>검색조건</label>
						<select id="search" name="search">
							<option value="all">전체</option>
							<option value="b_name">도서명</option>
							<option value="b_author">작가</option>
							<option value="stk_incp">도서코드</option>
						</select>
						<input type="text" id="keyword" name="keyword" placeholder="검색어/코드 를 입력해주세요"/>
						<button type="button" class="btn btn-primary btn-sm" id="searchData">검색</button>
						
										
						<%-- 	<label for="b_num">도서코드: </label>
							<input type="text" name="b_num" id="b_num" placeholder="도서 코드를 입력하세요 "/>
							<input type="button" name="searchBNum" id="searchBNum" value="검색" class="btn btn-info" />
							
							
							<label for="b_name">도서명: </label>
							<input type="text" name="b_name" id="b_name" placeholder="도서제목을 입력하세요"/>
							<input type="button" name="searchBName" id="searchBName" value="검색" class="btn btn-info"/> --%>
						</div>
						
						
						</form>
					
						<form id="categorySearch" name="categorySearch">
							<div class="searchCategory">
								<label for="category">도서 카테고리</label>
								<select name="category" id="category">
									<option value="pl">프로그래밍 언어</option>
									<option value="osdb">OS/데이터베이스</option>
									<option value="webp">웹프로그래밍</option>
									<option value="com">컴퓨터 입문/활용</option>
									<option value="net">네크워크/해킹/데이터베이스</option>
									<option value="it">IT 전문서</option>
									<option value="compt">컴퓨터 수험서</option>
									<option value="webc">웹/컴퓨터/입문 활용</option>
								</select>
							<%-- 	<input type="hidden" name="categorynumber" id="categorynumber"/> --%>
								<input type="button" name="searchStkCate" id="searchStkCate" value="검색" class="btn btn-info"/>
							</div>
						</form>
						
					<form id="dateSearch" name="dateSearch">
						<div class="searchCategory">
							<label for="stk_regdate">등록일자</label>
							<input type="date" name="stk_regdate" id="stk_regdate" />
							<input type="button" name="searchStkRegdate" id="searchStkRegdate" value="검색" class="btn btn-info"/>
						</div>
					</form>
					
				</div>
				<%-- 검색기능 끝 --%>
				
				
				
			<%--
			=================================================================
			
			-----------책 목록 화면의 테이블을 위한 쿼리문------------------------------
			
			----------------stock_list view 생성------------------------------
			create view stock_list as 
			select stock.stk_incp, book.b_name, book.b_author, stock.stk_qty, 
			stock.stk_salp, book.cateone_num, book.catetwo_num,stock.adm_num, 
            to_char (stock.stk_regdate, 'YYYY-MM-DD HH24:mm:ss') as stk_regdate
			from book
			inner join stock
			on book.b_num=stock.stk_incp;
			------------------------------------------------------------------
			
			
			-----도서재고 현황 테이블을 위한 정보를 불러오는 쿼리--------------------------------------------------
			select stock_list.stk_incp, stock_list.b_name, stock_list.b_author, 
			stock_list.stk_qty, stock_list.stk_salp, stock_list.cateone_num, stock_list.catetwo_num,
			stock_list.stk_regdate, admin.adm_name
			from stock_list
			inner join admin
			on 
			admin.adm_num=stock_list.adm_num order by stk_incp;
            -----------------------------------------------------------------------------------------

			------------------------------------------------------------------
			
			
			==================================================================
			
			
			=================================================================
			
			---------검색기능을 위한 쿼리문 ----------------------------------------
			
			----도서번호 검색----------------------------------------------------
			select stock_list.stk_incp, stock_list.b_name, stock_list.b_author, 
			stock_list.stk_qty, stock_list.stk_salp, stock_list.cateone_num, stock_list.catetwo_num,
			stock_list.stk_regdate, admin.adm_name
			from stock_list
			inner join admin
			on 
			admin.adm_num=stock_list.adm_num where stk_incp like ? order by stk_incp;
			------------------------------------------------------------------
			
			
			-----------도서제목 검색---------------------------------------------
			select stock.stk_incp, book.b_name, book.b_author, stock.stk_qty, 
			stock.stk_salp, book.catetwo_num,  book.cateone_num, stock.adm_num,
			stock.stk_regdate 
			from book
			inner join stock
			on book.b_num=stock.stk_incp where book.b_name like '?%';
			------------------------------------------------------------------
			
			-------------작가별 검색---------------------------------------------
			select stock.stk_incp, book.b_name, book.b_author, stock.stk_qty, 
			stock.stk_salp, book.catetwo_num,  book.cateone_num, stock.adm_num,
			stock.stk_regdate 
			from book
			inner join stock
			on book.b_num=stock.stk_incp where book.b_author like '김%';
			------------------------------------------------------------------
			
			
			-------등록일자 검색--------------------------------------------------
			select stock.stk_incp, book.b_name, book.b_author, stock.stk_qty, 
			stock.stk_salp, book.catetwo_num,  book.cateone_num, stock.adm_num,
			stock.stk_regdate 
			from book
			inner join stock
			on book.b_num=stock.stk_incp where stock.stk_regdate >= trunc(to_date('2020/10/29', 'yyyy/mm/dd'));
			-------------------------------------------------------------------
			
			
			------카테고리 검색---------------------------------------------------
			select stock.stk_incp, book.b_name, book.b_author, stock.stk_qty, 
			stock.stk_salp, book.catetwo_num,  book.cateone_num, stock.adm_num,
			stock.stk_regdate 
			from book
			inner join stock
			on book.b_num=stock.stk_incp where book.catetwo_num like ?; 
			-------------------------------------------------------------------
			
			--------판매가격 검색--------------------------------------------------
			select stock.stk_incp, book.b_name, book.b_author, stock.stk_qty, 
			stock.stk_salp, book.catetwo_num,  book.cateone_num, stock.adm_num,
			stock.stk_regdate 
			from book
			inner join stock
			on book.b_num=stock.stk_incp where stock.stk_salp like ?;
			-------------------------------------------------------------------
			
			
			------------- 책 상세정보 쿼리-----------------------------------------------------------------------------------------------
			create view stock_book_info as 
			select book.b_num, book.b_name, book.b_author, book.b_pub, book.catetwo_num, book.cateone_num, bookimg.listcover_imgurl 
			from book 
			inner join bookimg
			on bookimg.b_num = book.b_num;
			
			select*from stock_book_info where b_num=4;
			------------------------------------------------------------------------------------------------------------------------
			
			
			 --%>
			
			<%-- 도서 재고 현황 테이블 시작 --%>
			<br/>
			<br/>
			<br/>
		<div id="table">			 			 
			<h1>도서재고 현황</h1>
				<table class="table table-striped">
					<thead>
					    <tr>
					    	<th>도서코드</th>
					    	<th>제목</th>
					    	<th>작가</th>
					    	<th>재고수량</th>
					    	<th>입고가격</th>
					    	<th>대분류</th>
					    	<th>소분류</th>
					    	<th>등록자(관리자)명</th>
					    	<th>등록일자</th>
					 	</tr>
				    </thead>
				    
				    
				    
				    <tbody>
				    	<c:choose>
				    		<c:when test="${not empty stockList }">
						     	<c:forEach var="book" items="${stockList}" varStatus="status" >
						     	
						     	<%-- 도서 대분류 및 소분류명을 변환해주는 jstl 함수 --%>							    		
							    		<c:choose>
							    			<c:when test="${book.cateone_num == 1}">
							    				<c:set var="cateOne" scope="session" value="일반도서"/>		
							    			</c:when>
							    			<c:otherwise>
							    				<c:set var="cateOne" scope="session" value="ebook"/>
							    			</c:otherwise>
							    		</c:choose>
						     	
						     <%-- 도서 소분류코드 번호를 변환해주는 jstl 함수  --%>
							    		<c:choose>
							    			<c:when test="${book.catetwo_num == 1}">
							    				<c:set var="cateTwo" scope="session" value="프로그래밍 언어"/>
							    			</c:when>
							    			<c:when test="${book.catetwo_num == 2}">
							    				<c:set var="cateTwo" scope="session" value="OS/데이터베이스"/>
							    			</c:when>
							    			<c:when test="${book.catetwo_num == 3}">
							    				<c:set var="cateTwo" scope="session" value="웹프로그래밍"/>
							    			</c:when>
							    			<c:when test="${book.catetwo_num == 4}">
							    				<c:set var="cateTwo" scope="session" value="컴퓨터 입문/활용"/>
							    			</c:when>
							    			<c:when test="${book.catetwo_num == 5}">
							    				<c:set var="cateTwo" scope="session" value="네트워크/해킹/데이터베이스"/>
							    			</c:when>
							    			<c:when test="${book.catetwo_num == 6}">
							    				<c:set var="cateTwo" scope="session" value="IT 전문서"/>
							    			</c:when>
							    			<c:when test="${book.catetwo_num == 7}">
							    				<c:set var="cateTwo" scope="session" value="컴퓨터 수험서"/>
							    			</c:when>
							    			<c:otherwise>
							    				<c:set var="cateTwo" scope="session" value="웹/컴퓨터/입문 활용"/>
							    			</c:otherwise>
							    		</c:choose>	
						     
							    	<tr data-num="${book.stk_incp}">
							    		<td> ${book.stk_incp}</td>
							    		<td class="stkDetail">${book.b_name}</td>
							    		<td>${book.b_author }</td>
							    		<td>${book.stk_qty} 권</td>
							    		<td>${book.stk_salp}</td>
							    		
							    		<%-- <td>${book.cateone_num }</td> --%>
							    		<td>${cateOne}</td>
							    		
							    		
							    		
							    		<%-- <td>${book.catetwo_num }</td> --%>
							    		<td>${cateTwo}</td>
							    		<td>${book.adm_name}</td>
							    		<td>${book.stk_regdate}</td>
							    		<%--><td><input type="button" id="stkDetail" name="stkDetail" value="도서상세보기"/></td>  --%>
							    	</tr>
							    	</c:forEach>
							   </c:when>
							   <c:otherwise>
							   		<td colspan="9" class="text-center">현재 재고가 없는 책입니다.</td>
							   </c:otherwise> 	
				    	</c:choose>
				    </tbody>
				  </table>
			</div>
	 	</div>
	</div>
	<hr>	
	
	
	<%--
		--------------------재고 도서 상세 정보를 위한 쿼리문----------------------------------------------------------
		
		----stock_book_info view 생성 -------------------------------------------------------------------------
		create view stock_book_info as 
		select book.b_num, book.b_name, book.b_date, 
		book.b_author, book.b_pub, book.b_price, book.cateone_num, book.catetwo_num, bookimg.listcover_imgurl 
		from book 
		inner join 
		bookimg 
		on book.b_num=bookimg.b_num;
		-----------------------------------------------------------------------------------------------------
		
		------------도서 코드로 상세정보를 보여줄 모달을 위한 쿼리---------------------------------------------------------
		select b_num, b_name, b_date, b_author, b_pub, b_price, cateone_num, listcover_imgurl 
		from stock_book_info where b_num=3; 
		-----------------------------------------------------------------------------------------------------
		
	 --%>
		
	
   </body>
</html>
    