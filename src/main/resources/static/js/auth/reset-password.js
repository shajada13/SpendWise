/* ================================================================
   SpendWise - Reset Password JavaScript
   ================================================================ */
'use strict';

document.addEventListener('DOMContentLoaded', () => {
  const form      = document.getElementById('reset-form');
  const newPassEl = document.getElementById('newPassword');
  const confEl    = document.getElementById('confirmPassword');
  const strength  = document.getElementById('strength-container');

  /* ---- Live requirements check ---- */
  newPassEl.addEventListener('input', () => {
    const v = newPassEl.value;
    strength.style.display = v.length ? 'block' : 'none';
    updateStrengthBars(v);
    updateReqs(v);
  });

  function updateReqs(v) {
    setReq('req-length',  v.length >= 8);
    setReq('req-upper',   /[A-Z]/.test(v));
    setReq('req-number',  /[0-9]/.test(v));
    setReq('req-special', /[^A-Za-z0-9]/.test(v));
  }

  function setReq(id, met) {
    const el = document.getElementById(id);
    if (!el) return;
    if (met) el.classList.add('met'); else el.classList.remove('met');
  }

  confEl.addEventListener('blur', () => {
    if (confEl.value !== newPassEl.value)
      showError('confirmPassword', 'Passwords do not match.');
    else showSuccess('confirmPassword');
  });

  /* ---- Submit ---- */
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    hideAlert('alert-container');
    let valid = true;

    if (newPassEl.value.length < 8) {
      showError('newPassword', 'Password must be at least 8 characters.'); valid = false;
    } else { showSuccess('newPassword'); }

    if (confEl.value !== newPassEl.value) {
      showError('confirmPassword', 'Passwords do not match.'); valid = false;
    } else if (confEl.value) { showSuccess('confirmPassword'); }

    if (!valid) return;

    setButtonLoading('reset-btn', true);
    setTimeout(() => {
      setButtonLoading('reset-btn', false);
      document.getElementById('form-state').style.display    = 'none';
      document.getElementById('success-state').style.display = 'block';
    }, 1500);
  });
});
