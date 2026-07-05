/* ================================================================
   SpendWise - Auth Shared Utilities
   ================================================================ */

'use strict';

/* ---- Show/Hide field error ---- */
function showError(fieldId, message) {
  const input = document.getElementById(fieldId);
  const error = document.getElementById(fieldId + '-error');
  if (input) { input.classList.add('error'); input.classList.remove('success'); }
  if (error) { error.textContent = message; error.classList.add('show'); }
}

function clearError(fieldId) {
  const input = document.getElementById(fieldId);
  const error = document.getElementById(fieldId + '-error');
  if (input) { input.classList.remove('error'); }
  if (error) { error.classList.remove('show'); }
}

function showSuccess(fieldId) {
  const input = document.getElementById(fieldId);
  if (input) { input.classList.remove('error'); input.classList.add('success'); }
  clearError(fieldId);
}

/* ---- Alert box ---- */
function showAlert(containerId, type, message) {
  const container = document.getElementById(containerId);
  if (!container) return;
  const icons = { success: 'fa-circle-check', error: 'fa-circle-exclamation', info: 'fa-circle-info' };
  container.innerHTML = `
    <div class="alert alert-${type}">
      <i class="fa-solid ${icons[type] || icons.info}"></i>
      <span>${message}</span>
    </div>`;
  container.style.display = 'block';
}

function hideAlert(containerId) {
  const el = document.getElementById(containerId);
  if (el) { el.innerHTML = ''; el.style.display = 'none'; }
}

/* ---- Toggle password visibility ---- */
function togglePassword(inputId, btnId) {
  const input = document.getElementById(inputId);
  const btn   = document.getElementById(btnId);
  if (!input || !btn) return;
  const icon = btn.querySelector('i');
  if (input.type === 'password') {
    input.type = 'text';
    if (icon) { icon.classList.replace('fa-eye', 'fa-eye-slash'); }
  } else {
    input.type = 'password';
    if (icon) { icon.classList.replace('fa-eye-slash', 'fa-eye'); }
  }
}

/* ---- Password strength checker ---- */
function checkPasswordStrength(password) {
  let score = 0;
  if (password.length >= 8)  score++;
  if (password.length >= 12) score++;
  if (/[A-Z]/.test(password)) score++;
  if (/[0-9]/.test(password)) score++;
  if (/[^A-Za-z0-9]/.test(password)) score++;
  if (score <= 2) return { level: 'weak',   label: 'Weak',   fill: 1 };
  if (score <= 3) return { level: 'medium', label: 'Medium', fill: 2 };
  return              { level: 'strong',  label: 'Strong', fill: 3 };
}

function updateStrengthBars(password) {
  const bars    = document.querySelectorAll('.strength-bar');
  const label   = document.getElementById('strength-text');
  if (!bars.length) return;
  const result  = checkPasswordStrength(password);
  bars.forEach((bar, i) => {
    bar.className = 'strength-bar';
    if (i < result.fill) bar.classList.add(result.level);
  });
  if (label) {
    label.textContent = password ? `Password strength: ${result.label}` : '';
    label.style.color = result.level === 'strong' ? '#10B981'
                      : result.level === 'medium' ? '#F59E0B' : '#EF4444';
  }
}

/* ---- Validators ---- */
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim());
}
function isValidPassword(password) {
  return password.length >= 8;
}
function isNotEmpty(value) {
  return value !== null && value !== undefined && value.trim() !== '';
}

/* ---- Button loading state ---- */
function setButtonLoading(btnId, loading) {
  const btn = document.getElementById(btnId);
  if (!btn) return;
  if (loading) {
    btn.classList.add('loading');
    btn.disabled = true;
  } else {
    btn.classList.remove('loading');
    btn.disabled = false;
  }
}

/* ---- Real-time validation on blur ---- */
function addBlurValidation(fieldId, validator, errorMsg) {
  const input = document.getElementById(fieldId);
  if (!input) return;
  input.addEventListener('blur', () => {
    if (!validator(input.value)) showError(fieldId, errorMsg);
    else showSuccess(fieldId);
  });
  input.addEventListener('input', () => { if (input.classList.contains('error')) clearError(fieldId); });
}
