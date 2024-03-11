package com.com.com.project.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.com.com.project.dto.EmployeeDTO;
import com.com.com.project.service.ProjectBoardService;

@Controller
@RequestMapping("/project")
public class ProjectBoardController {

	@Autowired
	private ProjectBoardService boardService;

	@RequestMapping("/login")
	public String loginForm() {
		return "/project/login";
	}

	@ResponseBody
	@RequestMapping(value = "/login/action", produces = "text/html;charset=UTF-8")
	public String loginAction(@RequestParam("id") String id, @RequestParam("password") String password,
			HttpSession session) {
		EmployeeDTO employee = boardService.findUser(id);
		// 유효성 체크
		if (employee == null) {
			return "<script>" + "alert('등록된 사용자가 없습니다.');" + "history.back();" + " </script>";
		}else if (!employee.getPassword().equals(password)) {
			return "<script>" + "alert('비밀번호가 틀립니다.');" + "history.back();" + " </script>";
		}
		// id와 비번이 일치하면 유저 정보session 등록
		else if (id.equals(employee.getId()) && password.equals(employee.getPassword())) {
			session.setAttribute("id", id);
			if (employee.getAuthorityTime() != null) {
				session.setAttribute("authorityTime", employee.getAuthorityTime());
				session.setAttribute("representation", employee.getRepresentation());
			}
			session.setAttribute("pw", employee.getPassword());
			session.setAttribute("seq", employee.getSeq());
			session.setAttribute("name", employee.getName());
			session.setAttribute("originalAuthority", employee.getOriginalAuthority());
			if (boardService.checkAuthorityTime(session)) {
				session.setAttribute("authority", employee.getAuthority());
			}else {
				// 권한을 부여받았다 시간 지난 이후 새롭게 로그인할 경우
				session.setAttribute("authority", employee.getOriginalAuthority());
			}
		}
		return "<script>location.href = '/project/board'</script>";
	}

	@RequestMapping("logout/action")
	public String logout(HttpSession session) {
		session.invalidate();
		return "/project/login";
	}

	@RequestMapping("/board")
	public String mainBoard(HttpSession session, Model model) {
		boardService.checkAuthorityTime(session);

		if (session.getAttribute("id") == null) {
			return "/project/login";
		}
		
		EmployeeDTO dto = boardService.findUser(session.getAttribute("id").toString());
		model.addAttribute("board", boardService.findUserBoard(session));
		model.addAttribute("employee", dto);
		// 권한을 부여받은 상태일 경우, 부여해준 유저 정보도 전송
		if (dto.getRepresentation() != null) { 
			model.addAttribute("representation", boardService.findUser(dto.getRepresentation()));
		}
		return "/project/board";
	}

	@RequestMapping("/board/{seq}")
	public String oneBoard(@PathVariable("seq") int seq, Model model, HttpSession session) {
		boardService.checkAuthorityTime(session);

		if (session.getAttribute("id") == null) {
			return "/project/login";
		}
		model.addAttribute("authority", session.getAttribute("authority"));
		model.addAttribute("originalAuthority", session.getAttribute("originalAuthority"));
		model.addAttribute("board2", boardService.findOneBoard(seq));
		model.addAttribute("list", boardService.findBoardHistory(seq));
		model.addAttribute("id", session.getAttribute("id"));
		if (session.getAttribute("authorityTime") != null) {
			model.addAttribute("representation", session.getAttribute("representation"));
		}
		return "/project/writing";
	}

	@RequestMapping("/board/save")
	public String tempSave(@RequestParam Map<String, Object> map, HttpSession session) {
		boardService.checkAuthorityTime(session);

		if (session.getAttribute("id") == null) {
			return "/project/login";
		}
		
		boardService.tempSave(map, session);
		return "redirect: /project/board";
	}

	@RequestMapping("/board/request")
	public String requestApproval(@RequestParam Map<String, Object> map, HttpSession session) {
		boardService.checkAuthorityTime(session);

		if (session.getAttribute("id") == null) {
			return "/project/login";
		}
		
		boardService.changeState(map, session);
		return "redirect: /project/board";
	}

	@RequestMapping("/board/reject")
	public String rejectRequest(@RequestParam Map<String, Object> map, HttpSession session) {
		boardService.checkAuthorityTime(session);

		if (session.getAttribute("id") == null) {
			return "/project/login";
		}
		
		boardService.changeState(map, session);
		return "redirect: /project/board";

	}

	@RequestMapping("/writing")
	public String writingBoard(@RequestParam Map<String, Object> map, HttpSession session, Model model) {
		boardService.checkAuthorityTime(session);

		if (session.getAttribute("id") == null) {
			return "/project/login";
		}
		
		model.addAttribute("name", session.getAttribute("name"));
		model.addAttribute("id", session.getAttribute("id"));
		return "/project/writing";
	}

	@RequestMapping("/search")
	public String normalSearch(Model model, @RequestParam Map<String, Object> map, HttpSession session) {
		boardService.checkAuthorityTime(session);

		if (session.getAttribute("id") == null) {
			return "/project/login";
		}
		
		EmployeeDTO dto = boardService.findUser(session.getAttribute("id").toString());
		model.addAttribute("board", boardService.normalSearch(map));
		model.addAttribute("employee", dto);
		model.addAttribute("map", map);
		return "/project/board";
	}

	@RequestMapping("/state/search")
	public String ajaxSearch(@RequestParam("state") String state, HttpSession session, Model model) {
		boardService.checkAuthorityTime(session);

		model.addAttribute("board", boardService.ajaxSearch(state, session));
		return "/project/ajaxBoard";
	}

	@RequestMapping("/representation")
	public String popup(Model model, HttpSession session) {
		boardService.checkAuthorityTime(session);

		model.addAttribute("emplist", boardService.findSubordinate(session.getAttribute("authority").toString()));
		model.addAttribute("user", boardService.findUser(session.getAttribute("id").toString()));
		return "/project/popup";
	}

	@ResponseBody
	@RequestMapping(value = "/representation/submmit",produces = "text/html;charset=UTF-8")
	public String submmitRepresentation(@RequestParam Map<String, Object> map, HttpSession session) {
		boardService.checkAuthorityTime(session);
		map.put("representation", session.getAttribute("id").toString());
		boardService.submmitRepresentation(map);
		return "<script>"
				+ "alert(\"승인되었습니다.\");"
				+ "window.close();</script>";
	}
}
