window.addEventListener("DOMContentLoaded", function () {
  const postListDiv = document.querySelector(".post-list");
  const favoriteListEl = document.querySelector("aside ul"); // 즐겨찾기 영역

  let postList = JSON.parse(localStorage.getItem("postList") || "[]");

  function renderPosts() {
    postListDiv.innerHTML = "";

    postList.forEach((post, index) => {
      const postDiv = document.createElement("div");
      postDiv.className = "post";
      postDiv.innerHTML = `
          <h3>[${post.subject}] ${post.category}</h3>
          <p>${post.question}</p>
          <div class="meta">
            <span class="like" data-index="${index}" style="cursor: pointer;">
              ❤️ ${post.likes}
            </span>
            <button class="delete" data-index="${index}" style="margin-left: 10px background-color: #eeeeee08; border:none;">🗑️</button>
            ⏱️ ${new Date().toLocaleString("ko-KR", {
              month: "2-digit",
              day: "2-digit",
              hour: "2-digit",
              minute: "2-digit",
            })}
          </div>
        `;

      // ✅ 게시글 클릭 시 view.html 이동 (좋아요/삭제 버튼 제외)
      postDiv.addEventListener("click", (e) => {
        const isLike = e.target.classList.contains("like");
        const isDelete = e.target.classList.contains("delete");

        if (!isLike && !isDelete) {
          localStorage.setItem("viewPostId", index);
          window.location.href = "../../../../../../../templates(5-12)/post_view/view.html";
        }
      });

      postListDiv.appendChild(postDiv);
    });

    renderFavorites();
  }

  function renderFavorites() {
    if (!favoriteListEl) return;

    favoriteListEl.innerHTML = "";
    postList
      .filter((post) => post.likes > 0)
      .slice(0, 5)
      .forEach((post) => {
        const li = document.createElement("li");
        li.textContent = `❤️ [${post.subject}] ${post.category}`;
        favoriteListEl.appendChild(li);
      });
  }

  postListDiv.addEventListener("click", function (e) {
    const index = e.target.dataset.index;

    if (e.target.classList.contains("like")) {
      postList[index].likes = postList[index].likes === 0 ? 1 : 0;
      localStorage.setItem("postList", JSON.stringify(postList));
      renderPosts();
    }

    if (e.target.classList.contains("delete")) {
      if (confirm("이 글을 삭제하시겠습니까?")) {
        postList.splice(index, 1);
        localStorage.setItem("postList", JSON.stringify(postList));
        renderPosts();
      }
    }
  });

  renderPosts();
});
