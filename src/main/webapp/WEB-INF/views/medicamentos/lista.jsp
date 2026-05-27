<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medicamentos — Sistema de Medicamentos</title>
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
        <a href="${pageContext.request.contextPath}/pacientes/lista">
            <i class="fa-solid fa-users"></i> Pacientes
        </a>
        <a href="${pageContext.request.contextPath}/medicamentos/lista" class="active">
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
            <i class="fa-solid fa-circle-check"></i> Medicamento salvo com sucesso!
        </div>
    </c:if>
    <c:if test="${param.msg == 'excluido'}">
        <div class="alert alert-success">
            <i class="fa-solid fa-trash-can"></i> Medicamento excluído com sucesso!
        </div>
    </c:if>
    <c:if test="${not empty erro}">
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-xmark"></i> ${erro}
        </div>
    </c:if>

    <div class="flex-between">
        <h2 class="page-title">
            <i class="fa-solid fa-pills" style="color:#7c3aed;"></i> Medicamentos
        </h2>
        <a href="${pageContext.request.contextPath}/medicamentos/novo" class="btn btn-success">
            <i class="fa-solid fa-plus"></i> Novo Medicamento
        </a>
    </div>

    <div class="card">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th><i class="fa-solid fa-hashtag"></i></th>
                        <th><i class="fa-solid fa-capsules"></i> Nome</th>
                        <th><i class="fa-solid fa-flask"></i> Dosagem</th>
                        <th><i class="fa-solid fa-clock-rotate-left"></i> Frequência</th>
                        <th><i class="fa-solid fa-user-doctor"></i> Médico</th>
                        <th><i class="fa-solid fa-user"></i> Paciente</th>
                        <th><i class="fa-solid fa-calendar-day"></i> Início</th>
                        <th><i class="fa-solid fa-calendar-check"></i> Término</th>
                        <th><i class="fa-solid fa-circle-half-stroke"></i> Status</th>
                        <th><i class="fa-solid fa-sliders"></i> Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${medicamentos}">
                        <tr>
                            <td>${m.id}</td>
                            <td><strong>${m.nome}</strong></td>
                            <td>${m.dosagem}</td>
                            <td>${m.frequencia}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty m.medico}">
                                        <i class="fa-solid fa-user-doctor" style="color:#0ea5e9;"></i> ${m.medico}
                                    </c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <i class="fa-solid fa-user" style="color:#7c3aed;"></i> ${m.pacienteNome}
                            </td>
                            <td>${m.dataInicio}</td>
                            <td>${m.dataFim != null ? m.dataFim : '—'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${m.ativo}">
                                        <span class="badge badge-success">
                                            <i class="fa-solid fa-circle-check"></i> Ativo
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">
                                            <i class="fa-solid fa-circle-pause"></i> Inativo
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="white-space:nowrap;">
                                <a href="${pageContext.request.contextPath}/medicamentos/editar?id=${m.id}"
                                   class="btn btn-sm btn-primary">
                                    <i class="fa-solid fa-pen-to-square"></i> Editar
                                </a>
                                <a href="${pageContext.request.contextPath}/medicamentos/excluir?id=${m.id}"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Confirma a exclusão de ${m.nome}?')">
                                    <i class="fa-solid fa-trash"></i> Excluir
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty medicamentos}">
                        <tr>
                            <td colspan="10" class="text-muted" style="text-align:center; padding:2rem;">
                                <i class="fa-solid fa-inbox fa-2x"
                                   style="display:block; margin-bottom:.5rem; opacity:.4;"></i>
                                Nenhum medicamento cadastrado.
                                <a href="${pageContext.request.contextPath}/medicamentos/novo">Cadastrar agora</a>
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
