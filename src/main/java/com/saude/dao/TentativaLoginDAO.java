package com.saude.dao;

import com.saude.model.TentativaLogin;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TentativaLoginDAO {

    public void salvar(TentativaLogin t) throws SQLException {
        String sql = "INSERT INTO tentativa_login (identificador, momento, sucesso, ip) VALUES (?,?,?,?)";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getIdentificador());
            ps.setTimestamp(2, Timestamp.valueOf(t.getMomento()));
            ps.setBoolean(3, t.isSucesso());
            ps.setString(4, t.getIp());
            ps.executeUpdate();
        }
    }

    public List<TentativaLogin> listarUltimas(int limite) throws SQLException {
        List<TentativaLogin> lista = new ArrayList<>();
        String sql = "SELECT * FROM tentativa_login ORDER BY momento DESC LIMIT ?";
        try (Connection conn = ConexaoDB.getConexao();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TentativaLogin t = new TentativaLogin();
                    t.setId(rs.getLong("id"));
                    t.setIdentificador(rs.getString("identificador"));
                    t.setMomento(rs.getTimestamp("momento").toLocalDateTime());
                    t.setSucesso(rs.getBoolean("sucesso"));
                    t.setIp(rs.getString("ip"));
                    lista.add(t);
                }
            }
        }
        return lista;
    }
}
