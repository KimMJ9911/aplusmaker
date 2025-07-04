document.addEventListener("DOMContentLoaded", () => {
    // 댓글 수정 버튼
    document.querySelectorAll('.edit-comment').forEach(btn => {
        btn.addEventListener('click', function() {
            const commentDiv = btn.closest('.comment');
            commentDiv.querySelector('.comment-content-view').style.display = 'none';
            commentDiv.querySelector('.comment-edit-form').style.display = 'block';
            btn.style.display = 'none';
        });
    });

    // 댓글 수정 취소 버튼
    document.querySelectorAll('.cancel-edit').forEach(btn => {
        btn.addEventListener('click', function() {
            const commentDiv = btn.closest('.comment');
            commentDiv.querySelector('.comment-content-view').style.display = 'block';
            commentDiv.querySelector('.comment-edit-form').style.display = 'none';
            commentDiv.querySelector('.edit-comment').style.display = 'inline-block';
        });
    });
});
