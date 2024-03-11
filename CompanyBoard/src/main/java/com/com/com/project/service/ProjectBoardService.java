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

	// ����ڰ� �����ϴ��� Ȯ��
	public boolean exsistUser(String id) {
		EmployeeDTO employeeDTO = boardDAO.findUser(id);
		if (employeeDTO != null) {
			return true;
		}
		return false;
	}
	
	// id������ ���� ã��
	public EmployeeDTO findUser(String id) {
		EmployeeDTO employeeDTO = boardDAO.findUser(id);
		return employeeDTO;
	}
	
	// ���� ���ѿ� ���� �Խ��� ã��
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
		// ���� ������ ������ ���϶�
		if (Integer.parseInt(authority) > 2) {
			map.put("originalAuthority", session.getAttribute("originalAuthority"));
		}
		return boardDAO.findUserBoardWithAuthority(map);
	}

	// �ϳ��� �Խñ� ��ȸ
	public BoardDTO findOneBoard(int seq) {
		return boardDAO.findOneBoard(seq);
	}

	// �ӽ� ����
	public void tempSave(Map<String, Object> map, HttpSession session) {
		map.put("approval", null);
		// ó�� ���� ���� ���
		if (map.get("first") != null) {
			map.put("regDate", LocalDateTime.now());
			boardDAO.insertBoard(map);
		} else {
	    // ������ �ӽ�����, �Ǵ� �ݷ��� ���� ���� ���
			map.put("approDate", null);
			boardDAO.updateBoard(map);
		}
		map.put("approval", session.getAttribute("id"));
		map.put("approDate", LocalDateTime.now());
		boardDAO.insertHistory(map);
	}

	// �Խñ� ���� ��ȸ
	public List<BoardDTO> findBoardHistory(int seq) {
		return boardDAO.findBoardHistory(seq);
	}

	// �ݷ�, ���� ���� ��û�� ���ö� ���¸� ��ȯ�ϴ� �ڵ�
	public void changeState(Map<String, Object> map, HttpSession session) {
		int authority = Integer.parseInt(session.getAttribute("authority").toString());
		// ������ ���� �ƴҶ�
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
		// �����϶��� �ٷ� ����������
		if (map.get("state").equals("READY") && authority == 3) { 
			map.put("state", "PROCESS");
			map.put("approval", session.getAttribute("id"));
	    // �����϶��� �ٷ� ���� �Ϸ��
		} else if ((map.get("state").equals("PROCESS") || map.get("state").equals("READY")) && authority == 4) {
			map.put("state", "DONE");
			map.put("approval", session.getAttribute("id"));
		}
		// ó������ ���϶��� ���� ���
		if(map.get("first") != null) {
			map.put("regDate", LocalDateTime.now());
			map.put("representation", session.getAttribute("representation"));
			boardDAO.insertBoard(map);
		}else {
		// �̹� �ִ� ���϶��� ������Ʈ
			boardDAO.updateBoard(map);
		}
		map.put("name", session.getAttribute("name"));
		map.put("approDate", LocalDateTime.now());
		boardDAO.insertHistory(map);
	}
	
	// �Ϲ� �˻�
	public List<BoardDTO> normalSearch(Map<String, Object> map) {
		return boardDAO.normalSearch(map);
	}

	// ���� ���¸� �˻�
	public List<BoardDTO> ajaxSearch(String state, HttpSession session) {
		String id = session.getAttribute("id").toString();
		String authority = session.getAttribute("authority").toString();
		String name = session.getAttribute("name").toString();
		return boardDAO.findByState(state, id, name, authority);
	}
	
	// 2�ܰ� �Ʒ����� �������� ã��
	public List<EmployeeDTO> findSubordinate(String authority){ 
		return boardDAO.findSubordinate( authority);
	}
	
	// �븮 ������ ����
	public void submmitRepresentation(Map<String, Object> map) {
		map.put("authorityTime", LocalDateTime.now());
		boardDAO.submmitRepresentation(map);
	}
	
	// �븮 ���� ���� �ð��� �������� Ȯ��
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
