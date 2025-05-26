// register.js
document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("register-form");

  if (form) {
    form.addEventListener("submit", (e) => {
      const nameValue = document.getElementById("name")?.value.trim();
      const nicknameValue = document.getElementById("nickname")?.value.trim();
      const birthDateValue = document.getElementById("birth_date")?.value.trim();
      const usernameValue = document.getElementById("username")?.value.trim(); // '아이디' 필드
      const passwordValue = document.getElementById("password")?.value.trim();
      const pCheckValue = document.getElementById("p_check")?.value.trim(); // '비밀번호 확인' 필드
      const emailValue = document.getElementById("email")?.value.trim();
      const phoneValue = document.getElementById("phone")?.value.trim();

      // 필수 항목 유효성 검사 (필요에 따라 DTO의 NotEmpty 등과 유사하게 구성)
      if (!usernameValue || !passwordValue || !pCheckValue || !nameValue || !nicknameValue || !emailValue ) { // 생년월일, 전화번호는 선택적일 수 있음
        alert("이름, 닉네임, 아이디, 비밀번호, 이메일은 필수 항목입니다.");
        e.preventDefault();
        return;
      }

      if (passwordValue !== pCheckValue) {
        document.getElementById("passwordMatchStatus").textContent = "비밀번호가 일치하지 않습니다.";
        // alert("비밀번호가 일치하지 않습니다."); // alert 대신 p 태그에 메시지 표시 권장
        e.preventDefault();
        return;
      } else {
        document.getElementById("passwordMatchStatus").textContent = "";
      }

      if (birthDateValue && !/^\d{4}-\d{2}-\d{2}$/.test(birthDateValue)) {
        alert("생년월일은 YYYY-MM-DD 형식으로 입력해주세요.");
        e.preventDefault();
        return;
      }

      if (emailValue && (!emailValue.includes("@") || !emailValue.includes("."))) {
        alert("올바른 이메일 형식이 아닙니다.");
        e.preventDefault();
        return;
      }

      if (phoneValue && !/^\d+$/.test(phoneValue)) {
        alert("전화번호는 숫자만 입력해주세요.");
        e.preventDefault();
        return;
      }

      // 모든 클라이언트 검증 통과
    });
  } else {
    console.error("회원가입 폼(register-form)을 찾을 수 없습니다.");
  }

  // 비밀번호 일치 실시간 확인
  const passwordField = document.getElementById("password");
  const pCheckField = document.getElementById("p_check");
  const passwordMatchStatusEl = document.getElementById("passwordMatchStatus");

  function checkPasswordMatch() {
    if (passwordField && pCheckField && passwordMatchStatusEl) {
      if (passwordField.value !== "" && pCheckField.value !== "" && passwordField.value !== pCheckField.value) {
        passwordMatchStatusEl.textContent = "비밀번호가 일치하지 않습니다.";
      } else {
        passwordMatchStatusEl.textContent = "";
      }
    }
  }
  if (passwordField) passwordField.addEventListener("keyup", checkPasswordMatch);
  if (pCheckField) pCheckField.addEventListener("keyup", checkPasswordMatch);


  // 학교 인증 버튼 로직 (실제 API 연동 필요)
  const verifySchoolButton = document.getElementById("verifySchoolButton");
  const schoolNameInputEl = document.getElementById("schoolNameInput");
  const collAuthStatusInputEl = document.getElementById("coll_auth_status");
  const schoolAuthMessageEl = document.getElementById("schoolAuthMessage");

  if (verifySchoolButton) {
    verifySchoolButton.addEventListener("click", () => {
      const schoolName = schoolNameInputEl?.value.trim();
      if (!schoolName) {
        if (schoolAuthMessageEl) schoolAuthMessageEl.textContent = "학교 이름을 입력해주세요.";
        return;
      }
      alert(`학교 인증 시도: ${schoolName} (실제 인증 API 연동 필요)`);
      if (collAuthStatusInputEl) collAuthStatusInputEl.value = "true"; // 임시
      if (schoolAuthMessageEl) schoolAuthMessageEl.textContent = "학교 인증이 요청되었습니다."; // 임시
    });
  }
});