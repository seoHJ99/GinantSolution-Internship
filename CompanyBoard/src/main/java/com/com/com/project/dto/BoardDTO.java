package com.com.com.project.dto;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardDTO {
	private int seq;
	private String id;
	private String name;
	private String content;
	private LocalDate regDate;
	private LocalDate approDate;
	private String approval;
	private String state;
	private String title;
	private int no;
	private String representApproval;
}
