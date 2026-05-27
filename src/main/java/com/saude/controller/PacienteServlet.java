package com.saude.controller;

import com.saude.model.StatusConta;
import com.saude.model.Usuario;
import com.saude.service.UsuarioService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class PacienteServlet extends HttpServlet {

    private final UsuarioService service = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/lista")) {
                req.setAttribute("usuarios", service.listarTodos());
                req.getRequestDispatcher("/WEB-INF/views/pacientes/lista.jsp").forward(req, resp);

            } else if (pathInfo.equals("/novo")) {
                req.getRequestDispatcher("/WEB-INF/views/pacientes/form.jsp").forward(req, resp);

            } else if (pathInfo.equals("/editar")) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("usuario", service.buscarPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/pacientes/form.jsp").forward(req, resp);

            } else if (pathInfo.equals("/ativar")) {
                Long id = Long.parseLong(req.getParameter("id"));
                service.alterarStatus(id, StatusConta.ATIVO);
                resp.sendRedirect(req.getContextPath() + "/pacientes/lista?msg=ativado");

            } else if (pathInfo.equals("/desativar")) {
                Long id = Long.parseLong(req.getParameter("id"));
                service.alterarStatus(id, StatusConta.INATIVO);
                resp.sendRedirect(req.getContextPath() + "/pacientes/lista?msg=desativado");

            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            req.setAttribute("erro", "Erro ao acessar os dados: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/pacientes/lista.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            Usuario u = service.fromParams(
                    req.getParameter("id"),
                    req.getParameter("nome"),
                    req.getParameter("email"),
                    req.getParameter("cpf"),
                    req.getParameter("tipo"),
                    req.getParameter("status"),
                    req.getParameter("contatoEmergenciaNome"),
                    req.getParameter("contatoEmergenciaTel"),
                    req.getParameter("logradouro"),
                    req.getParameter("numero"),
                    req.getParameter("bairro"),
                    req.getParameter("cidade"),
                    req.getParameter("estado"),
                    req.getParameter("cep"),
                    req.getParameter("infoSaude")
            );
            String senha       = req.getParameter("senha");
            String confirmacao = req.getParameter("confirmacao");

            String erro = service.salvar(u, senha, confirmacao);
            if (erro != null) {
                req.setAttribute("usuario", u);
                req.setAttribute("erro", erro);
                req.getRequestDispatcher("/WEB-INF/views/pacientes/form.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/pacientes/lista?msg=salvo");

        } catch (SQLException e) {
            req.setAttribute("erro", "Erro ao salvar: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/pacientes/form.jsp").forward(req, resp);
        }
    }
}
