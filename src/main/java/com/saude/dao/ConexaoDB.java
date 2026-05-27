package com.saude.dao;

import org.h2.jdbcx.JdbcDataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class ConexaoDB {

    private static final String URL = "jdbc:h2:~/saude/medicamentosdb";
    private static final String USUARIO = "sa";
    private static final String SENHA = "";
    private static JdbcDataSource dataSource;

    static {
        dataSource = new JdbcDataSource();
        dataSource.setURL(URL);
        dataSource.setUser(USUARIO);
        dataSource.setPassword(SENHA);
    }

    public static Connection getConexao() throws SQLException {
        return dataSource.getConnection();
    }

    public static void inicializar() {
        try (Connection conn = getConexao(); Statement stmt = conn.createStatement()) {

            stmt.execute("""
                CREATE TABLE IF NOT EXISTS usuario (
                    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
                    nome        VARCHAR(255) NOT NULL,
                    email       VARCHAR(255) UNIQUE,
                    cpf         VARCHAR(14)  UNIQUE,
                    senha       VARCHAR(255) NOT NULL,
                    tipo        VARCHAR(20)  NOT NULL,
                    data_criacao  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    ultimo_acesso TIMESTAMP,
                    status            VARCHAR(20) DEFAULT 'ATIVO',
                    tentativas_login  INT DEFAULT 0,
                    bloqueio_ate      TIMESTAMP,
                    expira_senha      TIMESTAMP,
                    primeiro_login    BOOLEAN DEFAULT TRUE,
                    contato_emergencia_nome VARCHAR(255),
                    contato_emergencia_tel  VARCHAR(20),
                    logradouro  VARCHAR(255),
                    numero      VARCHAR(20),
                    bairro      VARCHAR(100),
                    cidade      VARCHAR(100),
                    estado      CHAR(2),
                    cep         VARCHAR(10),
                    info_saude  TEXT
                )
            """);

            stmt.execute("""
                CREATE TABLE IF NOT EXISTS medicamento (
                    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
                    nome         VARCHAR(255) NOT NULL,
                    dosagem      VARCHAR(100),
                    frequencia   VARCHAR(100),
                    medico       VARCHAR(255),
                    paciente_id  BIGINT,
                    data_inicio  DATE,
                    data_fim     DATE,
                    ativo        BOOLEAN DEFAULT TRUE,
                    observacoes  TEXT,
                    FOREIGN KEY (paciente_id) REFERENCES usuario(id)
                )
            """);

            stmt.execute("""
                CREATE TABLE IF NOT EXISTS tentativa_login (
                    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
                    identificador VARCHAR(255) NOT NULL,
                    momento       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    sucesso       BOOLEAN NOT NULL,
                    ip            VARCHAR(50)
                )
            """);

            criarAdminPadrao(conn);

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao inicializar banco de dados", e);
        }
    }

    private static void criarAdminPadrao(Connection conn) throws SQLException {
        try (var ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM usuario WHERE tipo = 'ADMINISTRADOR'");
             var rs = ps.executeQuery()) {
            rs.next();
            if (rs.getInt(1) == 0) {
                String senhaHash = org.mindrot.jbcrypt.BCrypt.hashpw("Admin@123", org.mindrot.jbcrypt.BCrypt.gensalt(12));
                try (var insert = conn.prepareStatement(
                        "INSERT INTO usuario (nome, email, cpf, senha, tipo, expira_senha, primeiro_login) " +
                        "VALUES ('Administrador', 'admin@saude.com', '000.000.000-00', ?, 'ADMINISTRADOR', " +
                        "DATEADD('DAY', 90, CURRENT_TIMESTAMP), TRUE)")) {
                    insert.setString(1, senhaHash);
                    insert.executeUpdate();
                }
            }
        }
    }
}
