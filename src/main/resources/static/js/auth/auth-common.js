// ================================================================
// SpendWise - Auth Common JS
// Phase 4: Authentication UI
// ================================================================

// ---- Custom Checkbox Toggle ----
function initCheckboxes() {
    document.querySelectorAll('.custom-checkbox').forEach(box => {
        const input = box.querySelector('input[type="checkbox"]');
        box.addEventListener('click', () => {
            input.checked = !input.checked;
            box.classList.toggle('checked', input.checked);
            box.dispatchEvent(new Event('change', { bubbles: true }));
        });
        // Sync initial state
        if (input && input.checked) box.classList.add('checked');
    });
}

// ---- Password Toggle ----
function togglePassword(inputId, btnId) {
    const input = document.getElementById(inputId);
    const btn   = document.getElementById(btnId);
    if (!input || !btn) return;
    const icon = btn.querySelector('i');
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}

// ---- Field Validation ----
function showError(fieldId, message) {
    const input  = document.getElementById(fieldId);
    const errEl  = document.getElementById(fieldId + '-error');
    if (input)  input.classList.add('error');
    if (input)  input.classList.remove('success');
    if (errEl) {
        errEl.textContent = message;
        errEl.classList.add('show');
    }
}

function showSuccess(fieldId) {
    const input = document.getElementById(fieldId);
    const errEl = document.getElementById(fieldId + '-error');
    if (input)  { input.classList.remove('error'); input.classList.add('success'); }
    if (errEl)  errEl.classList.remove('show');
}

function clearError(fieldId) {
    const input = document.getElementById(fieldId);
    const errEl = document.getElementById(fieldId + '-error');
    if (input)  { input.classList.remove('error', 'success'); }
    if (errEl)  errEl.classList.remove('show');
}

// ---- Real-time input listener ----
function addInputListeners(validationMap) {
    Object.keys(validationMap).forEach(fieldId => {
        const input = document.getElementById(fieldId);
        if (!input) return;
        input.addEventListener('input', () => {
            clearError(fieldId);
            validationMap[fieldId](input.value);
        });
    });
}

// ---- Email validation ----
function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim());
}

// ---- Password strength ----
function checkPasswordStrength(password) {
    const bars    = document.querySelectorAll('.strength-bar');
    const label   = document.querySelector('.strength-label');
    const wrapper = document.querySelector('.password-strength');
    if (!bars.length || !wrapper) return;

    wrapper.classList.add('show');
    bars.forEach(b => b.className = 'strength-bar');

    let score = 0;
    if (password.length >= 8)              score++;
    if (/[A-Z]/.test(password))            score++;
    if (/[0-9]/.test(password))            score++;
    if (/[^A-Za-z0-9]/.test(password))    score++;

    if (score === 1) {
        bars[0].classList.add('weak');
        if (label) { label.textContent = 'Weak'; label.style.color = '#EF4444'; }
    } else if (score === 2) {
        bars[0].classList.add('medium'); bars[1].classList.add('medium');
        if (label) { label.textContent = 'Fair'; label.style.color = '#F59E0B'; }
    } else if (score === 3) {
        bars[0].classList.add('strong'); bars[1].classList.add('strong'); bars[2].classList.add('strong');
        if (label) { label.textContent = 'Good'; label.style.color = '#10B981'; }
    } else if (score >= 4) {
        bars.forEach(b => b.classList.add('strong'));
        if (label) { label.textContent = 'Strong'; label.style.color = '#10B981'; }
    }
    return score;
}

// ---- Button loading state ----
function setButtonLoading(btnId, loading, text = 'Submit') {
    const btn = document.getElementById(btnId);
    if (!btn) return;
    if (loading) {
        btn.disabled = true;
        btn.innerHTML = `<span class="spinner"></span> Please wait...`;
    } else {
        btn.disabled = false;
        btn.innerHTML = text;
    }
}

// ---- Show alert ----
function showAlert(containerId, type, message) {
    const el = document.getElementById(containerId);
    if (!el) return;
    el.className = `alert alert-${type}`;
    el.innerHTML = `<i class="fa-solid fa-${type === 'success' ? 'check-circle' : 'circle-exclamation'}"></i> ${message}`;
    el.style.display = 'flex';
    if (type === 'success') {
        setTimeout(() => { el.style.display = 'none'; }, 4000);
    }
}

// ---- Init on DOM ready ----
document.addEventListener('DOMContentLoaded', initCheckboxes);
