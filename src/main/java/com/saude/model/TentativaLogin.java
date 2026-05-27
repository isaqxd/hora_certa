package com.saude.model;

import java.time.LocalDateTime;

public class TentativaLogin {

    private Long id;
    private String identificador;
    private LocalDateTime momento;
    private boolean sucesso;
    private String ip;

    public TentativaLogin() {
        this.momento = LocalDateTime.now();
    }

    public TentativaLogin(String identificador, boolean sucesso, String ip) {
        this.identificador = identificador;
        this.sucesso = sucesso;
        this.ip = ip;
        this.momento = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getIdentificador() { return identificador; }
    public void setIdentificador(String identificador) { this.identificador = identificador; }

    public LocalDateTime getMomento() { return momento; }
    public void setMomento(LocalDateTime momento) { this.momento = momento; }

    public boolean isSucesso() { return sucesso; }
    public void setSucesso(boolean sucesso) { this.sucesso = sucesso; }

    public String getIp() { return ip; }
    public void setIp(String ip) { this.ip = ip; }
}
