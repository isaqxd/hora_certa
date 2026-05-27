package com.saude.service;

import com.saude.dao.MedicamentoDAO;
import com.saude.dao.UsuarioDAO;
import com.saude.model.Medicamento;
import com.saude.model.Usuario;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class MedicamentoService {

    private final MedicamentoDAO medicamentoDAO = new MedicamentoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    public String salvar(Medicamento m) throws SQLException {
        if (m.getNome() == null || m.getNome().isBlank()) return "O nome do medicamento é obrigatório.";
        if (m.getDosagem() == null || m.getDosagem().isBlank()) return "A dosagem é obrigatória.";
        if (m.getFrequencia() == null || m.getFrequencia().isBlank()) return "A frequência é obrigatória.";
        if (m.getPacienteId() == null) return "Selecione um paciente.";
        if (m.getDataInicio() == null) return "A data de início é obrigatória.";
        if (m.getDataFim() != null && m.getDataFim().isBefore(m.getDataInicio()))
            return "A data de término não pode ser anterior à data de início.";

        if (m.getId() == null) medicamentoDAO.salvar(m);
        else medicamentoDAO.atualizar(m);

        return null;
    }

    public Medicamento buscarPorId(Long id) throws SQLException {
        return medicamentoDAO.buscarPorId(id);
    }

    public List<Medicamento> listarTodos() throws SQLException {
        return medicamentoDAO.listarTodos();
    }

    public List<Medicamento> listarPorPaciente(Long pacienteId) throws SQLException {
        return medicamentoDAO.listarPorPaciente(pacienteId);
    }

    public List<Usuario> listarPacientes() throws SQLException {
        return usuarioDAO.listarPacientes();
    }

    public void excluir(Long id) throws SQLException {
        medicamentoDAO.excluir(id);
    }

    public Medicamento fromParams(String id, String nome, String dosagem, String frequencia,
                                  String medico, String pacienteId, String dataInicio,
                                  String dataFim, String ativo, String observacoes) {
        Medicamento m = new Medicamento();
        if (id != null && !id.isBlank()) m.setId(Long.parseLong(id));
        m.setNome(nome);
        m.setDosagem(dosagem);
        m.setFrequencia(frequencia);
        m.setMedico(medico);
        if (pacienteId != null && !pacienteId.isBlank()) m.setPacienteId(Long.parseLong(pacienteId));
        if (dataInicio != null && !dataInicio.isBlank()) m.setDataInicio(LocalDate.parse(dataInicio));
        if (dataFim != null && !dataFim.isBlank()) m.setDataFim(LocalDate.parse(dataFim));
        m.setAtivo(ativo == null || ativo.equals("true"));
        m.setObservacoes(observacoes);
        return m;
    }
}
