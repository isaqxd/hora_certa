package com.saude.dao;

import com.saude.model.Medicamento;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicamentoDAO {

    public void salvar(Medicamento m) throws SQLException {
        String sql = "INSERT INTO medicamento (nome, dosagem, frequencia, medico, paciente_id, " +
                     "data_inicio, data_fim, ativo, observacoes) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            preencher(ps, m);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) m.setId(rs.getLong(1));
            }
        }
    }

    public void atualizar(Medicamento m) throws SQLException {
        String sql = "UPDATE medicamento SET nome=?, dosagem=?, frequencia=?, medico=?, paciente_id=?, " +
                     "data_inicio=?, data_fim=?, ativo=?, observacoes=? WHERE id=?";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencher(ps, m);
            ps.setLong(10, m.getId());
            ps.executeUpdate();
        }
    }

    public void excluir(Long id) throws SQLException {
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM medicamento WHERE id=?")) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    public Medicamento buscarPorId(Long id) throws SQLException {
        String sql = "SELECT m.*, u.nome AS paciente_nome FROM medicamento m " +
                     "LEFT JOIN usuario u ON m.paciente_id = u.id WHERE m.id=?";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    public List<Medicamento> listarTodos() throws SQLException {
        List<Medicamento> lista = new ArrayList<>();
        String sql = "SELECT m.*, u.nome AS paciente_nome FROM medicamento m " +
                     "LEFT JOIN usuario u ON m.paciente_id = u.id ORDER BY m.nome";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        }
        return lista;
    }

    public List<Medicamento> listarPorPaciente(Long pacienteId) throws SQLException {
        List<Medicamento> lista = new ArrayList<>();
        String sql = "SELECT m.*, u.nome AS paciente_nome FROM medicamento m " +
                     "LEFT JOIN usuario u ON m.paciente_id = u.id " +
                     "WHERE m.paciente_id=? ORDER BY m.nome";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, pacienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        return lista;
    }

    private void preencher(PreparedStatement ps, Medicamento m) throws SQLException {
        ps.setString(1, m.getNome());
        ps.setString(2, m.getDosagem());
        ps.setString(3, m.getFrequencia());
        ps.setString(4, m.getMedico());
        if (m.getPacienteId() != null) ps.setLong(5, m.getPacienteId());
        else ps.setNull(5, Types.BIGINT);
        ps.setDate(6, m.getDataInicio() != null ? Date.valueOf(m.getDataInicio()) : null);
        ps.setDate(7, m.getDataFim() != null ? Date.valueOf(m.getDataFim()) : null);
        ps.setBoolean(8, m.isAtivo());
        ps.setString(9, m.getObservacoes());
    }

    private Medicamento mapear(ResultSet rs) throws SQLException {
        Medicamento m = new Medicamento();
        m.setId(rs.getLong("id"));
        m.setNome(rs.getString("nome"));
        m.setDosagem(rs.getString("dosagem"));
        m.setFrequencia(rs.getString("frequencia"));
        m.setMedico(rs.getString("medico"));
        m.setPacienteId(rs.getLong("paciente_id"));
        m.setPacienteNome(rs.getString("paciente_nome"));
        m.setAtivo(rs.getBoolean("ativo"));
        m.setObservacoes(rs.getString("observacoes"));
        Date di = rs.getDate("data_inicio");
        if (di != null) m.setDataInicio(di.toLocalDate());
        Date df = rs.getDate("data_fim");
        if (df != null) m.setDataFim(df.toLocalDate());
        return m;
    }
}
