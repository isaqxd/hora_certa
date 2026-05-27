package com.saude.model;

import java.time.LocalDateTime;

public class Usuario {

    // ── Autenticação (RF02) ──────────────────────────────────────
    private Long id;
    private String nome;
    private String email;
    private String cpf;
    private String senha;
    private TipoUsuario tipo;
    private LocalDateTime dataCriacao;
    private LocalDateTime ultimoAcesso;
    private StatusConta status;
    private int tentativasLogin;
    private LocalDateTime bloqueioAte;
    private LocalDateTime expiraSenha;
    private boolean primeiroLogin;

    // ── Dados do paciente ────────────────────────────────────────
    private String contatoEmergenciaNome;
    private String contatoEmergenciaTel;
    private String logradouro;
    private String numero;
    private String bairro;
    private String cidade;
    private String estado;
    private String cep;
    private String infoSaude;

    public Usuario() {
        this.status = StatusConta.ATIVO;
        this.tentativasLogin = 0;
        this.primeiroLogin = true;
        this.dataCriacao = LocalDateTime.now();
        this.expiraSenha = LocalDateTime.now().plusDays(90);
    }

    // ── Getters/Setters autenticação ────────────────────────────
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public TipoUsuario getTipo() { return tipo; }
    public void setTipo(TipoUsuario tipo) { this.tipo = tipo; }

    public LocalDateTime getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(LocalDateTime dataCriacao) { this.dataCriacao = dataCriacao; }

    public LocalDateTime getUltimoAcesso() { return ultimoAcesso; }
    public void setUltimoAcesso(LocalDateTime ultimoAcesso) { this.ultimoAcesso = ultimoAcesso; }

    public StatusConta getStatus() { return status; }
    public void setStatus(StatusConta status) { this.status = status; }

    public int getTentativasLogin() { return tentativasLogin; }
    public void setTentativasLogin(int tentativasLogin) { this.tentativasLogin = tentativasLogin; }

    public LocalDateTime getBloqueioAte() { return bloqueioAte; }
    public void setBloqueioAte(LocalDateTime bloqueioAte) { this.bloqueioAte = bloqueioAte; }

    public LocalDateTime getExpiraSenha() { return expiraSenha; }
    public void setExpiraSenha(LocalDateTime expiraSenha) { this.expiraSenha = expiraSenha; }

    public boolean isPrimeiroLogin() { return primeiroLogin; }
    public void setPrimeiroLogin(boolean primeiroLogin) { this.primeiroLogin = primeiroLogin; }

    // ── Getters/Setters paciente ────────────────────────────────
    public String getContatoEmergenciaNome() { return contatoEmergenciaNome; }
    public void setContatoEmergenciaNome(String v) { this.contatoEmergenciaNome = v; }

    public String getContatoEmergenciaTel() { return contatoEmergenciaTel; }
    public void setContatoEmergenciaTel(String v) { this.contatoEmergenciaTel = v; }

    public String getLogradouro() { return logradouro; }
    public void setLogradouro(String logradouro) { this.logradouro = logradouro; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public String getBairro() { return bairro; }
    public void setBairro(String bairro) { this.bairro = bairro; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }

    public String getInfoSaude() { return infoSaude; }
    public void setInfoSaude(String infoSaude) { this.infoSaude = infoSaude; }

    // ── Helpers ────────────────────────────────────────────────
    public boolean isSenhExpirada() {
        return expiraSenha != null && LocalDateTime.now().isAfter(expiraSenha);
    }

    public boolean estaBloqueado() {
        if (status == StatusConta.BLOQUEADO) {
            return bloqueioAte == null || LocalDateTime.now().isBefore(bloqueioAte);
        }
        return false;
    }

    public String getEnderecoCompleto() {
        StringBuilder sb = new StringBuilder();
        if (logradouro != null && !logradouro.isBlank()) sb.append(logradouro);
        if (numero    != null && !numero.isBlank())    sb.append(", ").append(numero);
        if (bairro    != null && !bairro.isBlank())    sb.append(" — ").append(bairro);
        if (cidade    != null && !cidade.isBlank())    sb.append(", ").append(cidade);
        if (estado    != null && !estado.isBlank())    sb.append("/").append(estado);
        return sb.toString();
    }
}
