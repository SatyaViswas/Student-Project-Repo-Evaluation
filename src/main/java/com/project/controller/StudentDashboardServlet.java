package com.project.controller;

import com.project.dao.ProjectDAO;
import com.project.model.Project;
import com.project.model.User;
import com.project.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {

    private ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.setStatus(401);
            out.print("{\"error\": \"Not authenticated\"}");
            return;
        }
        
        User user = (User) session.getAttribute("loggedUser");
        if (!"STUDENT".equals(user.getRole())) {
            resp.setStatus(403);
            out.print("{\"error\": \"Access denied\"}");
            return;
        }

        List<Project> projects = projectDAO.getProjectsByStudentId(user.getId());
        
        StringBuilder json = new StringBuilder();
        json.append("{\"user\": \"").append(JsonUtil.escape(user.getName())).append("\", \"projects\": [");
        
        for (int i = 0; i < projects.size(); i++) {
            Project p = projects.get(i);
            json.append("{");
            json.append("\"id\": ").append(p.getId()).append(", ");
            json.append("\"title\": \"").append(JsonUtil.escape(p.getTitle())).append("\", ");
            json.append("\"domainTag\": \"").append(JsonUtil.escape(p.getDomainTag())).append("\", ");
            json.append("\"githubUrl\": \"").append(JsonUtil.escape(p.getGithubUrl())).append("\", ");
            json.append("\"status\": \"").append(JsonUtil.escape(p.getStatus())).append("\"");
            json.append("}");
            if (i < projects.size() - 1) json.append(", ");
        }
        
        json.append("]}");
        out.print(json.toString());
    }
}
