package com.saude.service;

import com.saude.dao.UsuarioDAO;
import com.saude.model.StatusConta;
import com.saude.model.TipoUsuario;
import com.saude.model.Usuario;
import com.saude.util.SenhaUtil;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class UsuarioService {

    private final UsuarioDAO dao = new UsuarioDAO();

    public String salvar(Usuario u, String senha, String confirmacao) throws SQLException {
        if (u.getNome() == null || u.getNome().isBlank())
            return "O nome é obrigatório.";
        if (u.getCpf() == null || u.getCpf().isBlank())
            return "O CPF é obrigatório.";
        if (u.getEmail() == null || u.getEmail().isBlank())
            return "O e-mail é obrigatório.";
        if (u.getTipo() == null)
            return "O tipo de usuário é obrigatório.";

        if (dao.emailOuCpfJaExiste(u.getEmail(), u.getCpf(), u.getId()))
            return "CPF ou e-mail já cadastrado no sistema.";

        // Novo cadastro exige senha
        if (u.getId() == null) {
            if (senha == null || senha.isBlank())
                return "A senha é obrigatória.";
            if (!senha.equals(confirmacao))
                return "A senha e a confirmação não coincidem.";
            if (!SenhaUtil.validarForca(senha))
                return "A senha deve ter ao menos 8 caracteres com letras, números e um caractere especial.";
            u.setSenha(SenhaUtil.criptografar(senha));
            u.setPrimeiroLogin(true);
            u.setExpiraSenha(LocalDateTime.now().plusDays(90));
            dao.salvar(u);
        } else {
            // Edição: só troca a senha se o campo foi preenchido
            if (senha != null && !senha.isBlank()) {
                if (!senha.equals(confirmacao))
                    return "A nova senha e a confirmação não coincidem.";
                if (!SenhaUtil.validarForca(senha))
                    return "A senha deve ter ao menos 8 caracteres com letras, números e um caractere especial.";
                u.setSenha(SenhaUtil.criptografar(senha));
            } else {
                // Mantém a senha atual do banco
                Usuario atual = dao.buscarPorId(u.getId());
                if (atual == null) return "Usuário não encontrado.";
                u.setSenha(atual.getSenha());
                u.setPrimeiroLogin(atual.isPrimeiroLogin());
                u.setExpiraSenha(atual.getExpiraSenha());
            }
            dao.atualizar(u);
        }
        return null;
    }

    public Usuario buscarPorId(Long id) throws SQLException {
        return dao.buscarPorId(id);
    }

    public List<Usuario> listarTodos() throws SQLException {
        return dao.listarTodos();
    }

    public List<Usuario> listarPacientes() throws SQLException {
        return dao.listarPacientes();
    }

    public void alterarStatus(Long id, StatusConta novoStatus) throws SQLException {
        Usuario u = dao.buscarPorId(id);
        if (u != null) {
            u.setStatus(novoStatus);
            dao.atualizar(u);
        }
    }

    public Usuario fromParams(String id, String nome, String email, String cpf,
                               String tipo, String status,
                               String cEmNome, String cEmTel,
                               String logradouro, String numero, String bairro,
                               String cidade, String estado, String cep,
                               String infoSaude) {
        Usuario u = new Usuario();
        if (id != null && !id.isBlank()) u.setId(Long.parseLong(id));
        u.setNome(nome);
        u.setEmail(email);
        u.setCpf(cpf);
        u.setTipo(TipoUsuario.valueOf(tipo));
        u.setStatus(status != null ? StatusConta.valueOf(status) : StatusConta.ATIVO);
        u.setContatoEmergenciaNome(cEmNome);
        u.setContatoEmergenciaTel(cEmTel);
        u.setLogradouro(logradouro);
        u.setNumero(numero);
        u.setBairro(bairro);
        u.setCidade(cidade);
        u.setEstado(estado);
        u.setCep(cep);
        u.setInfoSaude(infoSaude);
        return u;
    }
}
