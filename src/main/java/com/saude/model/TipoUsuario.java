package com.saude.model;

public enum TipoUsuario {
    PACIENTE("Paciente"),
    CUIDADOR("Cuidador"),
    ENFERMEIRO("Enfermeiro"),
    ADMINISTRADOR("Administrador");

    private final String descricao;

    TipoUsuario(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}
