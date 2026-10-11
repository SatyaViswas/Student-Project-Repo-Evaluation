<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Showcase — Student Projects Gallery</title>
    <meta name="description" content="Explore evaluated capstone projects submitted by our students. Filter by domain, search by keyword, and sort by score.">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="app-nav navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="showcase.jsp">
            <span class="brand-icon">⬡</span> Project Showcase
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="showcase.jsp" class="nav-link active">Gallery</a>
            <a href="login.jsp" class="nav-link">Login</a>
            <a href="register.jsp" class="btn btn-brand btn-sm">Register</a>
        </div>
    </div>
</nav>

<!-- Hero -->
<div class="hero-banner">
    <div class="container">
        <h1>Student Project Gallery</h1>
        <p>Discover innovative capstone projects built by our students</p>
    </div>
</div>

<!-- Filters -->
<div class="container" style="margin-top:-1.5rem; position:relative; z-index:10; padding-bottom:0;">
    <div class="card shadow" style="border-radius:var(--radius);">
        <div class="card-body p-3">
            <form id="filterForm" class="row g-2 align-items-center" onsubmit="event.preventDefault(); loadProjects();">
                <div class="col-12 col-md-5">
                    <input type="text" class="form-control" id="searchQuery" placeholder="Search by title or keyword…" aria-label="Search">
                </div>
                <div class="col-6 col-md-3">
                    <select class="form-select" id="domainFilter" aria-label="Filter by domain">
                        <option value="All">All Domains</option>
                    </select>
                </div>
                <div class="col-6 col-md-3">
                    <select class="form-select" id="sortBy" aria-label="Sort by">
                        <option value="date_desc">Newest First</option>
                        <option value="score_desc">Highest Score</option>
                        <option value="title_asc">Title A–Z</option>
                    </select>
                </div>
                <div class="col-12 col-md-1 d-grid">
                    <button type="submit" class="btn btn-brand">Go</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Gallery -->
<div class="container" style="padding-top:2.5rem; padding-bottom:4rem;">

    <div id="loading" class="text-center py-5">
        <div class="spinner-border spinner-brand" role="status" style="width:2.5rem;height:2.5rem;"></div>
        <p class="mt-3 text-slate-500 fw-600">Loading projects…</p>
    </div>

    <div id="noResults" class="card d-none">
        <div class="empty-state">
            <div class="empty-icon">🔍</div>
            <h4>No projects found</h4>
            <p>Try adjusting your search terms or clearing the domain filter.</p>
            <button class="btn btn-outline-slate" onclick="resetFilters()">Clear Filters</button>
        </div>
    </div>

    <div class="row g-4" id="projectGrid"></div>
</div>

<footer class="app-footer">
    © 2024 Project Repository & Evaluation System · <a href="login.jsp" style="color:inherit;">Sign in</a> · <a href="register.jsp" style="color:inherit;">Register</a>
</footer>

<script src="css/app.js"></script>
<script>
    let domainsLoaded = false;

    function resetFilters() {
        document.getElementById('searchQuery').value = '';
        document.getElementById('domainFilter').value = 'All';
        document.getElementById('sortBy').value = 'date_desc';
        loadProjects();
    }

    function escHtml(s) {
        const d = document.createElement('div'); d.textContent = s || ''; return d.innerHTML;
    }

    async function loadProjects() {
        const grid = document.getElementById('projectGrid');
        const noRes = document.getElementById('noResults');
        const loading = document.getElementById('loading');

        grid.innerHTML = '';
        noRes.classList.add('d-none');
        loading.classList.remove('d-none');

        const q      = encodeURIComponent(document.getElementById('searchQuery').value);
        const domain = encodeURIComponent(document.getElementById('domainFilter').value);
        const sort   = encodeURIComponent(document.getElementById('sortBy').value);

        try {
            const res  = await fetch(`PublicShowcaseServlet?q=${q}&domain=${domain}&sortBy=${sort}`);
            const data = await res.json();

            loading.classList.add('d-none');

            // Populate domain dropdown once
            if (!domainsLoaded && data.domains && data.domains.length > 0) {
                const sel = document.getElementById('domainFilter');
                data.domains.forEach(d => {
                    const opt = document.createElement('option');
                    opt.value = d; opt.textContent = d;
                    sel.appendChild(opt);
                });
                domainsLoaded = true;
            }

            if (!data.projects || data.projects.length === 0) {
                noRes.classList.remove('d-none');
                return;
            }

            data.projects.forEach(p => {
                let scorePill = '';
                if (p.status === 'EVALUATED') {
                    scorePill = scoreBadge(p.totalScore);
                }

                const demoBtn = p.demoUrl
                    ? `<a href="${escHtml(p.demoUrl)}" target="_blank" class="btn btn-sm btn-outline-slate">Demo ↗</a>`
                    : '';

                grid.innerHTML += `
                <div class="col-12 col-md-6 col-lg-4">
                    <div class="proj-card">
                        <div class="proj-card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <span class="badge badge-domain">${escHtml(p.domainTag)}</span>
                                ${scorePill}
                            </div>
                            <h3 class="proj-card-title">${escHtml(p.title)}</h3>
                            <p class="proj-card-author">By ${escHtml(p.studentName)}</p>
                            <p class="proj-card-abstract">${escHtml(p.abstractText)}</p>
                        </div>
                        <div class="proj-card-footer">
                            <a href="public-project.jsp?id=${p.id}" class="btn btn-sm btn-brand">View Details</a>
                            <div class="d-flex gap-2">
                                <a href="${escHtml(p.githubUrl)}" target="_blank" class="btn btn-sm btn-outline-slate">GitHub</a>
                                ${demoBtn}
                            </div>
                        </div>
                    </div>
                </div>`;
            });
        } catch (err) {
            loading.classList.add('d-none');
            grid.innerHTML = `
                <div class="col-12">
                    <div class="card">
                        <div class="empty-state">
                            <div class="empty-icon">⚠️</div>
                            <h4>Failed to load projects</h4>
                            <p>Could not connect to the server. Is Tomcat running?</p>
                            <button class="btn btn-outline-slate" onclick="loadProjects()">Retry</button>
                        </div>
                    </div>
                </div>`;
        }
    }

    document.addEventListener('DOMContentLoaded', loadProjects);

    // Trigger on Enter in search box
    document.addEventListener('DOMContentLoaded', () => {
        document.getElementById('searchQuery').addEventListener('keydown', e => {
            if (e.key === 'Enter') { e.preventDefault(); loadProjects(); }
        });
    });
</script>
</body>
</html>
