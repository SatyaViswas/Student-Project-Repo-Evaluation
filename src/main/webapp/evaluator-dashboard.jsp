<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluator Dashboard — Project Repository</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>

<nav class="app-nav navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="evaluator-dashboard.jsp">
            <span class="brand-icon">⬡</span> Project Repository
        </a>
        <div class="d-flex align-items-center gap-2">
            <span class="user-chip" id="welcomeUser"></span>
            <a href="auth?action=logout" class="btn btn-sm btn-nav-logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

    <div class="page-header">
        <h2>Evaluation Queue</h2>
        <p>Review and grade submitted student projects.</p>
    </div>

    <!-- Stats Strip -->
    <div class="row g-3 mb-4" id="statsRow" style="display:none!important;">
        <div class="col-6 col-md-3">
            <div class="card p-3 text-center">
                <div style="font-size:1.6rem;font-weight:800;color:var(--brand);" id="statTotal">—</div>
                <div style="font-size:0.78rem;color:var(--slate-500);font-weight:600;">Total Projects</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card p-3 text-center">
                <div style="font-size:1.6rem;font-weight:800;color:#1d4ed8;" id="statSubmitted">—</div>
                <div style="font-size:0.78rem;color:var(--slate-500);font-weight:600;">Pending Review</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card p-3 text-center">
                <div style="font-size:1.6rem;font-weight:800;color:var(--success);" id="statEvaluated">—</div>
                <div style="font-size:0.78rem;color:var(--slate-500);font-weight:600;">Evaluated</div>
            </div>
        </div>
    </div>

    <!-- Loading -->
    <div id="loading" class="card p-4 text-center text-slate-500">
        <div class="spinner-border spinner-brand mx-auto mb-3" role="status" style="width:2rem;height:2rem;"></div>
        <p class="mb-0 fw-600">Loading projects…</p>
    </div>

    <!-- Table -->
    <div id="tableWrap" class="card d-none" style="overflow:hidden;">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Student</th>
                    <th>Project Title</th>
                    <th>Domain</th>
                    <th>GitHub</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="projectsTableBody"></tbody>
        </table>
    </div>

    <!-- Empty State -->
    <div id="emptyState" class="card d-none">
        <div class="empty-state">
            <div class="empty-icon">📋</div>
            <h4>No projects to review</h4>
            <p>No projects have been submitted yet. Check back later.</p>
        </div>
    </div>

    <!-- Error State -->
    <div id="errorState" class="card d-none">
        <div class="empty-state">
            <div class="empty-icon">⚠️</div>
            <h4>Failed to load projects</h4>
            <p>Could not reach the server. Please try again.</p>
            <button onclick="loadDashboard()" class="btn btn-outline-slate">Retry</button>
        </div>
    </div>

</div>

<footer class="app-footer">© 2024 Project Repository & Evaluation System</footer>

<script src="css/app.js"></script>
<script>
    function escHtml(s) {
        const d = document.createElement('div'); d.textContent = s || ''; return d.innerHTML;
    }

    async function loadDashboard() {
        ['tableWrap','emptyState','errorState'].forEach(id => document.getElementById(id).classList.add('d-none'));
        document.getElementById('loading').classList.remove('d-none');

        try {
            const res = await fetch('EvaluatorDashboardServlet');
            if (checkAuthRedirect(res)) return;

            const data = await res.json();
            document.getElementById('loading').classList.add('d-none');
            document.getElementById('welcomeUser').textContent = data.user;

            if (!data.projects || data.projects.length === 0) {
                document.getElementById('emptyState').classList.remove('d-none');
                return;
            }

            // Stats
            const submitted = data.projects.filter(p => p.status === 'SUBMITTED').length;
            const evaluated = data.projects.filter(p => p.status === 'EVALUATED').length;
            document.getElementById('statTotal').textContent = data.projects.length;
            document.getElementById('statSubmitted').textContent = submitted;
            document.getElementById('statEvaluated').textContent = evaluated;
            document.getElementById('statsRow').style.removeProperty('display');

            const tbody = document.getElementById('projectsTableBody');
            tbody.innerHTML = '';

            data.projects.forEach(p => {
                const actionBtn = p.status === 'SUBMITTED'
                    ? `<a href="evaluate-project.jsp?id=${p.id}" class="btn btn-sm btn-brand">Evaluate</a>`
                    : `<a href="evaluate-project.jsp?id=${p.id}" class="btn btn-sm btn-outline-slate">Edit Score</a>`;

                tbody.innerHTML += `
                    <tr>
                        <td class="fw-title">${escHtml(p.studentName)}</td>
                        <td>${escHtml(p.title)}</td>
                        <td><span class="badge badge-domain">${escHtml(p.domainTag)}</span></td>
                        <td><a href="${escHtml(p.githubUrl)}" target="_blank" class="text-slate-500" style="font-size:0.85rem;">Repo ↗</a></td>
                        <td>${statusBadge(p.status)}</td>
                        <td>${actionBtn}</td>
                    </tr>`;
            });

            document.getElementById('tableWrap').classList.remove('d-none');
        } catch {
            document.getElementById('loading').classList.add('d-none');
            document.getElementById('errorState').classList.remove('d-none');
        }
    }

    document.addEventListener('DOMContentLoaded', loadDashboard);
</script>
</body>
</html>
