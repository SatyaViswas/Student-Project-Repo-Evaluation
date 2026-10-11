<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard — Project Repository</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="app-nav navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="student-dashboard.jsp">
            <span class="brand-icon">⬡</span> Project Repository
        </a>
        <div class="d-flex align-items-center gap-2">
            <span class="user-chip" id="welcomeUser"></span>
            <a href="auth?action=logout" class="btn btn-sm btn-nav-logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

    <!-- Page Header -->
    <div class="page-header d-flex flex-wrap justify-content-between align-items-center gap-3">
        <div>
            <h2>My Projects</h2>
            <p>Track and manage your submitted capstone projects.</p>
        </div>
        <a href="submit-project.jsp" class="btn btn-brand" id="newProjectBtn">
            + Submit New Project
        </a>
    </div>

    <!-- Inline alert for auth error -->
    <div id="authAlert" class="alert alert-danger d-none mb-4">
        Session expired. <a href="login.jsp">Please log in again.</a>
    </div>

    <!-- Loading Skeleton -->
    <div id="loading" class="card p-4 text-center text-slate-500" style="border:none;">
        <div class="spinner-border spinner-brand mx-auto mb-3" role="status" style="width:2rem;height:2rem;"></div>
        <p class="mb-0 fw-600">Loading your projects…</p>
    </div>

    <!-- Project Table -->
    <div id="tableWrap" class="card d-none" style="border-radius:var(--radius); overflow:hidden;">
        <table class="data-table" id="projectTable">
            <thead>
                <tr>
                    <th>Project Title</th>
                    <th>Domain</th>
                    <th>GitHub</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="projectsTableBody"></tbody>
        </table>
    </div>

    <!-- Empty State -->
    <div id="emptyState" class="card d-none">
        <div class="empty-state">
            <div class="empty-icon">📁</div>
            <h4>No projects yet</h4>
            <p>You haven't submitted any projects. Start by clicking the button below.</p>
            <a href="submit-project.jsp" class="btn btn-brand">Submit Your First Project</a>
        </div>
    </div>

    <!-- Error State -->
    <div id="errorState" class="card d-none">
        <div class="empty-state">
            <div class="empty-icon">⚠️</div>
            <h4>Failed to load projects</h4>
            <p>Could not connect to the server. Please try again.</p>
            <button onclick="loadDashboard()" class="btn btn-outline-slate">Retry</button>
        </div>
    </div>

</div>

<footer class="app-footer">
    © 2024 Project Repository & Evaluation System
</footer>

<script src="css/app.js"></script>
<script>
    async function loadDashboard() {
        document.getElementById('loading').classList.remove('d-none');
        document.getElementById('tableWrap').classList.add('d-none');
        document.getElementById('emptyState').classList.add('d-none');
        document.getElementById('errorState').classList.add('d-none');

        try {
            const res = await fetch('StudentDashboardServlet');
            if (checkAuthRedirect(res)) return;

            const data = await res.json();
            document.getElementById('loading').classList.add('d-none');
            document.getElementById('welcomeUser').textContent = data.user;

            const tbody = document.getElementById('projectsTableBody');
            tbody.innerHTML = '';

            if (!data.projects || data.projects.length === 0) {
                document.getElementById('emptyState').classList.remove('d-none');
                return;
            }

            data.projects.forEach(p => {
                const actionBtn = p.status === 'DRAFT'
                    ? `<a href="submit-project.jsp?id=${p.id}" class="btn btn-sm btn-outline-slate">Edit Draft</a>`
                    : `<a href="project-details.jsp?id=${p.id}" class="btn btn-sm btn-brand">View Details</a>`;
                tbody.innerHTML += `
                    <tr>
                        <td class="fw-title">${escHtml(p.title)}</td>
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

    function escHtml(s) {
        const d = document.createElement('div'); d.textContent = s || ''; return d.innerHTML;
    }

    document.addEventListener('DOMContentLoaded', loadDashboard);
</script>
</body>
</html>
