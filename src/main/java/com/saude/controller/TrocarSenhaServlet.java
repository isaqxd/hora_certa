package com.saude.controller;

import com.saude.model.Usuario;
import com.saude.service.AutenticacaoService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class TrocarSenhaServlet extends HttpServlet {

    private final AutenticacaoService autenticacaoService = new AutenticacaoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/trocar-senha.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        String senhaAtual = req.getParameter("senhaAtual");
        String novaSenha = req.getParameter("novaSenha");
        String confirmacao = req.getParameter("confirmacao");

        try {
            // No primeiro login não há senha "atual" para verificar, apenas nova + confirmação
            String senhaAtualParam = usuario.isPrimeiroLogin() ? null : senhaAtual;
            String erro = autenticacaoService.trocarSenha(usuario.getId(), senhaAtualParam, novaSenha, confirmacao);

            if (erro != null) {
                req.setAttribute("erro", erro);
                req.getRequestDispatcher("/trocar-senha.jsp").forward(req, resp);
                return;
            }

            // Atualiza sessão com dados atualizados
            session.removeAttribute("avisoSenha");
            usuario.setPrimeiroLogin(false);
            resp.sendRedirect(req.getContextPath() + "/dashboard?msg=senha_atualizada");

        } catch (SQLException e) {
            req.setAttribute("erro", "Erro ao atualizar senha. Tente novamente.");
            req.getRequestDispatcher("/trocar-senha.jsp").forward(req, resp);
        }
    }
}
