/**
 * SpendWise - Core Application Script
 * Handles shared UI behavior across all pages:
 * sidebar toggle, dropdown menus, and toast notifications.
 */

document.addEventListener('DOMContentLoaded', function () {
  initSidebarToggle();
  initDropdowns();
  initTooltips();
  initIcons();
});

/**
 * Renders Lucide icons for every element marked with [data-icon="name"].
 * Lucide is loaded from CDN in the page layout.
 */
function initIcons() {
  if (typeof lucide === 'undefined') {
    return;
  }
  lucide.createIcons();
}

/**
 * Toggles the sidebar visibility on smaller screens.
 */
function initSidebarToggle() {
  const toggleBtn = document.querySelector('[data-sidebar-toggle]');
  const sidebar = document.querySelector('.sidebar');

  if (!toggleBtn || !sidebar) {
    return;
  }

  toggleBtn.addEventListener('click', function () {
    sidebar.classList.toggle('open');
  });

  document.addEventListener('click', function (event) {
    const isClickInsideSidebar = sidebar.contains(event.target);
    const isClickOnToggle = toggleBtn.contains(event.target);

    if (!isClickInsideSidebar && !isClickOnToggle) {
      sidebar.classList.remove('open');
    }
  });
}

/**
 * Enables simple click-to-open dropdown menus.
 */
function initDropdowns() {
  const dropdownTriggers = document.querySelectorAll('[data-dropdown-trigger]');

  dropdownTriggers.forEach(function (trigger) {
    const targetId = trigger.getAttribute('data-dropdown-trigger');
    const menu = document.getElementById(targetId);

    if (!menu) {
      return;
    }

    trigger.addEventListener('click', function (event) {
      event.stopPropagation();
      menu.classList.toggle('show');
    });
  });

  document.addEventListener('click', function () {
    document.querySelectorAll('.dropdown-menu.show').forEach(function (menu) {
      menu.classList.remove('show');
    });
  });
}

/**
 * Placeholder hook for initializing Bootstrap tooltips if present.
 */
function initTooltips() {
  if (typeof bootstrap === 'undefined') {
    return;
  }

  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  tooltipTriggerList.forEach(function (el) {
    new bootstrap.Tooltip(el);
  });
}

/**
 * Displays a toast notification.
 * @param {string} message - The message to display.
 * @param {'success'|'danger'|'warning'|'info'} type - Toast style variant.
 */
function showToast(message, type) {
  type = type || 'info';

  let container = document.querySelector('.toast-container');
  if (!container) {
    container = document.createElement('div');
    container.className = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = 'toast toast-' + type;
  toast.textContent = message;

  container.appendChild(toast);

  setTimeout(function () {
    toast.remove();
  }, 4000);
}

window.showToast = showToast;
