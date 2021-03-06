package com.sist.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.dto.HospitalDTO;
import com.sist.dto.MemberDTO;
import com.sist.dto.ReservationDTO;
import com.sist.service.MemberService;
import com.sist.service.ReservationService;
import com.sist.utils.ValidUtils;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

	@Autowired
	private ReservationService reservationService;
	@Autowired
	private MemberService memberService;

	@PostMapping("/write.do")
	public String viewReservation(@RequestParam Map<String, Object> map, HttpSession session, Model model) {
		ReservationDTO reservationDTO = new ReservationDTO();
		int memberIdx = (Integer) session.getAttribute("memberIdx");
		MemberDTO memberDTO = memberService.selectMember(memberIdx);
		if(map.get("title").toString().equals("random")) {
			String address = memberDTO.getAddress();
			address = address.substring(address.indexOf(" ")+1);
			address = address.substring(0, address.indexOf(" "));
			List<HospitalDTO> hospitalList = reservationService.searchHospital(address);
			int random = (int)(Math.random() * hospitalList.size());
			reservationDTO.setTargetIdx(hospitalList.get(random).getIdx());
			reservationDTO.setTitle(hospitalList.get(random).getName());
		}else {
			reservationDTO.setTargetIdx(Integer.parseInt(map.get("targetIdx").toString()));
			reservationDTO.setTitle(map.get("title").toString());
		}
		reservationDTO.setTargetType(map.get("targetType").toString());
		reservationDTO.setMemberIdx(memberIdx);
		reservationDTO.setWriter(memberDTO.getNickname());
		model.addAttribute("reservationDTO", reservationDTO);

		model.addAttribute("main_jsp", "/member/reservation.jsp");
		return "main/main";
	}

	@PostMapping("/insert.do")
	@ResponseBody
	public boolean insertReservation(final ReservationDTO reservationDTO) {
		reservationDTO.setReservationTime(LocalDateTime.of(reservationDTO.getInputDate(), reservationDTO.getInputTime()));
		reservationDTO.setStatus(0);

		return reservationService.insertReservation(reservationDTO);
	}

	@PostMapping("/update.do")
	@ResponseBody
	public String updateReservation(@RequestParam(value = "idx") final Integer idx, @RequestParam(value = "status") final Integer status) {
		if(reservationService.updateReservation(idx, status)) {
			if(status == 1) {
				return "?????? ??????";
			}else {
				return "?????? ??????";
			}
		}else {
			return null;
		}
	}

	@PostMapping("/checkValidation.do")
	@ResponseBody
	public Map<String, String> checkValidation(@Valid final ReservationDTO reservationDTO,
			Errors errors) {
		Map<String, String> validatorResult = ValidUtils.validateHandling(errors);

		return validatorResult;
	}
}