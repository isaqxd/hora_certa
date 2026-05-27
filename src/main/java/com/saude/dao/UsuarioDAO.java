package com.saude.dao;

import com.saude.model.StatusConta;
import com.saude.model.TipoUsuario;
import com.saude.model.Usuario;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public void salvar(Usuario u) throws SQLException {
        String sql = """
            INSERT INTO usuario (nome, email, cpf, senha, tipo, status, tentativas_login,
              expira_senha, primeiro_login, data_criacao,
              contato_emergencia_nome, contato_emergencia_tel,
              logradouro, numero, bairro, cidade, estado, cep, info_saude)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
            """;
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            preencherBase(ps, u, 1);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) u.setId(rs.getLong(1));
            }
        }
    }

    public void atualizar(Usuario u) throws SQLException {
        String sql = """
            UPDATE usuario SET nome=?, email=?, cpf=?, senha=?, tipo=?, status=?,
              tentativas_login=?, expira_senha=?, primeiro_login=?, data_criacao=?,
              contato_emergencia_nome=?, contato_emergencia_tel=?,
              logradouro=?, numero=?, bairro=?, cidade=?, estado=?, cep=?, info_saude=?,
              bloqueio_ate=?, ultimo_acesso=?
            WHERE id=?
            """;
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencherBase(ps, u, 1);
            ps.setTimestamp(20, toTimestamp(u.getBloqueioAte()));
            ps.setTimestamp(21, toTimestamp(u.getUltimoAcesso()));
            ps.setLong(22, u.getId());
            ps.executeUpdate();
        }
    }

    public Usuario buscarPorEmailOuCpf(String identificador) throws SQLException {
        String sql = "SELECT * FROM usuario WHERE email=? OR cpf=?";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identificador);
            ps.setString(2, identificador);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    public Usuario buscarPorId(Long id) throws SQLException {
        String sql = "SELECT * FROM usuario WHERE id=?";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    public List<Usuario> listarPacientes() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario WHERE tipo='PACIENTE' AND status='ATIVO' ORDER BY nome";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        }
        return lista;
    }

    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY nome";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        }
        return lista;
    }

    public boolean emailOuCpfJaExiste(String email, String cpf, Long idIgnorar) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuario WHERE (email=? OR cpf=?) AND id<>?";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, cpf);
            ps.setLong(3, idIgnorar == null ? -1 : idIgnorar);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Preenche os 19 campos comuns a INSERT e UPDATE (posição inicial = offset)
    private void preencherBase(PreparedStatement ps, Usuario u, int i) throws SQLException {
        ps.setString(i++, u.getNome());
        ps.setString(i++, u.getEmail());
        ps.setString(i++, u.getCpf());
        ps.setString(i++, u.getSenha());
        ps.setString(i++, u.getTipo().name());
        ps.setString(i++, u.getStatus().name());
        ps.setInt   (i++, u.getTentativasLogin());
        ps.setTimestamp(i++, toTimestamp(u.getExpiraSenha()));
        ps.setBoolean(i++, u.isPrimeiroLogin());
        ps.setTimestamp(i++, toTimestamp(u.getDataCriacao()));
        ps.setString(i++, u.getContatoEmergenciaNome());
        ps.setString(i++, u.getContatoEmergenciaTel());
        ps.setString(i++, u.getLogradouro());
        ps.setString(i++, u.getNumero());
        ps.setString(i++, u.getBairro());
        ps.setString(i++, u.getCidade());
        ps.setString(i++, u.getEstado());
        ps.setString(i++, u.getCep());
        ps.setString(i,   u.getInfoSaude());
    }

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getLong("id"));
        u.setNome(rs.getString("nome"));
        u.setEmail(rs.getString("email"));
        u.setCpf(rs.getString("cpf"));
        u.setSenha(rs.getString("senha"));
        u.setTipo(TipoUsuario.valueOf(rs.getString("tipo")));
        u.setStatus(StatusConta.valueOf(rs.getString("status")));
        u.setTentativasLogin(rs.getInt("tentativas_login"));
        u.setPrimeiroLogin(rs.getBoolean("primeiro_login"));
        u.setDataCriacao(toLocalDateTime(rs.getTimestamp("data_criacao")));
        u.setUltimoAcesso(toLocalDateTime(rs.getTimestamp("ultimo_acesso")));
        u.setBloqueioAte(toLocalDateTime(rs.getTimestamp("bloqueio_ate")));
        u.setExpiraSenha(toLocalDateTime(rs.getTimestamp("expira_senha")));
        u.setContatoEmergenciaNome(rs.getString("contato_emergencia_nome"));
        u.setContatoEmergenciaTel(rs.getString("contato_emergencia_tel"));
        u.setLogradouro(rs.getString("logradouro"));
        u.setNumero(rs.getString("numero"));
        u.setBairro(rs.getString("bairro"));
        u.setCidade(rs.getString("cidade"));
        u.setEstado(rs.getString("estado"));
        u.setCep(rs.getString("cep"));
        u.setInfoSaude(rs.getString("info_saude"));
        return u;
    }

    private Timestamp toTimestamp(LocalDateTime ldt) {
        return ldt == null ? null : Timestamp.valueOf(ldt);
    }

    private LocalDateTime toLocalDateTime(Timestamp ts) {
        return ts == null ? null : ts.toLocalDateTime();
    }
}
