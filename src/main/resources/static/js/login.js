// login.js (수정)
document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector("form");

  if (form) {
    form.addEventListener("submit", (e) => {
      // input[name="username"]으로 변경 (HTML의 th:field="*{username}"과 일치)
      const idInput = form.querySelector('input[name="username"]');
      const pwInput = form.querySelector('input[name="password"]'); // 비밀번호는 이미 "password"로 일치

      if (!idInput || !pwInput) {
        console.error("아이디 또는 비밀번호 입력 필드를 찾을 수 없습니다.");
        e.preventDefault();
        return;
      }

      const id = idInput.value.trim();
      const pw = pwInput.value.trim();

      if (!id || !pw) {
        e.preventDefault();
        alert("아이디와 비밀번호를 모두 입력해주세요.");
      }
    });
  } else {
    console.error("로그인 폼을 찾을 수 없습니다.");
  }
});