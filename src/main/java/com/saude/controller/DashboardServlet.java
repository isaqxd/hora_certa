package com.saude.controller;

import com.saude.dao.TentativaLoginDAO;
import com.saude.service.MedicamentoService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class DashboardServlet extends HttpServlet {

    private final MedicamentoService medicamentoService = new MedicamentoService();
    private final TentativaLoginDAO tentativaDAO = new TentativaLoginDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalMedicamentos", medicamentoService.listarTodos().size());
            req.setAttribute("totalPacientes", medicamentoService.listarPacientes().size());
            req.setAttribute("ultimasTentativas", tentativaDAO.listarUltimas(10));
        } catch (SQLException e) {
            req.setAttribute("erroDb", "Não foi possível carregar os dados.");
        }
        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}
