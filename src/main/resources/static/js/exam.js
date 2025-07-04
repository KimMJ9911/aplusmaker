document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM loaded, initializing question type buttons...');
  
  const buttons = document.querySelectorAll('.question-type-button');
  const typeInput = document.getElementById('type-input');
  
  console.log('Found buttons:', buttons.length);
  console.log('Type input element:', typeInput);

  buttons.forEach((button, index) => {
    console.log(`Button ${index}:`, button.textContent, 'data-type:', button.dataset.type);
    
    button.addEventListener('click', function(e) {
      e.preventDefault(); // 폼 제출 방지
      
      console.log('Button clicked:', this.textContent, 'data-type:', this.dataset.type);
      
      // Remove 'active' class from all buttons
      buttons.forEach(btn => btn.classList.remove('active'));

      // Add 'active' class to the clicked button
      this.classList.add('active');

      // Update hidden input value
      if (typeInput) {
        typeInput.value = this.dataset.type;
        console.log('Updated type input value to:', typeInput.value);
      } else {
        console.error('Type input element not found!');
      }
    });
  });

  // Initialize with the default value (주관식 = 0)
  const activeButton = document.querySelector('.question-type-button.active');
  if (activeButton && typeInput) {
    typeInput.value = activeButton.dataset.type;
    console.log('Initialized with default value:', typeInput.value);
  }
  
  // 문제수 선택 변경 이벤트 추가
  const countSelect = document.querySelector('select[name="count"]');
  if (countSelect) {
    console.log('문제수 선택 드롭다운 초기화:', countSelect.id, countSelect.name);
    console.log('현재 선택된 문제수:', countSelect.value);
    console.log('옵션 목록:', Array.from(countSelect.options).map(opt => `${opt.value}: ${opt.text}`).join(', '));
    
    countSelect.addEventListener('change', function() {
      console.log('Count selection changed to:', this.value, '(' + this.options[this.selectedIndex].text + ')');
    });
  } else {
    console.error('문제수 선택 드롭다운을 찾을 수 없습니다!');
    // DOM에 있는 모든 select 요소 검색
    const allSelects = document.querySelectorAll('select');
    console.log('페이지에 있는 모든 select 요소:', Array.from(allSelects).map(el => `id=${el.id}, name=${el.name}`).join(', '));
  }
  
  // 폼 제출 시 검증 및 디버깅
  const form = document.querySelector('.search-form');
  if (form) {
    form.addEventListener('submit', function(e) {
      const countSelect = form.querySelector('select[name="count"]');
      const subjectInput = form.querySelector('input[name="subject"]');
      const keywordInput = form.querySelector('input[name="keyword"]');
      
      console.log('=== 폼 제출 시작 ===');
      console.log('count select element:', countSelect);
      console.log('count value:', countSelect ? countSelect.value : 'no count select');
      console.log('count selectedIndex:', countSelect ? countSelect.selectedIndex : 'no count select');
      console.log('count selected option text:', countSelect && countSelect.selectedIndex >= 0 ? countSelect.options[countSelect.selectedIndex].text : 'no selection');
      console.log('type:', typeInput ? typeInput.value : 'no type input');
      console.log('subject:', subjectInput ? subjectInput.value : 'no subject input');
      console.log('keyword:', keywordInput ? keywordInput.value : 'no keyword input');
      
      // 입력 검증
      let missingFields = [];
      
      // 문제수 검증
      if (!countSelect || !countSelect.value || countSelect.value === '') {
        missingFields.push('문제수');
      }
      
      // 과목 검증
      if (!subjectInput || !subjectInput.value.trim()) {
        missingFields.push('과목');
      }
      
      // 키워드 검증
      if (!keywordInput || !keywordInput.value.trim()) {
        missingFields.push('키워드');
      }
      
      // 문제유형 검증 (hidden input이 제대로 설정되었는지)
      if (!typeInput || typeInput.value === '' || typeInput.value === null) {
        missingFields.push('문제유형');
      }
      
      // 누락된 필드가 있으면 경고창 표시하고 제출 중단
      if (missingFields.length > 0) {
        e.preventDefault(); // 폼 제출 중단
        const message = `다음 항목을 입력해주세요:\n\n• ${missingFields.join('\n• ')}`;
        alert(message);
        
        // 첫 번째 누락된 필드에 포커스
        if (missingFields.includes('문제수') && countSelect) {
          countSelect.focus();
        } else if (missingFields.includes('과목') && subjectInput) {
          subjectInput.focus();
        } else if (missingFields.includes('키워드') && keywordInput) {
          keywordInput.focus();
        }
        
        return false;
      }
      
      // 모든 검증 통과 시 기본값 설정 (안전장치)
      if (countSelect && (!countSelect.value || countSelect.value === '')) {
        countSelect.value = '1';
        console.log('문제수가 선택되지 않아 기본값 1로 설정');
      }
      
      if (typeInput && (!typeInput.value || typeInput.value === '')) {
        typeInput.value = '0';
        console.log('문제유형이 설정되지 않아 기본값 0(주관식)으로 설정');
      }
      
      // 선택된 값들을 출력하고 form이 제출되기 직전에 확인
      console.log('폼 제출 최종 데이터:');
      console.log('count (최종):', countSelect ? countSelect.value : 'no count');
      console.log('type (최종):', typeInput ? typeInput.value : 'no type');
      console.log('subject (최종):', subjectInput ? subjectInput.value : 'no subject');
      console.log('keyword (최종):', keywordInput ? keywordInput.value : 'no keyword');
      
      // 기존 count select 요소의 값이 비어 있으면 명시적으로 1로 설정
      if (countSelect && (!countSelect.value || countSelect.value === '')) {
        countSelect.value = '1';
        console.log('count 값이 비어있어 명시적으로 설정: ' + countSelect.value);
      }
      
      // 추가: 실제로 선택된 값이 제출되는지 확인하기 위해 hidden input 추가
      // (기존 select가 제대로 동작하지 않을 경우를 대비)
      const hiddenCount = document.createElement('input');
      hiddenCount.type = 'hidden';
      hiddenCount.name = 'count_hidden';
      hiddenCount.value = countSelect && countSelect.value ? countSelect.value : '1';
      console.log('Hidden count 입력 추가: ' + hiddenCount.value);
      form.appendChild(hiddenCount);
      
      // URL 파라미터에 값 추가 확인
      console.log('폼 액션 URL:', form.action);
      
      // 폼 요소들 최종 확인
      console.log('폼 내 모든 입력 요소:');
      Array.from(form.elements).forEach(el => {
        console.log(`${el.name}: ${el.value} (type: ${el.type})`);
      });
      
      console.log('모든 검증 통과, 폼 제출 진행');
    });
  }
});