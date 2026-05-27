package com.saude.controller;

import com.saude.model.Medicamento;
import com.saude.service.MedicamentoService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class MedicamentoServlet extends HttpServlet {

    private final MedicamentoService service = new MedicamentoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo(); // /novo, /editar?id=X, /excluir?id=X

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/lista")) {
                req.setAttribute("medicamentos", service.listarTodos());
                req.getRequestDispatcher("/WEB-INF/views/medicamentos/lista.jsp").forward(req, resp);

            } else if (pathInfo.equals("/novo")) {
                req.setAttribute("pacientes", service.listarPacientes());
                req.getRequestDispatcher("/WEB-INF/views/medicamentos/form.jsp").forward(req, resp);

            } else if (pathInfo.equals("/editar")) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("medicamento", service.buscarPorId(id));
                req.setAttribute("pacientes", service.listarPacientes());
                req.getRequestDispatcher("/WEB-INF/views/medicamentos/form.jsp").forward(req, resp);

            } else if (pathInfo.equals("/excluir")) {
                Long id = Long.parseLong(req.getParameter("id"));
                service.excluir(id);
                resp.sendRedirect(req.getContextPath() + "/medicamentos/lista?msg=excluido");

            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            req.setAttribute("erro", "Erro ao acessar os dados: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/medicamentos/lista.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Medicamento m = service.fromParams(
                req.getParameter("id"),
                req.getParameter("nome"),
                req.getParameter("dosagem"),
                req.getParameter("frequencia"),
                req.getParameter("medico"),
                req.getParameter("pacienteId"),
                req.getParameter("dataInicio"),
                req.getParameter("dataFim"),
                req.getParameter("ativo"),
                req.getParameter("observacoes")
        );

        try {
            String erro = service.salvar(m);
            if (erro != null) {
                req.setAttribute("medicamento", m);
                req.setAttribute("pacientes", service.listarPacientes());
                req.setAttribute("erro", erro);
                req.getRequestDispatcher("/WEB-INF/views/medicamentos/form.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/medicamentos/lista?msg=salvo");
        } catch (SQLException e) {
            req.setAttribute("erro", "Erro ao salvar: " + e.getMessage());
            try {
                req.setAttribute("medicamento", m);
                req.setAttribute("pacientes", service.listarPacientes());
            } catch (SQLException ignored) {}
            req.getRequestDispatcher("/WEB-INF/views/medicamentos/form.jsp").forward(req, resp);
        }
    }
}
