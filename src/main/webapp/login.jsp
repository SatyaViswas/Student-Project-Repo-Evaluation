<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Project Repository</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-logo">⬡</div>
        <h1 class="auth-title">Welcome back</h1>
        <p class="auth-subtitle">Sign in to access your dashboard</p>

        <div id="alertMessage" class="alert alert-danger d-none" role="alert"></div>

        <form id="loginForm" novalidate>
            <div class="mb-3">
                <label for="email" class="form-label">Email address</label>
                <input type="email" class="form-control" id="email" placeholder="you@example.com" required autocomplete="email">
                <div class="invalid-feedback">Please enter a valid email.</div>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" placeholder="••••••••" required autocomplete="current-password">
                <div class="invalid-feedback">Password is required.</div>
            </div>
            <button type="submit" class="btn btn-brand w-100" id="loginBtn">
                Sign in
            </button>
        </form>

        <div class="auth-divider">Don't have an account?</div>
        <a href="register.jsp" class="btn btn-outline-slate w-100">Create account</a>

        <p class="text-center mt-4 mb-0">
            <a href="showcase.jsp" class="text-slate-500" style="font-size:0.8125rem; text-decoration:none;">← Back to Project Showcase</a>
        </p>
    </div>
</div>

<script src="css/app.js"></script>
<script>
    document.getElementById('loginForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        this.classList.add('was-validated');

        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value;
        const alertBox = document.getElementById('alertMessage');
        const btn = document.getElementById('loginBtn');

        if (!this.checkValidity()) return;

        btn.disabled = true;
        btn.textContent = 'Signing in...';
        alertBox.classList.add('d-none');

        const body = new URLSearchParams({ action: 'login', email, password });

        try {
            const res = await fetch('auth', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body });
            const result = await res.json();

            if (result.success) {
                showToast('Login successful!', 'success');
                setTimeout(() => {
                    window.location.href = result.role === 'STUDENT' ? 'student-dashboard.jsp' : 'evaluator-dashboard.jsp';
                }, 400);
            } else {
                alertBox.textContent = result.message || 'Invalid credentials. Please try again.';
                alertBox.classList.remove('d-none');
                btn.disabled = false;
                btn.textContent = 'Sign in';
            }
        } catch {
            alertBox.textContent = 'Network error. Please check your connection.';
            alertBox.classList.remove('d-none');
            btn.disabled = false;
            btn.textContent = 'Sign in';
        }
    });
</script>
</body>
</html>
