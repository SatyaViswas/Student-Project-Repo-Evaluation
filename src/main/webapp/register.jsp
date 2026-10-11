<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — Project Repository</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
<div class="auth-container">
    <div class="auth-card" style="max-width:480px;">
        <div class="auth-logo">⬡</div>
        <h1 class="auth-title">Create account</h1>
        <p class="auth-subtitle">Join the project repository platform</p>

        <div id="alertMessage" class="alert d-none" role="alert"></div>

        <form id="registerForm" novalidate>
            <div class="mb-3">
                <label for="name" class="form-label">Full Name</label>
                <input type="text" class="form-control" id="name" placeholder="Jane Smith" required autocomplete="name" minlength="2">
                <div class="invalid-feedback">Full name is required (min 2 chars).</div>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email address</label>
                <input type="email" class="form-control" id="email" placeholder="you@example.com" required autocomplete="email">
                <div class="invalid-feedback">Please enter a valid email.</div>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" placeholder="Min. 6 characters" required minlength="6" autocomplete="new-password">
                <div class="invalid-feedback">Password must be at least 6 characters.</div>
            </div>
            <div class="mb-4">
                <label for="role" class="form-label">I am a</label>
                <select class="form-select" id="role" required>
                    <option value="STUDENT">Student</option>
                    <option value="EVALUATOR">Evaluator / Faculty</option>
                </select>
            </div>
            <button type="submit" class="btn btn-brand w-100" id="registerBtn">Create account</button>
        </form>

        <div class="auth-divider">Already have an account?</div>
        <a href="login.jsp" class="btn btn-outline-slate w-100">Sign in</a>

        <p class="text-center mt-4 mb-0">
            <a href="showcase.jsp" class="text-slate-500" style="font-size:0.8125rem; text-decoration:none;">← Back to Showcase</a>
        </p>
    </div>
</div>

<script src="css/app.js"></script>
<script>
    document.getElementById('registerForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        this.classList.add('was-validated');

        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value;
        const role = document.getElementById('role').value;
        const alertBox = document.getElementById('alertMessage');
        const btn = document.getElementById('registerBtn');

        if (!this.checkValidity()) return;

        btn.disabled = true;
        btn.textContent = 'Creating account...';
        alertBox.className = 'alert d-none';

        const body = new URLSearchParams({ action: 'register', name, email, password, role });

        try {
            const res = await fetch('auth', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body });
            const result = await res.json();

            alertBox.classList.remove('d-none');
            if (result.success) {
                alertBox.className = 'alert alert-success';
                alertBox.textContent = 'Account created! Redirecting to login…';
                setTimeout(() => window.location.href = 'login.jsp', 1800);
            } else {
                alertBox.className = 'alert alert-danger';
                alertBox.textContent = result.message || 'Registration failed.';
                btn.disabled = false;
                btn.textContent = 'Create account';
            }
        } catch {
            alertBox.className = 'alert alert-danger';
            alertBox.textContent = 'Network error. Please try again.';
            alertBox.classList.remove('d-none');
            btn.disabled = false;
            btn.textContent = 'Create account';
        }
    });
</script>
</body>
</html>
