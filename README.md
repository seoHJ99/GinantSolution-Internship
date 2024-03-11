자이언트 솔루션 인턴 - 대리 결재 사내 게시판 개발
==========================

환경)
------
언어 : Java
프레임워크 : Srping-Lagacy
템플릿 : JSP
DB: Oracle
IDE: Eclipse

설명)
-------
###결재 단계:
임시 저장 - 결재 요청 - 결재 중 - 결재 완료

###결재자:
과장 : <결재 요청> -> <결재중> 으로 결재
부장 : <결재 중> -> <결재 완료> 로 결재

###대리 결재:
2직급 이하인 직원에게 권한 부여 불가.
과장 -> 사원 : 가능
과장 -> 대리 : 가능
부장 -> 과장 : 가능
부장 -> 대리 : 가능
부장 -> 사원 : 불가능


###기본 상태:
사원: 임시 저장글, 본인의 작성글만 확인 가능
대리: 임시 저장글, 본인의 작성글만 확인 가능
과장: 임시 저장글, 본인의 작성글, <결재 요청> 상태의 모든 글, 본인이 결재한 글만 확인 가능
부장: 임시 저장글, 본인의 작성글, <결재 중> 상태의 모든 글, <결재 완료> 상태의 모든 글 확인 가능.

결재 요청 - 과장급, 결재 요청 올린 당사자만 보임
결재 확인 - 부장급, 결재 요청 통과시킨 과장, 결재 당사자만 보임

ex1) 부장1 -> 과장1에게 대리 결재 권한
결재 요청 - 기본과 똑같음
결재 확인 - 권한을 받은 시점부터의 <결재 중> 결재, <결재 완료> 글 확인 가능

ex2) 과장1 -> 사원1에게 대리 결재 권한
결재 요청 - 권한을 받은 시점부터 본인이 올린 <결재 요청> 결재 가능. 다른 직원의 <결재 요청> 확인 불가
결재 확인 -> 기본과 동일