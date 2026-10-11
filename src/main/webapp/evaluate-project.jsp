<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluate Project — Project Repository</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .score-cell { text-align: center; }
        .score-input { width: 80px; font-size: 1.5rem; font-weight: 700; text-align: center; -moz-appearance: textfield; }
        .score-input::-webkit-outer-spin-button, .score-input::-webkit-inner-spin-button { -webkit-appearance: none; }
        .rubric-row { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem; padding: 1rem 0; border-bottom: 1px solid var(--slate-100); }
        .rubric-row:last-of-type { border-bottom: none; }
        .rubric-label { font-weight: 600; color: var(--slate-800); font-size: 0.9rem; }
        .rubric-hint  { font-size: 0.8rem; color: var(--slate-500); margin-top: 0.15rem; }
        .rubric-max   { font-size: 0.75rem; color: var(--slate-400); font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; }
        .score-bar-bg { flex: 1; height: 6px; background: var(--slate-100); border-radius: 3px; min-width: 80px; overflow: hidden; }
        .score-bar    { height: 100%; background: var(--brand); border-radius: 3px; transition: width 0.3s ease; }
    </style>
</head>
<body>

<nav class="app-nav navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="evaluator-dashboard.jsp">
            <span class="brand-icon">⬡</span> Project Repository
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="evaluator-dashboard.jsp" class="nav-link">← Evaluation Queue</a>
            <a href="auth?action=logout" class="btn btn-sm btn-nav-logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container" style="padding-top:2rem; padding-bottom:4rem; max-width:860px;">

    <div id="loading" class="card p-5 text-center mt-3">
        <div class="spinner-border spinner-brand mx-auto mb-3" role="status" style="width:2rem;height:2rem;"></div>
        <p class="mb-0 fw-600 text-slate-500">Loading project…</p>
    </div>

    <div id="content" class="d-none">
        <!-- Project Details Card -->
        <div class="card mb-4" style="overflow:hidden;">
            <div class="card-header header-brand">Project Overview</div>
            <div class="card-body p-4">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                    <div>
                        <span id="pDomain" class="badge badge-domain mb-1"></span>
                        <h3 id="pTitle" class="fw-700 mb-0" style="color:var(--slate-900); letter-spacing:-0.02em;"></h3>
                    </div>
                    <div id="pStatusBadge"></div>
                </div>
                <p class="section-title mt-3">Abstract</p>
                <p id="pAbstract" class="text-slate-700" style="line-height:1.75; margin:0;"></p>
                <div class="d-flex flex-wrap gap-2 mt-4">
                    <a id="lGithub" href="#" target="_blank" class="btn btn-sm btn-outline-slate">GitHub ↗</a>
                    <a id="lDemo" href="#" target="_blank" class="btn btn-sm btn-outline-slate d-none">Live Demo ↗</a>
                    <a id="lPdf" href="#" target="_blank" class="btn btn-sm btn-outline-slate d-none">PDF Report</a>
                </div>
            </div>
        </div>

        <!-- Evaluation Rubric -->
        <div class="card" style="overflow:hidden;">
            <div class="card-header">Evaluation Rubric</div>
            <div class="card-body p-4">
                <div id="alertMsg" class="alert d-none mb-4"></div>

                <form id="evaluationForm" novalidate>
                    <input type="hidden" id="projectId" name="projectId">

                    <!-- Rubric Rows -->
                    <div class="rubric-row">
                        <div>
                            <div class="rubric-label">Problem Understanding</div>
                            <div class="rubric-hint">Clarity of problem statement and solution rationale</div>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <div class="score-bar-bg"><div class="score-bar" id="bar-problem" style="width:0%"></div></div>
                            <input type="number" class="form-control score-input" id="problemScore" name="problemScore" min="0" max="20" placeholder="0" required oninput="onScoreInput('problem',20)">
                            <span class="rubric-max">/ 20</span>
                        </div>
                    </div>
                    <div class="rubric-row">
                        <div>
                            <div class="rubric-label">Code Quality & Architecture</div>
                            <div class="rubric-hint">Structure, readability, and technical depth</div>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <div class="score-bar-bg"><div class="score-bar" id="bar-code" style="width:0%"></div></div>
                            <input type="number" class="form-control score-input" id="codeScore" name="codeScore" min="0" max="30" placeholder="0" required oninput="onScoreInput('code',30)">
                            <span class="rubric-max">/ 30</span>
                        </div>
                    </div>
                    <div class="rubric-row">
                        <div>
                            <div class="rubric-label">Documentation</div>
                            <div class="rubric-hint">Report quality, diagrams, and written clarity</div>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <div class="score-bar-bg"><div class="score-bar" id="bar-doc" style="width:0%"></div></div>
                            <input type="number" class="form-control score-input" id="docScore" name="docScore" min="0" max="20" placeholder="0" required oninput="onScoreInput('doc',20)">
                            <span class="rubric-max">/ 20</span>
                        </div>
                    </div>
                    <div class="rubric-row">
                        <div>
                            <div class="rubric-label">Execution & Presentation</div>
                            <div class="rubric-hint">Demo quality, live deployment, and presentation</div>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <div class="score-bar-bg"><div class="score-bar" id="bar-exec" style="width:0%"></div></div>
                            <input type="number" class="form-control score-input" id="executionScore" name="executionScore" min="0" max="30" placeholder="0" required oninput="onScoreInput('exec',30)">
                            <span class="rubric-max">/ 30</span>
                        </div>
                    </div>

                    <div class="total-score-box my-4">
                        <span class="ts-label">Total Score</span>
                        <span class="ts-value"><span id="totalScoreDisplay">0</span><span style="font-size:1.2rem;font-weight:400;opacity:.6;"> / 100</span></span>
                    </div>

                    <div class="mb-4">
                        <label for="feedback" class="form-label">Evaluator Feedback</label>
                        <textarea class="form-control" id="feedback" name="feedback" rows="5" placeholder="Provide constructive, specific feedback for the student team…" required minlength="10"></textarea>
                        <div class="invalid-feedback">Please provide at least 10 characters of feedback.</div>
                    </div>

                    <hr class="divider">
                    <div class="d-flex justify-content-end gap-2">
                        <a href="evaluator-dashboard.jsp" class="btn btn-outline-slate">Cancel</a>
                        <button type="button" class="btn btn-brand px-4" onclick="submitEvaluation()" id="submitBtn">Submit Evaluation</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<footer class="app-footer">© 2024 Project Repository & Evaluation System</footer>

