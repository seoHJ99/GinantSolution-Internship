package com.com.com.project.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.com.com.project.dto.BoardDTO;
import com.com.com.project.dto.EmployeeDTO;
import com.com.com.project.dao.ProjectBoardDAO;

@Service
public class ProjectBoardService {

	@Autowired
	private ProjectBoardDAO boardDAO;

	// 사용자가 존재하는지 확인
	public boolean exsistUser(String id) {
		EmployeeDTO employeeDTO = boardDAO.findUser(id);
		if (employeeDTO != null) {
			return true;
		}
		return false;
	}
	
	// id값으로 유저 찾기
	public EmployeeDTO findUser(String id) {
		EmployeeDTO employeeDTO = boardDAO.findUser(id);
		return employeeDTO;
	}
	
	// 유저 권한에 따른 게시판 찾기
	public List<BoardDTO> findUserBoard(HttpSession session) {
		String id = session.getAttribute("id").toString();
		String authority = session.getAttribute("authority").toString();
		String name = session.getAttribute("name").toString();
		Object authorityTime = session.getAttribute("authorityTime");
		Map<String, Object> map = new HashMap<>();
		map.put("id", id);
		map.put("authority", authority);
		map.put("name", name);
		map.put("authorityTime", authorityTime);
		// 유저 권한이 관리자 급일때
		if (Integer.parseInt(authority) > 2) {
			map.put("originalAuthority", session.getAttribute("originalAuthority"));
		}
		return boardDAO.findUserBoardWithAuthority(map);
	}

	// 하나의 게시글 조회
	public BoardDTO findOneBoard(int seq) {
		return boardDAO.findOneBoard(seq);
	}

	// 임시 저장
	public void tempSave(Map<String, Object> map, HttpSession session) {
		map.put("approval", null);
		// 처음 쓰는 글일 경우
		if (map.get("first") != null) {
			map.put("regDate", LocalDateTime.now());
			boardDAO.insertBoard(map);
		} else {
	    // 기존에 임시저장, 또는 반려된 글이 있을 경우
			map.put("approDate", null);
			boardDAO.updateBoard(map);
		}
		map.put("approval", session.getAttribute("id"));
		map.put("approDate", LocalDateTime.now());
		boardDAO.insertHistory(map);
	}

	// 게시글 내역 조회
	public List<BoardDTO> findBoardHistory(int seq) {
		return boardDAO.findBoardHistory(seq);
	}

	// 반려, 결제 등의 요청이 들어올때 상태를 변환하는 코드
	public void changeState(Map<String, Object> map, HttpSession session) {
		int authority = Integer.parseInt(session.getAttribute("authority").toString());
		// 관리자 급이 아닐때
		if(authority >2) {
			map.put("name", session.getAttribute("name"));
			map.put("approDate", LocalDateTime.now());
			if(session.getAttribute("representation") != null) {
				map.put("represent", session.getAttribute("representation"));
			}
		}else {
			map.put("name", null);
			map.put("approDate", null);
		}
		// 과장일때는 바로 결재중으로
		if (map.get("state").equals("READY") && authority == 3) { 
			map.put("state", "PROCESS");
			map.put("approval", session.getAttribute("id"));
	    // 부장일때는 바로 결재 완료로
		} else if ((map.get("state").equals("PROCESS") || map.get("state").equals("READY")) && authority == 4) {
			map.put("state", "DONE");
			map.put("approval", session.getAttribute("id"));
		}
		// 처음쓰는 글일때는 새로 등록
		if(map.get("first") != null) {
			map.put("regDate", LocalDateTime.now());
			map.put("representation", session.getAttribute("representation"));
			boardDAO.insertBoard(map);
		}else {
		// 이미 있는 글일때는 업데이트
			boardDAO.updateBoard(map);
		}
		map.put("name", session.getAttribute("name"));
		map.put("approDate", LocalDateTime.now());
		boardDAO.insertHistory(map);
	}
	
	// 일반 검색
	public List<BoardDTO> normalSearch(Map<String, Object> map) {
		return boardDAO.normalSearch(map);
	}

	// 결재 상태만 검색
	public List<BoardDTO> ajaxSearch(String state, HttpSession session) {
		String id = session.getAttribute("id").toString();
		String authority = session.getAttribute("authority").toString();
		String name = session.getAttribute("name").toString();
		return boardDAO.findByState(state, id, name, authority);
	}
	
	// 2단계 아래까지 부하직원 찾기
	public List<EmployeeDTO> findSubordinate(String authority){ 
		return boardDAO.findSubordinate( authority);
	}
	
	// 대리 결재자 승인
	public void submmitRepresentation(Map<String, Object> map) {
		map.put("authorityTime", LocalDateTime.now());
		boardDAO.submmitRepresentation(map);
	}
	
	// 대리 결재 권한 시간이 지났는지 확인
	public boolean checkAuthorityTime(HttpSession session) { 
		Optional<Object>option = Optional.ofNullable(session.getAttribute("authorityTime"));
		if(option.isPresent()) {
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yy/MM/dd HH:mm:ss.SSSSSSSSS");
			LocalDateTime dateTime = LocalDateTime.parse(option.get().toString(), formatter);
			if(LocalDateTime.now().isAfter(dateTime.plusHours(6))) {
				boardDAO.rollbackAuthority(session.getAttribute("id").toString());
				return false;
			}
		}
		return true;
	}
}
