package com.com.com.project.dto;

import java.time.LocalDateTime;

import lombok.Getter;

@Getter
public class EmployeeDTO {
	private int seq;
	private String id;
	private String password;
	private String authority;
	private String name;
	private String originalAuthority;
	private String authorityTime;
	private String representation;
}
