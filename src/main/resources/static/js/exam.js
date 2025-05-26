document.addEventListener('DOMContentLoaded', () => {
  const buttons = document.querySelectorAll('.question-type-button');
  
  buttons.forEach(button => {
    button.addEventListener('click', function() {
      // Remove 'active' class from all buttons
      buttons.forEach(btn => btn.classList.remove('active'));
      
      // Add 'active' class to the clicked button
      this.classList.add('active');
      
      // Update hidden input value
      document.getElementById('questionType').value = this.dataset.value;
    });
  });

  // Initialize with the default value (객관식 = 1)
  const activeButton = document.querySelector('.question-type-button.active');
  if (activeButton) {
    document.getElementById('questionType').value = activeButton.dataset.value;
  }
});