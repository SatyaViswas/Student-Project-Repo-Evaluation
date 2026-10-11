<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Repository & Evaluation System</title>
    <meta name="description" content="An academic platform to submit, evaluate, and showcase student capstone projects.">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .feature-icon {
            width: 48px; height: 48px;
            border-radius: 12px;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            margin-bottom: 1rem;
        }
        .feature-icon.blue   { background: #dbeafe; color: #1d4ed8; }
        .feature-icon.green  { background: var(--success-light); color: var(--success); }
        .feature-icon.purple { background: var(--brand-light); color: var(--brand); }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="app-nav navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <span class="brand-icon">⬡</span> Project Repository
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="showcase.jsp" class="nav-link">Gallery</a>
            <a href="login.jsp" class="nav-link">Login</a>
            <a href="register.jsp" class="btn btn-brand btn-sm">Get Started</a>
        </div>
    </div>
</nav>

<!-- Hero -->
<div class="hero-banner">
    <div class="container">
        <p style="font-size:0.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.15em;opacity:.55;margin-bottom:1rem;">Academic Project Platform</p>
        <h1>Submit. Evaluate. Showcase.</h1>
        <p class="mt-3" style="max-width:540px;margin:0 auto 2rem;">A streamlined system for students to publish capstone work, evaluators to score submissions, and the world to explore the results.</p>
        <div class="d-flex flex-wrap justify-content-center gap-3">
            <a href="register.jsp" class="btn btn-brand btn-lg">Get Started</a>
            <a href="showcase.jsp" class="btn btn-lg btn-outline-light">Browse Gallery</a>
        </div>
    </div>
</div>

<!-- Features -->
<div class="container" style="padding-top:4rem; padding-bottom:4rem;">
    <div class="row g-4 justify-content-center">
        <div class="col-12 col-md-4">
            <div class="card h-100 p-4">
                <div class="feature-icon blue">📤</div>
                <h5 class="fw-700 mb-2">Submit Projects</h5>
                <p class="text-slate-500 mb-0" style="font-size:0.9rem;">Students upload GitHub links, live demos, and PDF reports. Save as draft or submit for evaluation with one click.</p>
            </div>
        </div>
        <div class="col-12 col-md-4">
            <div class="card h-100 p-4">
                <div class="feature-icon green">✅</div>
                <h5 class="fw-700 mb-2">Expert Evaluation</h5>
                <p class="text-slate-500 mb-0" style="font-size:0.9rem;">Evaluators score projects on Problem, Code, Documentation, and Execution using a structured rubric with live feedback.</p>
            </div>
        </div>
        <div class="col-12 col-md-4">
            <div class="card h-100 p-4">
                <div class="feature-icon purple">🌐</div>
                <h5 class="fw-700 mb-2">Public Showcase</h5>
                <p class="text-slate-500 mb-0" style="font-size:0.9rem;">An open gallery lets anyone discover evaluated projects, explore detailed scores, and access demo links.</p>
            </div>
        </div>
    </div>

    <div class="text-center mt-5 pt-2">
        <p class="text-slate-500 mb-4" style="font-size:0.9375rem;">Ready to get started?</p>
        <div class="d-flex flex-wrap justify-content-center gap-3">
            <a href="register.jsp?role=STUDENT" class="btn btn-brand">I'm a Student</a>
            <a href="register.jsp?role=EVALUATOR" class="btn btn-outline-slate">I'm an Evaluator</a>
        </div>
    </div>
</div>

<footer class="app-footer">
    © 2024 Project Repository & Evaluation System · Built with Java Servlets &amp; MySQL
</footer>
</body>
</html>
