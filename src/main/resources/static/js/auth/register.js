/* ================================================================
   SpendWise - Register Page JavaScript
   ================================================================ */
'use strict';

document.addEventListener('DOMContentLoaded', () => {

  const form        = document.getElementById('register-form');
  const passwordEl  = document.getElementById('password');
  const confirmEl   = document.getElementById('confirmPassword');
  const strengthBox = document.getElementById('strength-container');

  /* ---- Password strength live update ---- */
  passwordEl.addEventListener('input', () => {
    const val = passwordEl.value;
    strengthBox.style.display = val.length ? 'block' : 'none';
    updateStrengthBars(val);
  });

  /* ---- Real-time blur validation ---- */
  addBlurValidation('fullName', v => isNotEmpty(v) && v.trim().length >= 2,
    'Full name must be at least 2 characters.');
  addBlurValidation('email', isValidEmail, 'Please enter a valid email address.');
  addBlurValidation('password', v => v.length >= 8,
    'Password must be at least 8 characters.');

  confirmEl.addEventListener('blur', () => {
    if (confirmEl.value !== passwordEl.value)
      showError('confirmPassword', 'Passwords do not match.');
    else showSuccess('confirmPassword');
  });

  /* ---- Form submit ---- */
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    hideAlert('alert-container');
    let valid = true;

    const name     = document.getElementById('fullName').value.trim();
    const email    = document.getElementById('email').value.trim();
    const password = passwordEl.value;
    const confirm  = confirmEl.value;
    const terms    = document.getElementById('terms').checked;

    // Full name
    if (!isNotEmpty(name) || name.length < 2) {
      showError('fullName', 'Full name must be at least 2 characters.'); valid = false;
    } else { showSuccess('fullName'); }

    // Email
    if (!isValidEmail(email)) {
      showError('email', 'Please enter a valid email address.'); valid = false;
    } else { showSuccess('email'); }

    // Password
    if (password.length < 8) {
      showError('password', 'Password must be at least 8 characters.'); valid = false;
    } else { showSuccess('password'); }

    // Confirm
    if (confirm !== password) {
      showError('confirmPassword', 'Passwords do not match.'); valid = false;
    } else if (isNotEmpty(confirm)) { showSuccess('confirmPassword'); }

    // Terms
    if (!terms) {
      showError('terms', 'You must agree to the Terms & Conditions.'); valid = false;
    } else { clearError('terms'); }

    if (!valid) return;

    setButtonLoading('register-btn', true);
    setTimeout(() => { form.submit(); }, 400);
  });
});

function socialSignup(provider) {
  showAlert('alert-container', 'info',
    `${provider.charAt(0).toUpperCase() + provider.slice(1)} signup will be available soon.`);
}
