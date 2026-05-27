<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${medicamento != null ? 'Editar' : 'Novo'} Medicamento</title>
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
    <h2 class="page-title">
        <c:choose>
            <c:when test="${medicamento != null}">
                <i class="fa-solid fa-pen-to-square" style="color:#0077b6;"></i> Editar Medicamento
            </c:when>
            <c:otherwise>
                <i class="fa-solid fa-plus-circle" style="color:#16a34a;"></i> Novo Medicamento
            </c:otherwise>
        </c:choose>
    </h2>

    <c:if test="${not empty erro}">
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-xmark"></i> ${erro}
        </div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/medicamentos">
            <c:if test="${medicamento != null}">
                <input type="hidden" name="id" value="${medicamento.id}">
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label for="nome">
                        <i class="fa-solid fa-capsules" style="color:#7c3aed;"></i>
                        Nome do Medicamento <span style="color:#dc2626;">*</span>
                    </label>
                    <input type="text" id="nome" name="nome" class="form-control"
                           value="${medicamento.nome}" required placeholder="Ex: Losartana 50mg">
                </div>
                <div class="form-group">
                    <label for="dosagem">
                        <i class="fa-solid fa-flask" style="color:#f97316;"></i>
                        Dosagem <span style="color:#dc2626;">*</span>
                    </label>
                    <input type="text" id="dosagem" name="dosagem" class="form-control"
                           value="${medicamento.dosagem}" required placeholder="Ex: 50mg">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="frequencia">
                        <i class="fa-solid fa-clock-rotate-left" style="color:#0ea5e9;"></i>
                        Frequência <span style="color:#dc2626;">*</span>
                    </label>
                    <input type="text" id="frequencia" name="frequencia" class="form-control"
                           value="${medicamento.frequencia}" required placeholder="Ex: 1x ao dia">
                </div>
                <div class="form-group">
                    <label for="medico">
                        <i class="fa-solid fa-user-doctor" style="color:#0ea5e9;"></i>
                        Médico Responsável
                    </label>
                    <input type="text" id="medico" name="medico" class="form-control"
                           value="${medicamento.medico}" placeholder="Dr. Nome">
                </div>
            </div>

            <div class="form-group">
                <label for="pacienteId">
                    <i class="fa-solid fa-user" style="color:#7c3aed;"></i>
                    Paciente <span style="color:#dc2626;">*</span>
                </label>
                <select id="pacienteId" name="pacienteId" class="form-control" required>
                    <option value="">Selecione um paciente...</option>
                    <c:forEach var="p" items="${pacientes}">
                        <option value="${p.id}"
                            ${medicamento != null && medicamento.pacienteId == p.id ? 'selected' : ''}>
                            ${p.nome} — ${p.cpf}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="dataInicio">
                        <i class="fa-solid fa-calendar-day" style="color:#16a34a;"></i>
                        Data de Início <span style="color:#dc2626;">*</span>
                    </label>
                    <input type="date" id="dataInicio" name="dataInicio" class="form-control"
                           value="${medicamento.dataInicio}" required>
                </div>
                <div class="form-group">
                    <label for="dataFim">
                        <i class="fa-solid fa-calendar-check" style="color:#d97706;"></i>
                        Data de Término
                    </label>
                    <input type="date" id="dataFim" name="dataFim" class="form-control"
                           value="${medicamento.dataFim}">
                </div>
            </div>

            <div class="form-group">
                <label for="ativo">
                    <i class="fa-solid fa-circle-half-stroke" style="color:#6b7280;"></i> Status
                </label>
                <select id="ativo" name="ativo" class="form-control">
                    <option value="true"  ${medicamento == null || medicamento.ativo ? 'selected' : ''}>
                        Ativo
                    </option>
                    <option value="false" ${medicamento != null && !medicamento.ativo ? 'selected' : ''}>
                        Inativo
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label for="observacoes">
                    <i class="fa-solid fa-note-sticky" style="color:#f59e0b;"></i> Observações
                </label>
                <textarea id="observacoes" name="observacoes" class="form-control"
                          placeholder="Instruções especiais, contraindicações, etc.">${medicamento.observacoes}</textarea>
            </div>

            <div style="display:flex; gap:.75rem; margin-top:1rem;">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}/medicamentos/lista" class="btn btn-secondary">
                    <i class="fa-solid fa-xmark"></i> Cancelar
                </a>
            </div>
        </form>
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
