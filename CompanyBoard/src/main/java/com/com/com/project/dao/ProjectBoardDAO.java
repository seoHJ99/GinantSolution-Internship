package com.com.com.project.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.com.com.project.dto.BoardDTO;
import com.com.com.project.dto.EmployeeDTO;
import com.com.com.mapper.BoardMapper;

@Repository
public class ProjectBoardDAO {
	
	@Autowired
	private SqlSessionTemplate sessionTemplate;
	
	@Autowired
	private BoardMapper mapper;
	
	public EmployeeDTO findUser(String id) {
		return mapper.findUser(id);
	}

	public List<BoardDTO> findUserBoard(String id){
		return mapper.findUserBoard(id);
	}
	
	public List<BoardDTO> findUserBoardWithAuthority(Map<String, Object> map){
		return mapper.findUserBoardWithAuthority(map);
	}
	
	public BoardDTO findOneBoard(int seq) {
		return mapper.findOneBoard(seq);
	}
	
	public void insertHistory(Map<String, Object> map) {
		System.out.println(map);
		mapper.insertHistory(map);
	}
	
	public void updateBoard(Map<String, Object> map) {
		mapper.updateBoard(map);
	}
	
	public List<BoardDTO> findBoardHistory(int seq){
		return mapper.findBoardHistory(seq);
	}

	public void insertBoard(Map<String, Object> map) {
		mapper.insertBoard(map);
	}
	
	public List<BoardDTO> normalSearch(Map<String, Object> map){
		System.out.println(map);
		return mapper.normalSearch(map);
	}
	
	public List<BoardDTO> findByState(String state, String id, String name, String authority){
		return mapper.findByState(state, id, name, authority);
	}
	
	public List<EmployeeDTO> findSubordinate(String authority){
		return mapper.findSubordinate(authority);
	}
	
	public void submmitRepresentation(Map<String, Object> map) {
		mapper.submmitRepresentation(map);
	}
	
	public 	void rollbackAuthority(String id) {
		mapper.rollbackAuthority(id);
	}
}
