<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Sistema de Medicamentos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<nav class="navbar">
    <span class="navbar-brand">
        <i class="fa-solid fa-pills" style="color:#90caf9;"></i> Sistema de Medicamentos
    </span>
    <button class="nav-toggle" aria-label="Menu">
        <i class="fa-solid fa-bars"></i>
    </button>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/dashboard" class="active">
            <i class="fa-solid fa-house"></i> Início
        </a>
        <a href="${pageContext.request.contextPath}/pacientes/lista">
            <i class="fa-solid fa-users"></i> Pacientes
        </a>
        <a href="${pageContext.request.contextPath}/medicamentos/lista">
            <i class="fa-solid fa-pills"></i> Medicamentos
        </a>
        <a href="${pageContext.request.contextPath}/trocar-senha">
            <i class="fa-solid fa-key"></i> Minha Senha
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fa-solid fa-right-from-bracket"></i> Sair
        </a>
    </div>
</nav>

<div class="container">

    <c:if test="${param.msg == 'senha_atualizada'}">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> Senha atualizada com sucesso!
        </div>
    </c:if>

    <div class="flex-between">
        <h2 class="page-title">
            <i class="fa-solid fa-gauge-high" style="color:#0077b6;"></i> Dashboard
        </h2>
        <span class="text-muted">
            <i class="fa-solid fa-user-tie" style="color:#7c3aed;"></i>
            Olá, <strong>${usuarioLogado.nome}</strong>
            <span class="badge badge-info">${usuarioLogado.tipo.descricao}</span>
        </span>
    </div>

    <div class="stats-grid">
        <div class="stat-card" style="border-top-color:#7c3aed;">
            <div style="display:flex; align-items:center; gap:.75rem;">
                <i class="fa-solid fa-pills fa-2x" style="color:#7c3aed; opacity:.85;"></i>
                <div>
                    <div class="stat-value" style="color:#7c3aed;">${totalMedicamentos}</div>
                    <div class="stat-label">Medicamentos cadastrados</div>
                </div>
            </div>
        </div>
        <div class="stat-card" style="border-top-color:#0ea5e9;">
            <div style="display:flex; align-items:center; gap:.75rem;">
                <i class="fa-solid fa-user-group fa-2x" style="color:#0ea5e9; opacity:.85;"></i>
                <div>
                    <div class="stat-value" style="color:#0ea5e9;">${totalPacientes}</div>
                    <div class="stat-label">Pacientes ativos</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="flex-between" style="margin-bottom:1rem;">
            <strong>
                <i class="fa-solid fa-shield-halved" style="color:#f59e0b;"></i>
                Últimas tentativas de login
            </strong>
            <span class="text-muted" style="font-size:.8rem;">
                <i class="fa-solid fa-file-shield"></i> Auditoria — RF02
            </span>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th><i class="fa-solid fa-calendar-clock"></i> Data/Hora</th>
                        <th><i class="fa-solid fa-id-card"></i> Identificador</th>
                        <th><i class="fa-solid fa-network-wired"></i> IP</th>
                        <th><i class="fa-solid fa-circle-info"></i> Resultado</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${ultimasTentativas}">
                        <tr>
                            <td>${t.momento}</td>
                            <td>${t.identificador}</td>
                            <td>${t.ip}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${t.sucesso}">
                                        <span class="badge badge-success">
                                            <i class="fa-solid fa-circle-check"></i> Sucesso
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">
                                            <i class="fa-solid fa-circle-xmark"></i> Falha
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty ultimasTentativas}">
                        <tr>
                            <td colspan="4" class="text-muted">
                                <i class="fa-solid fa-inbox"></i> Nenhum registro ainda.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card">
        <strong><i class="fa-solid fa-bolt" style="color:#f59e0b;"></i> Acesso rápido</strong>
        <div style="margin-top:1rem; display:flex; gap:.75rem; flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/medicamentos/lista" class="btn btn-primary">
                <i class="fa-solid fa-list"></i> Ver Medicamentos
            </a>
            <a href="${pageContext.request.contextPath}/medicamentos/novo" class="btn btn-success">
                <i class="fa-solid fa-plus"></i> Novo Medicamento
            </a>
        </div>
    </div>

</div>
<script>
document.querySelector(".nav-toggle").addEventListener("click", function () {
    document.querySelector(".navbar-links").classList.toggle("aberto");
});
document.addEventListener("click", function (e) {
    if (!e.target.closest(".navbar"))
        document.querySelector(".navbar-links")?.classList.remove("aberto");
});
</script>
</body>
</html>
