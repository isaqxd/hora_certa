<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuários — Sistema de Medicamentos</title>
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
        <a href="${pageContext.request.contextPath}/dashboard">
            <i class="fa-solid fa-house"></i> Início
        </a>
        <a href="${pageContext.request.contextPath}/pacientes/lista" class="active">
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

    <c:if test="${param.msg == 'salvo'}">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> Cadastro salvo com sucesso!
        </div>
    </c:if>
    <c:if test="${param.msg == 'ativado'}">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> Conta ativada com sucesso.
        </div>
    </c:if>
    <c:if test="${param.msg == 'desativado'}">
        <div class="alert alert-warning">
            <i class="fa-solid fa-circle-pause"></i> Conta desativada.
        </div>
    </c:if>
    <c:if test="${not empty erro}">
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-xmark"></i> ${erro}
        </div>
    </c:if>

    <div class="flex-between">
        <h2 class="page-title">
            <i class="fa-solid fa-users" style="color:#0ea5e9;"></i> Pacientes e Usuários
        </h2>
        <a href="${pageContext.request.contextPath}/pacientes/novo" class="btn btn-success">
            <i class="fa-solid fa-user-plus"></i> Novo Cadastro
        </a>
    </div>

    <div class="card">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th><i class="fa-solid fa-hashtag"></i></th>
                        <th><i class="fa-solid fa-user"></i> Nome</th>
                        <th><i class="fa-solid fa-id-card"></i> CPF</th>
                        <th><i class="fa-solid fa-envelope"></i> E-mail</th>
                        <th><i class="fa-solid fa-tag"></i> Tipo</th>
                        <th><i class="fa-solid fa-phone-volume"></i> Contato Emerg.</th>
                        <th><i class="fa-solid fa-location-dot"></i> Cidade/UF</th>
                        <th><i class="fa-solid fa-circle-half-stroke"></i> Status</th>
                        <th><i class="fa-solid fa-sliders"></i> Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${usuarios}">
                        <tr>
                            <td>${u.id}</td>
                            <td><strong>${u.nome}</strong></td>
                            <td><code>${u.cpf}</code></td>
                            <td>${u.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.tipo.name() == 'PACIENTE'}">
                                        <span class="badge badge-info">
                                            <i class="fa-solid fa-bed-pulse"></i> ${u.tipo.descricao}
                                        </span>
                                    </c:when>
                                    <c:when test="${u.tipo.name() == 'ADMINISTRADOR'}">
                                        <span class="badge" style="background:#ede9fe;color:#7c3aed;">
                                            <i class="fa-solid fa-user-shield"></i> ${u.tipo.descricao}
                                        </span>
                                    </c:when>
                                    <c:when test="${u.tipo.name() == 'ENFERMEIRO'}">
                                        <span class="badge" style="background:#d1fae5;color:#065f46;">
                                            <i class="fa-solid fa-user-nurse"></i> ${u.tipo.descricao}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">
                                            <i class="fa-solid fa-user-clock"></i> ${u.tipo.descricao}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${not empty u.contatoEmergenciaNome}">
                                    <i class="fa-solid fa-phone" style="color:#16a34a;"></i>
                                    ${u.contatoEmergenciaNome}<br>
                                    <small class="text-muted">${u.contatoEmergenciaTel}</small>
                                </c:if>
                                <c:if test="${empty u.contatoEmergenciaNome}">
                                    <span class="text-muted">—</span>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty u.cidade}">
                                    <i class="fa-solid fa-city" style="color:#6b7280;"></i>
                                    ${u.cidade}<c:if test="${not empty u.estado}">/${u.estado}</c:if>
                                </c:if>
                                <c:if test="${empty u.cidade}"><span class="text-muted">—</span></c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.status.name() == 'ATIVO'}">
                                        <span class="badge badge-success">
                                            <i class="fa-solid fa-circle-check"></i> Ativo
                                        </span>
                                    </c:when>
                                    <c:when test="${u.status.name() == 'BLOQUEADO'}">
                                        <span class="badge badge-danger">
                                            <i class="fa-solid fa-ban"></i> Bloqueado
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">
                                            <i class="fa-solid fa-circle-pause"></i> Inativo
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="white-space:nowrap;">
                                <a href="${pageContext.request.contextPath}/pacientes/editar?id=${u.id}"
                                   class="btn btn-sm btn-primary">
                                    <i class="fa-solid fa-pen-to-square"></i> Editar
                                </a>
                                <c:choose>
                                    <c:when test="${u.status.name() == 'ATIVO'}">
                                        <a href="${pageContext.request.contextPath}/pacientes/desativar?id=${u.id}"
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('Desativar ${u.nome}?')">
                                            <i class="fa-solid fa-circle-pause"></i> Desativar
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/pacientes/ativar?id=${u.id}"
                                           class="btn btn-sm btn-success">
                                            <i class="fa-solid fa-circle-play"></i> Ativar
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty usuarios}">
                        <tr>
                            <td colspan="9" class="text-muted" style="text-align:center; padding:2rem;">
                                <i class="fa-solid fa-users-slash fa-2x"
                                   style="display:block; margin-bottom:.5rem; opacity:.4;"></i>
                                Nenhum usuário cadastrado.
                                <a href="${pageContext.request.contextPath}/pacientes/novo">Cadastrar agora</a>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
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
