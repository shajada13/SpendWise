/* ================================================================
   SpendWise - Forgot Password JavaScript
   ================================================================ */
'use strict';

document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('forgot-form');

  addBlurValidation('email', isValidEmail, 'Please enter a valid email address.');

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    hideAlert('alert-container');
    const email = document.getElementById('email').value.trim();

    if (!isValidEmail(email)) {
      showError('email', 'Please enter a valid email address.');
      return;
    }
    showSuccess('email');
    setButtonLoading('send-btn', true);

    // Simulate API call
    setTimeout(() => {
      setButtonLoading('send-btn', false);
      document.getElementById('form-state').style.display    = 'none';
      document.getElementById('success-state').style.display = 'block';
      document.getElementById('success-email-msg').textContent =
        `We have sent a password reset link to ${email}.`;
    }, 1500);
  });
});

function resendEmail() {
  showAlert('alert-container', 'success', 'Reset link resent! Please check your email.');
}
