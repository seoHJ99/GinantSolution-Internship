package com.com.com.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.com.com.dto.BoardDTO;
import com.com.com.vo.BoardVO;
import com.com.com.dto.DownloadFileDTO;
import com.com.com.project.dto.EmployeeDTO;

public interface BoardMapper {
	List<BoardVO> findAll();
	List<BoardVO> findWithAjax(@Param("findBy")String findBy, @Param("content") String content,
			@Param("startDate")String startDate,@Param("endDate") String endDate,
			@Param("start") int start, @Param("end")int end);
	int insert(BoardDTO dto);
	Map<String, Object> findOne(int no);
	void modifyBoard(Map<String, Object> map);
	void delete (List<String> noList);
	List<BoardVO> findByTitle (@Param("findBy")String findBy, @Param("content") String content,
			@Param("startDate")String startDate,@Param("endDate") String endDate);
	void insertFile(Map<String, Object> map);
	List<DownloadFileDTO> findFile(@Param("listSeq")int listSeq);
//	
//	
//	
	EmployeeDTO findUser(@Param("id")String id);
	List<com.com.com.project.dto.BoardDTO> findUserBoard(@Param("id") String id);
	List<com.com.com.project.dto.BoardDTO> findUserBoardWithAuthority(Map<String, Object> map);
	com.com.com.project.dto.BoardDTO findOneBoard(@Param("seq") int seq);
	void insertHistory(Map<String, Object> map);
	void updateBoard(Map<String, Object> map);
	List<com.com.com.project.dto.BoardDTO> findBoardHistory(int seq);
	void insertBoard(@Param("map")Map<String, Object> map);
	List<com.com.com.project.dto.BoardDTO> normalSearch(Map<String, Object> map);
	List<com.com.com.project.dto.BoardDTO>findByState(
			@Param("state")String state,
			@Param("id")String id,
			@Param("name")String name,
			@Param("authority")String authority);
	List<EmployeeDTO> findSubordinate(@Param("authority") String authority);
	void submmitRepresentation(Map<String, Object> map);
	void rollbackAuthority(@Param("id") String id);
}
