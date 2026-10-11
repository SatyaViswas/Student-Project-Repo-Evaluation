<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Details — Showcase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>

<nav class="app-nav navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="showcase.jsp">
            <span class="brand-icon">⬡</span> Project Showcase
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="showcase.jsp" class="nav-link">← Gallery</a>
            <a href="login.jsp" class="nav-link">Login</a>
            <a href="register.jsp" class="btn btn-brand btn-sm">Register</a>
        </div>
    </div>
</nav>

<div class="container" style="padding-top:2rem; padding-bottom:4rem; max-width:820px;">

    <div id="loading" class="card p-5 text-center mt-3">
        <div class="spinner-border spinner-brand mx-auto mb-3" role="status" style="width:2rem;height:2rem;"></div>
        <p class="mb-0 fw-600 text-slate-500">Loading project…</p>
    </div>

    <div id="errorState" class="card d-none">
        <div class="empty-state">
            <div class="empty-icon">⚠️</div>
            <h4>Project not available</h4>
            <p>This project may not exist or is not publicly visible.</p>
            <a href="showcase.jsp" class="btn btn-outline-slate">Back to Gallery</a>
        </div>
    </div>

    <div id="content" class="d-none">
        <!-- Project Card -->
        <div class="card mb-4">
            <div class="card-body p-5">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                    <div>
                        <span id="pDomain" class="badge badge-domain mb-2"></span>
                        <h1 id="pTitle" class="fw-700 mb-0" style="letter-spacing:-0.03em; color:var(--slate-900); font-size:clamp(1.4rem,4vw,2rem);"></h1>
                    </div>
                    <div id="pStatusBadge"></div>
                </div>

                <div class="d-flex flex-wrap gap-2 mb-5">
                    <a id="lGithub" href="#" target="_blank" class="btn btn-sm btn-outline-slate">View on GitHub ↗</a>
                    <a id="lDemo" href="#" target="_blank" class="btn btn-sm btn-outline-slate d-none">Live Demo ↗</a>
                </div>

                <p class="section-title">Project Abstract</p>
                <p id="pAbstract" class="text-slate-700" style="font-size:1.0625rem; line-height:1.8;"></p>
            </div>
        </div>

        <!-- Awaiting Evaluation -->
        <div id="pendingSection" class="card d-none">
            <div class="empty-state">
                <div class="empty-icon">⏳</div>
                <h4>Evaluation Pending</h4>
                <p>This project has been submitted but has not yet been formally evaluated.</p>
            </div>
        </div>

        <!-- Evaluation Results -->
        <div id="evaluationSection" class="card d-none" style="overflow:hidden;">
            <div class="card-header header-success">✓ Official Evaluation Results</div>
            <div class="card-body p-4">
                <div class="row g-3 mb-4 text-center">
                    <div class="col-6 col-md-3">
                        <div class="score-ring-wrap">
                            <div class="score-label">Problem</div>
                            <div class="score-value" id="scoreProblem">—</div>
                            <div class="score-max">/ 20</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="score-ring-wrap">
                            <div class="score-label">Code Quality</div>
                            <div class="score-value" id="scoreCode">—</div>
                            <div class="score-max">/ 30</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="score-ring-wrap">
                            <div class="score-label">Documentation</div>
                            <div class="score-value" id="scoreDoc">—</div>
                            <div class="score-max">/ 20</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="score-ring-wrap">
                            <div class="score-label">Execution</div>
                            <div class="score-value" id="scoreExec">—</div>
                            <div class="score-max">/ 30</div>
                        </div>
                    </div>
                </div>

                <div class="total-score-box mb-4">
                    <span class="ts-label">Total Score</span>
                    <span class="ts-value"><span id="scoreTotal">0</span><span style="font-size:1.2rem;font-weight:400;opacity:.6;"> / 100</span></span>
                </div>

                <p class="section-title">Evaluator Feedback</p>
                <div class="p-4 bg-light rounded-md border" style="white-space:pre-wrap; font-size:0.9rem; color:var(--slate-700); line-height:1.7;" id="evalFeedback"></div>
            </div>
        </div>
    </div>
</div>

<footer class="app-footer">
    © 2024 Project Repository & Evaluation System · <a href="showcase.jsp" style="color:inherit;">Gallery</a>
</footer>

<script src="css/app.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", async () => {
        const projectId = new URLSearchParams(window.location.search).get('id');
        if (!projectId) { window.location.href = 'showcase.jsp'; return; }

        try {
            const res = await fetch(`PublicProjectDetailServlet?id=${projectId}`);
            const data = await res.json();

            document.getElementById('loading').classList.add('d-none');

            if (data.error) {
                document.getElementById('errorState').classList.remove('d-none');
                return;
            }

            document.getElementById('content').classList.remove('d-none');
            document.getElementById('pTitle').textContent = data.title;
            document.getElementById('pDomain').textContent = data.domainTag;
            document.getElementById('pAbstract').textContent = data.abstractText;
            document.getElementById('pStatusBadge').innerHTML = statusBadge(data.status);
            document.getElementById('lGithub').href = data.githubUrl;

            if (data.demoUrl) {
                const el = document.getElementById('lDemo');
                el.href = data.demoUrl;
                el.classList.remove('d-none');
            }

            if (data.status === 'EVALUATED' && data.evaluation) {
                document.getElementById('evaluationSection').classList.remove('d-none');
                document.getElementById('scoreProblem').textContent = data.evaluation.problemScore;
                document.getElementById('scoreCode').textContent    = data.evaluation.codeScore;
                document.getElementById('scoreDoc').textContent     = data.evaluation.docScore;
                document.getElementById('scoreExec').textContent    = data.evaluation.executionScore;
                document.getElementById('scoreTotal').textContent   = data.evaluation.totalScore;
                document.getElementById('evalFeedback').textContent = data.evaluation.feedback || 'No feedback provided.';
            } else {
                document.getElementById('pendingSection').classList.remove('d-none');
            }
        } catch {
            document.getElementById('loading').classList.add('d-none');
            document.getElementById('errorState').classList.remove('d-none');
        }
    });
</script>
</body>
</html>
