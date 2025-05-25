document.addEventListener("DOMContentLoaded", function () {
  const submitButton = document.querySelector(".submit");
  const cancelButton = document.querySelector(".cancel");

  submitButton.addEventListener("click", function () {
    const subject = document.querySelectorAll(".input")[0].value;
    const category = document.querySelectorAll(".input")[1].value;
    const question = document.querySelectorAll(".textarea")[0].value;
    const explanation = document.querySelectorAll(".textarea")[1].value;

    if (!subject || !category || !question) {
      alert("모든 항목을 입력해주세요!");
      return;
    }

    const post = {
      subject,
      category,
      question,
      explanation,
      likes: 0,
      time: "방금 전",
    };

    const postList = JSON.parse(localStorage.getItem("postList") || "[]");
    postList.unshift(post);
    localStorage.setItem("postList", JSON.stringify(postList));

    window.location.href = "../../../../../../../templates(5-12)/post_list/Post.html";
  });

  // ✅ 취소 버튼 누르면 이전 페이지로 이동
  cancelButton.addEventListener("click", function () {
    window.history.back(); // ← 이전 페이지로 이동
  });
});
