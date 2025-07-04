document.addEventListener('DOMContentLoaded', function() {
    // 페이지네이션 관련 요소
    const postList = document.getElementById('postList');
    const prevButton = document.getElementById('prevButton');
    const nextButton = document.getElementById('nextButton');
    const searchInput = document.getElementById('searchInput');
    const searchBtn = document.querySelector('.search-btn');
    
    // 모든 게시글 요소 가져오기
    const allPosts = Array.from(postList.querySelectorAll('.post-card'));
    
    // 페이지네이션 상태
    let currentPage = 1;
    const postsPerPage = 5;
    const totalPosts = allPosts.length;
    const totalPages = Math.ceil(totalPosts / postsPerPage);
    
    console.log('페이지네이션 초기화:', { 
        totalPosts, 
        totalPages, 
        visiblePosts: document.querySelectorAll('.post-card[style="display: block;"]').length 
    });
    
    // 초기 설정
    updatePageDisplay();
    
    // 이전 버튼 클릭 이벤트 (이벤트 리스너 중복 방지를 위해 onclick 사용)
    prevButton.onclick = function() {
        console.log('이전 버튼 클릭');
        if (currentPage > 1) {
            currentPage--;
            updatePageDisplay();
        }
    };
    
    // 다음 버튼 클릭 이벤트 (이벤트 리스너 중복 방지를 위해 onclick 사용)
    nextButton.onclick = function() {
        console.log('다음 버튼 클릭');
        if (currentPage < totalPages) {
            currentPage++;
            updatePageDisplay();
        }
    };
    
    // 검색 버튼 클릭 이벤트
    searchBtn.addEventListener('click', function() {
        searchPosts();
    });
    
    // 엔터 키 검색 이벤트
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchPosts();
        }
    });
    
    // 페이지 업데이트 함수
    function updatePageDisplay() {
        console.log('페이지 업데이트:', { currentPage, totalPages });
        
        // 모든 포스트 숨기기
        allPosts.forEach(post => {
            post.style.display = 'none';
        });
        
        // 현재 페이지에 해당하는 포스트만 표시
        const startIndex = (currentPage - 1) * postsPerPage;
        const endIndex = Math.min(startIndex + postsPerPage, totalPosts);
        
        console.log('표시할 인덱스 범위:', { startIndex, endIndex });
        
        let displayCount = 0;
        for (let i = startIndex; i < endIndex; i++) {
            if (allPosts[i]) {
                allPosts[i].style.display = 'block';
                displayCount++;
            }
        }
        
        console.log('실제로 표시된 게시글 수:', displayCount);
        
        // 버튼 상태 업데이트
        prevButton.disabled = currentPage === 1;
        nextButton.disabled = currentPage === totalPages || totalPosts === 0;
        
        // 시각적으로 버튼 상태 표시
        prevButton.style.opacity = prevButton.disabled ? 0.5 : 1;
        nextButton.style.opacity = nextButton.disabled ? 0.5 : 1;
        
        // 명시적으로 event listener 다시 연결 (이벤트 리스너가 사라지는 경우 대비)
        prevButton.onclick = function() {
            if (currentPage > 1) {
                currentPage--;
                updatePageDisplay();
            }
        };
        
        nextButton.onclick = function() {
            if (currentPage < totalPages) {
                currentPage++;
                updatePageDisplay();
            }
        };
    }
    
    // 게시글 검색 함수
    function searchPosts() {
        const searchTerm = searchInput.value.toLowerCase().trim();
        
        // 검색어가 비어있을 경우 모든 게시글 표시
        if (searchTerm === '') {
            resetSearch();
            return;
        }
        
        // 검색 결과에 맞는 게시글만 필터링
        let filteredPosts = allPosts.filter(post => {
            const title = post.querySelector('h3 a').textContent.toLowerCase();
            const content = post.querySelector('.post-content').textContent.toLowerCase();
            return title.includes(searchTerm) || content.includes(searchTerm);
        });
        
        // 필터링된 게시글만 표시
        allPosts.forEach(post => {
            post.style.display = 'none';
        });
        
        filteredPosts.slice(0, postsPerPage).forEach(post => {
            post.style.display = 'block';
        });
        
        // 검색 결과가 없을 경우 메시지 표시
        if (filteredPosts.length === 0) {
            const noResultsElement = document.createElement('div');
            noResultsElement.className = 'no-results';
            noResultsElement.textContent = '검색 결과가 없습니다.';
            postList.appendChild(noResultsElement);
        }
        
        // 페이지네이션 상태 업데이트
        currentPage = 1;
        prevButton.disabled = true;
        prevButton.style.opacity = 0.5;
        nextButton.disabled = filteredPosts.length <= postsPerPage;
        nextButton.style.opacity = filteredPosts.length <= postsPerPage ? 0.5 : 1;
    }
    
    // 검색 초기화 함수
    function resetSearch() {
        // 검색 결과 메시지 제거
        const noResults = postList.querySelector('.no-results');
        if (noResults) {
            postList.removeChild(noResults);
        }
        
        // 페이지네이션 초기화
        currentPage = 1;
        updatePageDisplay();
    }
}); 