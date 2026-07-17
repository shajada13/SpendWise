/**
 * SpendWise - Client Side Form Validation
 * Generic validation helpers applied to forms marked with
 * the [data-validate] attribute.
 */

document.addEventListener('DOMContentLoaded', function () {
  const forms = document.querySelectorAll('[data-validate]');

  forms.forEach(function (form) {
    form.addEventListener('submit', function (event) {
      if (!validateForm(form)) {
        event.preventDefault();
      }
    });
  });
});

/**
 * Validates all required fields, email fields, and password
 * confirmation fields inside a given form.
 * @param {HTMLFormElement} form
 * @returns {boolean} whether the form is valid
 */
function validateForm(form) {
  let isValid = true;

  clearErrors(form);

  form.querySelectorAll('[required]').forEach(function (field) {
    if (!field.value.trim()) {
      setError(field, 'This field is required.');
      isValid = false;
    }
  });

  form.querySelectorAll('input[type="email"]').forEach(function (field) {
    if (field.value && !isValidEmail(field.value)) {
      setError(field, 'Please enter a valid email address.');
      isValid = false;
    }
  });

  const password = form.querySelector('input[name="password"]');
  const confirmPassword = form.querySelector('input[name="confirmPassword"]');

  if (password && confirmPassword && confirmPassword.value) {
    if (password.value !== confirmPassword.value) {
      setError(confirmPassword, 'Passwords do not match.');
      isValid = false;
    }
  }

  return isValid;
}

function isValidEmail(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
}

function setError(field, message) {
  field.classList.add('is-invalid');

  const feedback = document.createElement('div');
  feedback.className = 'invalid-feedback';
  feedback.style.color = 'var(--color-danger)';
  feedback.style.fontSize = '0.75rem';
  feedback.style.marginTop = '4px';
  feedback.textContent = message;

  field.insertAdjacentElement('afterend', feedback);
}

function clearErrors(form) {
  form.querySelectorAll('.is-invalid').forEach(function (field) {
    field.classList.remove('is-invalid');
  });

  form.querySelectorAll('.invalid-feedback').forEach(function (el) {
    el.remove();
  });
}
