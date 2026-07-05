/* ================================================================
   SpendWise - Login Page JavaScript
   ================================================================ */
'use strict';

document.addEventListener('DOMContentLoaded', () => {

  const form     = document.getElementById('login-form');
  const emailEl  = document.getElementById('email');
  const passEl   = document.getElementById('password');

  /* ---- Real-time validation ---- */
  addBlurValidation('email', isValidEmail, 'Please enter a valid email address.');
  addBlurValidation('password', v => isNotEmpty(v), 'Password is required.');

  /* ---- Form submit ---- */
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    hideAlert('alert-container');

    const email    = emailEl.value.trim();
    const password = passEl.value;
    let   valid    = true;

    // Validate email
    if (!isNotEmpty(email)) {
      showError('email', 'Email address is required.');
      valid = false;
    } else if (!isValidEmail(email)) {
      showError('email', 'Please enter a valid email address.');
      valid = false;
    } else {
      showSuccess('email');
    }

    // Validate password
    if (!isNotEmpty(password)) {
      showError('password', 'Password is required.');
      valid = false;
    } else {
      showSuccess('password');
    }

    if (!valid) return;

    // Show loading
    setButtonLoading('login-btn', true);

    // Submit after brief delay (for UX feel)
    setTimeout(() => { form.submit(); }, 400);
  });

  /* ---- Enter key triggers submit ---- */
  [emailEl, passEl].forEach(el => {
    el.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') form.dispatchEvent(new Event('submit'));
    });
  });
});

/* ---- Social login placeholder ---- */
function socialLogin(provider) {
  const btn = event.currentTarget;
  btn.innerHTML = `<span style="font-size:13px;color:#6B7280">Connecting to ${provider}...</span>`;
  btn.disabled  = true;
  setTimeout(() => {
    btn.disabled = false;
    btn.innerHTML = provider === 'google'
      ? `<img src="https://www.google.com/favicon.ico" style="width:18px"/> Google`
      : `<i class="fa-brands fa-facebook" style="color:#1877F2;font-size:18px"></i> Facebook`;
    showAlert('alert-container', 'info',
      `${provider.charAt(0).toUpperCase() + provider.slice(1)} login will be available soon.`);
  }, 1200);
}
