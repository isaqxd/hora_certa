<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.saude.model.Usuario u = (com.saude.model.Usuario) session.getAttribute("usuarioLogado");
    boolean primeiroLogin = u != null && u.isPrimeiroLogin();
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trocar Senha — Sistema de Medicamentos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="login-wrap">
    <div class="login-card">
        <div class="login-logo">
            <div class="brand-icon">
                <i class="fa-solid fa-key" style="color:#f59e0b; font-size:2.2rem;"></i>
            </div>
            <h1>Trocar Senha</h1>
            <p>Crie uma senha segura para continuar</p>
        </div>

        <c:if test="${not empty avisoSenha}">
            <div class="alert alert-warning">
                <i class="fa-solid fa-triangle-exclamation"></i> ${avisoSenha}
            </div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-xmark"></i> ${erro}
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/trocar-senha" autocomplete="off">
            <c:if test="${not primeiroLogin}">
            <div class="form-group">
                <label for="senhaAtual">
                    <i class="fa-solid fa-lock" style="color:#6b7280;"></i> Senha Atual
                </label>
                <input type="password" id="senhaAtual" name="senhaAtual"
                       class="form-control" placeholder="••••••••" required>
            </div>
            </c:if>
            <div class="form-group">
                <label for="novaSenha">
                    <i class="fa-solid fa-lock-open" style="color:#16a34a;"></i> Nova Senha
                </label>
                <input type="password" id="novaSenha" name="novaSenha"
                       class="form-control" placeholder="Mín. 8 chars, letras, números e símbolo" required>
            </div>
            <div class="form-group">
                <label for="confirmacao">
                    <i class="fa-solid fa-shield-halved" style="color:#0077b6;"></i> Confirmar Nova Senha
                </label>
                <input type="password" id="confirmacao" name="confirmacao"
                       class="form-control" placeholder="Repita a nova senha" required>
            </div>

            <div class="alert alert-info mt-1" style="font-size:.78rem; padding:.6rem .875rem;">
                <i class="fa-solid fa-circle-info"></i>
                Requisitos: mínimo 8 caracteres com letras, números e ao menos um caractere especial (@, $, !, etc.)
            </div>

            <button type="submit" class="btn btn-primary btn-block mt-2">
                <i class="fa-solid fa-floppy-disk"></i> Salvar Nova Senha
            </button>
        </form>

        <c:if test="${not primeiroLogin}">
            <div style="text-align:center; margin-top:1rem;">
                <a href="${pageContext.request.contextPath}/dashboard" class="text-muted">
                    <i class="fa-solid fa-arrow-left"></i> Cancelar
                </a>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>
