package com.project.controller;

import com.project.dao.UserDAO;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if ("register".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if (name == null || email == null || password == null || role == null ||
                name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"All fields are required.\"}");
                return;
            }

            if (userDAO.isEmailRegistered(email)) {
                out.print("{\"success\": false, \"message\": \"Email is already registered.\"}");
                return;
            }

            User user = new User();
            user.setName(name.trim());
            user.setEmail(email.trim());
            user.setPassword(password);
            user.setRole(role);

            boolean registered = userDAO.registerUser(user);
            if (registered) {
                out.print("{\"success\": true, \"message\": \"Registration successful.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Registration failed. Please try again.\"}");
            }

        } else if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User user = userDAO.validateLogin(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", user);
                out.print("{\"success\": true, \"role\": \"" + user.getRole() + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Invalid email or password.\"}");
            }
        } else {
            out.print("{\"success\": false, \"message\": \"Invalid action.\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}
