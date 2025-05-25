document.addEventListener('DOMContentLoaded', () => {
  const buttons = document.querySelectorAll('.question-type-button');
  buttons.forEach(button => {
    button.addEventListener('click', () => {
      // Remove 'active' class from all buttons
      buttons.forEach(btn => btn.classList.remove('active'));
      // Add 'active' class to the clicked button
      button.classList.add('active');
    });
  });
});