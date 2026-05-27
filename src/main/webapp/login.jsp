<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Sistema de Medicamentos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="login-wrap">
    <div class="login-card">
        <div class="login-logo">
            <div class="brand-icon">
                <i class="fa-solid fa-pills" style="color:#7c3aed; font-size:2.2rem;"></i>
            </div>
            <h1>Sistema de Medicamentos</h1>
            <p>Gerenciamento de Saúde para Idosos</p>
        </div>

        <c:if test="${not empty param.expirado}">
            <div class="alert alert-warning">
                <i class="fa-solid fa-clock"></i> Sua sessão expirou. Faça login novamente.
            </div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-xmark"></i> ${erro}
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login" autocomplete="off">
            <div class="form-group">
                <label for="identificador">
                    <i class="fa-solid fa-id-card" style="color:#0077b6;"></i> E-mail ou CPF
                </label>
                <input type="text" id="identificador" name="identificador"
                       class="form-control" placeholder="email@exemplo.com ou 000.000.000-00"
                       required autofocus value="${param.identificador}">
            </div>
            <div class="form-group">
                <label for="senha">
                    <i class="fa-solid fa-lock" style="color:#6b7280;"></i> Senha
                </label>
                <input type="password" id="senha" name="senha"
                       class="form-control" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block mt-2">
                <i class="fa-solid fa-right-to-bracket"></i> Entrar
            </button>
        </form>

        <p class="text-muted mt-2" style="text-align:center; font-size:.78rem;">
            Acesso padrão: <strong>admin@saude.com</strong> / <strong>Admin@456</strong>
        </p>
    </div>
</div>
</body>
</html>
