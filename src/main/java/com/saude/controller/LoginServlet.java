package com.saude.controller;

import com.saude.service.AutenticacaoService;
import com.saude.service.AutenticacaoService.ResultadoLogin;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {

    private final AutenticacaoService autenticacaoService = new AutenticacaoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuarioLogado") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String identificador = req.getParameter("identificador");
        String senha = req.getParameter("senha");
        String ip = req.getRemoteAddr();

        try {
            ResultadoLogin resultado = autenticacaoService.autenticar(identificador, senha, ip);

            if (!resultado.isAutenticado()) {
                req.setAttribute("erro", resultado.getMensagem());
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("usuarioLogado", resultado.getUsuario());
            // RF02: logout automático após 30 minutos de inatividade
            session.setMaxInactiveInterval(30 * 60);

            if (resultado.isRequerTrocaSenha()) {
                session.setAttribute("avisoSenha", resultado.getMensagem());
                resp.sendRedirect(req.getContextPath() + "/trocar-senha");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }

        } catch (SQLException e) {
            req.setAttribute("erro", "Erro interno. Tente novamente.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
