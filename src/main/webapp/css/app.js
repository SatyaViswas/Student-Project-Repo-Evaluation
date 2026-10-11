/* app.js — shared utilities across all pages */

/**
 * Show a slide-up toast notification at bottom-right.
 * @param {string} msg
 * @param {'success'|'error'|'info'} type
 */
function showToast(msg, type = 'success') {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }
    const toast = document.createElement('div');
    const icons = { success: '✓', error: '✕', info: 'ℹ' };
    toast.className = `toast-msg toast-${type}`;
    toast.innerHTML = `<span>${icons[type] || '●'}</span><span>${msg}</span>`;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 4000);
}

/**
 * Render a status badge with unified styling.
 * @param {string} status  DRAFT | SUBMITTED | EVALUATED
 */
function statusBadge(status) {
    const map = {
        DRAFT:     'badge-draft',
        SUBMITTED: 'badge-submitted',
        EVALUATED: 'badge-evaluated',
    };
    return `<span class="badge ${map[status] || 'badge-draft'}">${status}</span>`;
}

/**
 * Render a score badge coloured by performance threshold.
 * @param {number} score
 */
function scoreBadge(score) {
    let cls = 'badge-score-high';
    if (score < 50) cls = 'badge-score-low';
    else if (score < 80) cls = 'badge-score-mid';
    return `<span class="badge ${cls}">Score: ${score}/100</span>`;
}

/**
 * Simple URL validator.
 * @param {string} url
 */
function isValidUrl(url) {
    try { new URL(url); return true; } catch { return false; }
}

/**
 * Attach live URL validation to an input.
 * @param {string} inputId
 * @param {boolean} required
 */
function attachUrlValidation(inputId, required = true) {
    const el = document.getElementById(inputId);
    if (!el) return;
    el.addEventListener('blur', () => {
        const val = el.value.trim();
        if (!val && !required) { el.classList.remove('is-invalid', 'is-valid'); return; }
        if (isValidUrl(val)) {
            el.classList.replace('is-invalid', 'is-valid') || el.classList.add('is-valid');
        } else {
            el.classList.replace('is-valid', 'is-invalid') || el.classList.add('is-invalid');
        }
    });
}

/**
 * Show a page-level inline alert.
 * @param {string} elementId
 * @param {string} msg
 * @param {'success'|'danger'|'info'} type
 */
function showAlert(elementId, msg, type = 'danger') {
    const el = document.getElementById(elementId);
    if (!el) return;
    el.className = `alert alert-${type}`;
    el.textContent = msg;
    el.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

/**
 * Redirect to login if fetch returns 401/403.
 * @param {Response} res
 */
function checkAuthRedirect(res) {
    if (res.status === 401 || res.status === 403) {
        window.location.href = 'login.jsp';
        return true;
    }
    return false;
}
