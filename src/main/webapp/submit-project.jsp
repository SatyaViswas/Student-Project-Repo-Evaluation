<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Project — Project Repository</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>

<nav class="app-nav navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="student-dashboard.jsp">
            <span class="brand-icon">⬡</span> Project Repository
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="student-dashboard.jsp" class="nav-link">← Dashboard</a>
            <a href="auth?action=logout" class="btn btn-sm btn-nav-logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container" style="padding-top:2rem; padding-bottom:4rem; max-width:780px;">

    <div class="page-header">
        <h2 id="formPageTitle">Submit New Project</h2>
        <p>Fill in the details below. You can save a draft and return later before submitting.</p>
    </div>

    <div id="alertMsg" class="alert d-none mb-4"></div>

    <div class="card">
        <div class="card-body p-4">
            <form id="projectForm" enctype="multipart/form-data" novalidate>
                <input type="hidden" id="projectId" name="projectId">

                <div class="mb-4">
                    <label for="title" class="form-label">Project Title</label>
                    <input type="text" class="form-control" id="title" name="title" placeholder="e.g. Smart Campus Navigation System" required>
                    <div class="invalid-feedback">Project title is required.</div>
                </div>

                <div class="mb-4">
                    <label for="domainTag" class="form-label">Domain</label>
                    <select class="form-select" id="domainTag" name="domainTag" required>
                        <option value="" disabled selected>Select a domain</option>
                        <option value="Web">Web Development</option>
                        <option value="AI">Artificial Intelligence</option>
                        <option value="Cloud">Cloud Computing</option>
                        <option value="Blockchain">Blockchain</option>
                        <option value="Mobile">Mobile Apps</option>
                        <option value="Other">Other</option>
                    </select>
                    <div class="invalid-feedback">Please select a domain.</div>
                </div>

                <div class="mb-4">
                    <label for="abstractText" class="form-label">Abstract</label>
                    <textarea class="form-control" id="abstractText" name="abstractText" rows="5" placeholder="Briefly describe your project goals, methodology, and outcomes…" required></textarea>
                    <div class="invalid-feedback">Abstract is required.</div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label for="githubUrl" class="form-label">GitHub Repository URL</label>
                        <input type="url" class="form-control" id="githubUrl" name="githubUrl" placeholder="https://github.com/user/repo" required>
                        <div class="invalid-feedback">Enter a valid GitHub URL.</div>
                    </div>
                    <div class="col-md-6">
                        <label for="demoUrl" class="form-label">Live Demo URL <span class="fw-400 text-slate-500">(optional)</span></label>
                        <input type="url" class="form-control" id="demoUrl" name="demoUrl" placeholder="https://your-demo.com">
                        <div class="invalid-feedback">Enter a valid URL or leave empty.</div>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="pdfFile" class="form-label">Project Report <span class="fw-400 text-slate-500">(PDF, optional)</span></label>
                    <input class="form-control" type="file" id="pdfFile" name="pdfFile" accept="application/pdf">
                    <p class="form-hint" id="pdfHelp">Upload your final project report PDF.</p>
                </div>

                <input type="hidden" id="status" name="status" value="DRAFT">

                <hr class="divider">
                <div class="d-flex justify-content-end gap-2 flex-wrap">
                    <a href="student-dashboard.jsp" class="btn btn-outline-slate">Cancel</a>
                    <button type="button" class="btn btn-outline-slate" id="draftBtn" onclick="submitForm('DRAFT')">Save as Draft</button>
                    <button type="button" class="btn btn-brand" id="submitBtn" onclick="submitForm('SUBMITTED')">Submit Project</button>
                </div>
            </form>
        </div>
    </div>
</div>

<footer class="app-footer">© 2024 Project Repository & Evaluation System</footer>

<script src="css/app.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", async () => {
        attachUrlValidation('githubUrl', true);
        attachUrlValidation('demoUrl', false);

        const projectId = new URLSearchParams(window.location.search).get('id');
        if (!projectId) return;

        document.getElementById('formPageTitle').textContent = 'Edit Draft Project';
        try {
            const res = await fetch(`ViewProjectServlet?id=${projectId}`);
            if (checkAuthRedirect(res)) return;
            const data = await res.json();
            if (data.error) { showAlert('alertMsg', data.error); return; }

            document.getElementById('projectId').value = data.id;
            document.getElementById('title').value = data.title;
            document.getElementById('domainTag').value = data.domainTag;
            document.getElementById('abstractText').value = data.abstractText;
            document.getElementById('githubUrl').value = data.githubUrl;
            document.getElementById('demoUrl').value = data.demoUrl || '';
            if (data.pdfPath) {
                document.getElementById('pdfHelp').textContent = "A report PDF is already uploaded. Choose a new file to replace it.";
            }
        } catch {
            showAlert('alertMsg', 'Could not load project data. Please try again.');
        }
    });

    async function submitForm(targetStatus) {
        const form = document.getElementById('projectForm');
        form.classList.add('was-validated');

        const demoVal = document.getElementById('demoUrl').value.trim();
        if (demoVal && !isValidUrl(demoVal)) {
            document.getElementById('demoUrl').classList.add('is-invalid');
            return;
        }
        if (!form.checkValidity()) return;

        document.getElementById('status').value = targetStatus;
        const alertEl = document.getElementById('alertMsg');
        alertEl.className = 'alert d-none';
        const btn = targetStatus === 'DRAFT' ? document.getElementById('draftBtn') : document.getElementById('submitBtn');
        btn.disabled = true;
        const origText = btn.textContent;
        btn.textContent = 'Saving…';

        try {
            const res = await fetch('SubmitProjectServlet', { method: 'POST', body: new FormData(form) });
            const result = await res.json();

            if (result.success) {
                showToast(result.message, 'success');
                setTimeout(() => window.location.href = 'student-dashboard.jsp', 1200);
            } else {
                showAlert('alertMsg', result.message || 'Failed to save project.');
                btn.disabled = false;
                btn.textContent = origText;
            }
        } catch {
            showAlert('alertMsg', 'Network error. Please try again.');
            btn.disabled = false;
            btn.textContent = origText;
        }
    }
</script>
</body>
</html>