<script src="css/app.js"></script>
<script>
    const scoreMap = { problem: 20, code: 30, doc: 20, exec: 30 };
    const inputMap = { problem: 'problemScore', code: 'codeScore', doc: 'docScore', exec: 'executionScore' };

    function onScoreInput(key, max) {
        const input = document.getElementById(inputMap[key]);
        let val = parseInt(input.value) || 0;
        if (val > max) { val = max; input.value = max; }
        if (val < 0)   { val = 0; input.value = 0; }
        document.getElementById(`bar-${key}`).style.width = `${(val/max)*100}%`;
        calculateTotal();
    }

    function calculateTotal() {
        const p = parseInt(document.getElementById('problemScore').value) || 0;
        const c = parseInt(document.getElementById('codeScore').value) || 0;
        const d = parseInt(document.getElementById('docScore').value) || 0;
        const e = parseInt(document.getElementById('executionScore').value) || 0;
        document.getElementById('totalScoreDisplay').textContent = p + c + d + e;
    }

    document.addEventListener("DOMContentLoaded", async () => {
        const projectId = new URLSearchParams(window.location.search).get('id');
        if (!projectId) { window.location.href = 'evaluator-dashboard.jsp'; return; }

        try {
            const res = await fetch(`ViewProjectServlet?id=${projectId}`);
            if (checkAuthRedirect(res)) return;
            const data = await res.json();

            document.getElementById('loading').classList.add('d-none');
            document.getElementById('content').classList.remove('d-none');

            document.getElementById('projectId').value = data.id;
            document.getElementById('pTitle').textContent = data.title;
            document.getElementById('pDomain').textContent = data.domainTag;
            document.getElementById('pAbstract').textContent = data.abstractText;
            document.getElementById('pStatusBadge').innerHTML = statusBadge(data.status);
            document.getElementById('lGithub').href = data.githubUrl;

            if (data.demoUrl) { const el = document.getElementById('lDemo'); el.href = data.demoUrl; el.classList.remove('d-none'); }
            if (data.pdfPath) { const el = document.getElementById('lPdf');  el.href = data.pdfPath;  el.classList.remove('d-none'); }

            if (data.evaluation) {
                document.getElementById('problemScore').value   = data.evaluation.problemScore;
                document.getElementById('codeScore').value      = data.evaluation.codeScore;
                document.getElementById('docScore').value       = data.evaluation.docScore;
                document.getElementById('executionScore').value = data.evaluation.executionScore;
                document.getElementById('feedback').value       = data.evaluation.feedback || '';
                ['problem','code','doc','exec'].forEach(k => onScoreInput(k, scoreMap[k]));
                showToast('Editing existing evaluation scores.', 'info');
            }
        } catch {
            document.getElementById('loading').classList.add('d-none');
            document.getElementById('content').innerHTML = '<div class="empty-state"><div class="empty-icon">⚠️</div><h4>Failed to load project</h4><p>Please go back and try again.</p><a href="evaluator-dashboard.jsp" class="btn btn-outline-slate">Back</a></div>';
            document.getElementById('content').classList.remove('d-none');
        }
    });

    async function submitEvaluation() {
        const form = document.getElementById('evaluationForm');
        form.classList.add('was-validated');
        if (!form.checkValidity()) {
            showAlert('alertMsg', 'Please complete all required fields.', 'danger');
            return;
        }

        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.textContent = 'Submitting…';

        const body = new URLSearchParams(new FormData(form));
        try {
            const res = await fetch('EvaluateProjectServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString()
            });
            const result = await res.json();

            if (result.success) {
                showToast('Evaluation submitted!', 'success');
                setTimeout(() => window.location.href = 'evaluator-dashboard.jsp', 1200);
            } else {
                showAlert('alertMsg', result.message || 'Failed to save.', 'danger');
                btn.disabled = false;
                btn.textContent = 'Submit Evaluation';
            }
        } catch {
            showAlert('alertMsg', 'Network error. Please try again.', 'danger');
            btn.disabled = false;
            btn.textContent = 'Submit Evaluation';
        }
    }
</script>
</body>
</html>
