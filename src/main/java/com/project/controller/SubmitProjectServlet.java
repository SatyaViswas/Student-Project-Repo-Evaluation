package com.project.controller;

import com.project.dao.ProjectDAO;
import com.project.model.Project;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/SubmitProjectServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class SubmitProjectServlet extends HttpServlet {

    private ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.setStatus(401);
            out.print("{\"success\": false, \"message\": \"Not authenticated.\"}");
            return;
        }
        
        User user = (User) session.getAttribute("loggedUser");
        if (!"STUDENT".equals(user.getRole())) {
            resp.setStatus(403);
            out.print("{\"success\": false, \"message\": \"Access denied.\"}");
            return;
        }

        try {
            String title = req.getParameter("title");
            String abstractText = req.getParameter("abstractText");
            String domainTag = req.getParameter("domainTag");
            String githubUrl = req.getParameter("githubUrl");
            String demoUrl = req.getParameter("demoUrl");
            String status = req.getParameter("status"); 
            
            Part filePart = req.getPart("pdfFile");
            String pdfPath = null;
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                filePart.write(uploadPath + File.separator + fileName);
                pdfPath = "uploads/" + fileName;
            }
            
            String projectIdStr = req.getParameter("projectId");

            Project project = new Project();
            project.setStudentId(user.getId());
            project.setTitle(title);
            project.setAbstractText(abstractText);
            project.setDomainTag(domainTag);
            project.setGithubUrl(githubUrl);
            project.setDemoUrl(demoUrl);
            project.setStatus(status);

            boolean success;
            if (projectIdStr != null && !projectIdStr.isEmpty()) {
                project.setId(Integer.parseInt(projectIdStr));
                if (pdfPath == null) {
                    Project existing = projectDAO.getProjectById(project.getId());
                    if (existing != null) project.setPdfPath(existing.getPdfPath());
                } else {
                    project.setPdfPath(pdfPath);
                }
                success = projectDAO.updateProject(project);
            } else {
                project.setPdfPath(pdfPath);
                success = projectDAO.createProject(project);
            }

            if (success) {
                out.print("{\"success\": true, \"message\": \"Project saved successfully.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to save project.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            out.print("{\"success\": false, \"message\": \"Server error occurred.\"}");
        }
    }
}
