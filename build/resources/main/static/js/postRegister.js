document.addEventListener("DOMContentLoaded", function () {
  const form = document.querySelector("form");
  const cancelButton = document.querySelector(".cancel");

  // 폼 제출 전 유효성 검사
  form.addEventListener("submit", function(event) {
    // input 요소들 선택
    const subjectName = document.getElementById("subjectName").value.trim();
    const keywords = document.getElementById("keywords").value.trim();
    const questionText = document.getElementById("questionText").value.trim();
    const answerText = document.getElementById("answerText").value.trim();

    // 유효성 검사
    if (!subjectName || !keywords || !questionText || !answerText) {
      event.preventDefault(); // 폼 제출 중단
      alert("모든 항목을 입력해주세요!");
      return false;
    }
    
    // 유효성 검사 통과 시 폼 제출 허용 (기본 동작)
    return true;
  });

  // 취소 버튼 이벤트 처리
  cancelButton.addEventListener("click", function() {
    window.history.back();
  });
});
