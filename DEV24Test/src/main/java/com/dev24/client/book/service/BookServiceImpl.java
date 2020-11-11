package com.dev24.client.book.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.dev24.client.book.dao.BookDAO;
import com.dev24.client.book.vo.BookVO;
import com.dev24.client.bookimg.dao.BookImgDAO;
import com.dev24.client.bookimg.vo.BookImgVO;
import com.dev24.common.file.FileUploadUtil;
import com.dev24.common.pagination.Pagination;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class BookServiceImpl implements BookService {

	@Setter(onMethod_ = @Autowired)
	private BookDAO bookDAO;

	@Setter(onMethod_ = @Autowired)
	private BookImgDAO bookimgDAO;

	@Override
	public ArrayList<BookVO> bookViewList(Pagination pagination) {
		ArrayList<BookVO> list = bookDAO.bookViewList(pagination);
		return list;
	}

	@Override
	public int getBookListCnt() {
		int result = bookDAO.getBookListCnt();
		return result;
	}

	/**
	 * @Transactional: 트랜잭션 기능이 적용된 프록시 객체가 생성됨. 
	 * 				   - 한 트랜잭션 내에서 실행한 작업들은 하나로 간주한다.
	 *  				  모두성공 또는 모두실패
	 */
	@Transactional
	@Override
	public int bookInsert(BookVO bvo) throws Exception {
		
		int result = 0;
		String listcoverPath = null;
		String detailcoverPath = null;
		String detailPath = null;

		BookImgVO bookimgVO = null;

		int b_num = bookDAO.bookNumber();
		bvo.setB_num(b_num);

		result = bookDAO.bookInsert(bvo);

		MultipartFile listcoverFile = bvo.getListcoverFile();
		MultipartFile detailcoverFile = bvo.getDetailcoverFile();
		MultipartFile detailFile = bvo.getDetailFile();

		if (listcoverFile != null)
			listcoverPath = FileUploadUtil.bookImgUpload(listcoverFile, bvo, "listcover");
		if (detailcoverFile != null)
			detailcoverPath = FileUploadUtil.bookImgUpload(detailcoverFile, bvo, "detailcover");
		if (detailFile != null)
			detailPath = FileUploadUtil.bookImgUpload(detailFile, bvo, "detail");

		log.info(listcoverPath);
		log.info(detailcoverPath);
		log.info(detailPath);

		bookimgVO = new BookImgVO();
		bookimgVO.setB_num(b_num);
		bookimgVO.setListcover_imgurl(listcoverPath);
		bookimgVO.setDetail_imgurl(detailcoverPath);
		bookimgVO.setDetail_imgurl(detailPath);
		
		bookimgDAO.bookImgInsert(bookimgVO);

		return result;
	}
	
	@Override
	public BookVO bookDetail(int b_num) {
		BookVO vo = bookDAO.bookDetail(b_num);
		return vo;
	}
}
