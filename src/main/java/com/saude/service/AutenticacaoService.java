package com.saude.service;

import com.saude.dao.TentativaLoginDAO;
import com.saude.dao.UsuarioDAO;
import com.saude.model.StatusConta;
import com.saude.model.TentativaLogin;
import com.saude.model.Usuario;
import com.saude.util.SenhaUtil;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class AutenticacaoService {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final TentativaLoginDAO tentativaDAO = new TentativaLoginDAO();

    private static final int MAX_TENTATIVAS = 3;
    private static final int MINUTOS_BLOQUEIO = 15;

    public ResultadoLogin autenticar(String identificador, String senha, String ip) throws SQLException {
        TentativaLogin tentativa = new TentativaLogin(identificador, false, ip);

        Usuario usuario = usuarioDAO.buscarPorEmailOuCpf(identificador);

        if (usuario == null) {
            tentativaDAO.salvar(tentativa);
            return ResultadoLogin.falha("Credenciais inválidas.");
        }

        // Conta inativa
        if (usuario.getStatus() == StatusConta.INATIVO) {
            tentativaDAO.salvar(tentativa);
            return ResultadoLogin.falha("Conta inativa. Entre em contato com o administrador.");
        }

        // Verifica bloqueio temporário (RF02: 15 min após 3 tentativas)
        if (usuario.getStatus() == StatusConta.BLOQUEADO) {
            if (usuario.getBloqueioAte() != null && LocalDateTime.now().isBefore(usuario.getBloqueioAte())) {
                tentativaDAO.salvar(tentativa);
                return ResultadoLogin.falha("Conta bloqueada temporariamente. Tente novamente em " +
                        MINUTOS_BLOQUEIO + " minutos.");
            }
            // Desbloqueio automático após o período
            usuario.setStatus(StatusConta.ATIVO);
            usuario.setTentativasLogin(0);
            usuario.setBloqueioAte(null);
        }

        // Verifica senha
        if (!SenhaUtil.verificar(senha, usuario.getSenha())) {
            int tentativas = usuario.getTentativasLogin() + 1;
            usuario.setTentativasLogin(tentativas);
            if (tentativas >= MAX_TENTATIVAS) {
                usuario.setStatus(StatusConta.BLOQUEADO);
                usuario.setBloqueioAte(LocalDateTime.now().plusMinutes(MINUTOS_BLOQUEIO));
            }
            usuarioDAO.atualizar(usuario);
            tentativaDAO.salvar(tentativa);
            return ResultadoLogin.falha("Credenciais inválidas.");
        }

        // Login bem-sucedido
        usuario.setTentativasLogin(0);
        usuario.setBloqueioAte(null);
        usuario.setUltimoAcesso(LocalDateTime.now());
        usuarioDAO.atualizar(usuario);

        tentativa.setSucesso(true);
        tentativaDAO.salvar(tentativa);

        // Senha expirada (RF02: expira a cada 90 dias)
        if (usuario.isSenhExpirada()) {
            return ResultadoLogin.trocaSenha(usuario, "Sua senha expirou. Por favor, crie uma nova senha.");
        }

        // Primeiro login (RF02: força troca na primeira entrada)
        if (usuario.isPrimeiroLogin()) {
            return ResultadoLogin.trocaSenha(usuario, "Bem-vindo! Por segurança, defina uma nova senha.");
        }

        return ResultadoLogin.sucesso(usuario);
    }

    public String trocarSenha(Long usuarioId, String senhaAtual, String novaSenha, String confirmacao)
            throws SQLException {
        Usuario usuario = usuarioDAO.buscarPorId(usuarioId);
        if (usuario == null) return "Usuário não encontrado.";

        if (senhaAtual != null && !SenhaUtil.verificar(senhaAtual, usuario.getSenha())) {
            return "Senha atual incorreta.";
        }

        if (!novaSenha.equals(confirmacao)) {
            return "A nova senha e a confirmação não coincidem.";
        }

        if (!SenhaUtil.validarForca(novaSenha)) {
            return "A senha deve ter ao menos 8 caracteres com letras, números e um caractere especial.";
        }

        usuario.setSenha(SenhaUtil.criptografar(novaSenha));
        usuario.setPrimeiroLogin(false);
        usuario.setExpiraSenha(LocalDateTime.now().plusDays(90));
        usuarioDAO.atualizar(usuario);
        return null; // sem erro
    }

    // DTO interno para resultado do login
    public static class ResultadoLogin {
        private final boolean autenticado;
        private final boolean requerTrocaSenha;
        private final String mensagem;
        private final Usuario usuario;

        private ResultadoLogin(boolean autenticado, boolean requerTrocaSenha, String mensagem, Usuario usuario) {
            this.autenticado = autenticado;
            this.requerTrocaSenha = requerTrocaSenha;
            this.mensagem = mensagem;
            this.usuario = usuario;
        }

        static ResultadoLogin sucesso(Usuario u) {
            return new ResultadoLogin(true, false, null, u);
        }

        static ResultadoLogin trocaSenha(Usuario u, String msg) {
            return new ResultadoLogin(true, true, msg, u);
        }

        static ResultadoLogin falha(String msg) {
            return new ResultadoLogin(false, false, msg, null);
        }

        public boolean isAutenticado() { return autenticado; }
        public boolean isRequerTrocaSenha() { return requerTrocaSenha; }
        public String getMensagem() { return mensagem; }
        public Usuario getUsuario() { return usuario; }
    }
}
