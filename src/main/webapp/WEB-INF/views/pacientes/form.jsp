<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${usuario != null ? 'Editar' : 'Novo'} Cadastro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .section-title {
            font-size:.8rem; font-weight:700; text-transform:uppercase;
            letter-spacing:.6px; color:#6b7280;
            border-bottom:2px solid #e5e7eb;
            padding-bottom:.4rem; margin:1.25rem 0 1rem;
            display:flex; align-items:center; gap:.4rem;
        }
        .section-title i { font-size:.9rem; }
    </style>
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
    <h2 class="page-title">
        <c:choose>
            <c:when test="${usuario != null}">
                <i class="fa-solid fa-user-pen" style="color:#0077b6;"></i> Editar Cadastro
            </c:when>
            <c:otherwise>
                <i class="fa-solid fa-user-plus" style="color:#16a34a;"></i> Novo Cadastro
            </c:otherwise>
        </c:choose>
    </h2>

    <c:if test="${not empty erro}">
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-xmark"></i> ${erro}
        </div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/pacientes">
            <c:if test="${usuario != null}">
                <input type="hidden" name="id" value="${usuario.id}">
            </c:if>

            <%-- ── Dados de identificação ── --%>
            <div class="section-title">
                <i class="fa-solid fa-id-card" style="color:#0077b6;"></i> Dados de Identificação
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="nome">
                        <i class="fa-solid fa-user" style="color:#0ea5e9;"></i>
                        Nome completo <span style="color:#dc2626;">*</span>
                    </label>
                    <input type="text" id="nome" name="nome" class="form-control"
                           value="${usuario.nome}" required placeholder="Nome completo do paciente">
                </div>
                <div class="form-group">
                    <label for="cpf">
                        <i class="fa-solid fa-id-card" style="color:#0ea5e9;"></i>
                        CPF <span style="color:#dc2626;">*</span>
                    </label>
                    <input type="text" id="cpf" name="cpf" class="form-control"
                           value="${usuario.cpf}" required placeholder="000.000.000-00"
                           maxlength="14">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">
                        <i class="fa-solid fa-envelope" style="color:#0ea5e9;"></i>
                        E-mail <span style="color:#dc2626;">*</span>
                    </label>
                    <input type="email" id="email" name="email" class="form-control"
                           value="${usuario.email}" required placeholder="email@exemplo.com">
                </div>
                <div class="form-group">
                    <label for="tipo">
                        <i class="fa-solid fa-tag" style="color:#7c3aed;"></i>
                        Tipo de Usuário <span style="color:#dc2626;">*</span>
                    </label>
                    <select id="tipo" name="tipo" class="form-control" required>
                        <option value="PACIENTE"     ${usuario == null || usuario.tipo.name() == 'PACIENTE'     ? 'selected':''}>Paciente</option>
                        <option value="CUIDADOR"     ${usuario != null && usuario.tipo.name() == 'CUIDADOR'     ? 'selected':''}>Cuidador</option>
                        <option value="ENFERMEIRO"   ${usuario != null && usuario.tipo.name() == 'ENFERMEIRO'   ? 'selected':''}>Enfermeiro</option>
                        <option value="ADMINISTRADOR"${usuario != null && usuario.tipo.name() == 'ADMINISTRADOR'? 'selected':''}>Administrador</option>
                    </select>
                </div>
            </div>

            <c:if test="${usuario != null}">
                <div class="form-group">
                    <label for="status">
                        <i class="fa-solid fa-circle-half-stroke" style="color:#6b7280;"></i> Status
                    </label>
                    <select id="status" name="status" class="form-control">
                        <option value="ATIVO"    ${usuario.status.name() == 'ATIVO'    ? 'selected':''}>Ativo</option>
                        <option value="INATIVO"  ${usuario.status.name() == 'INATIVO'  ? 'selected':''}>Inativo</option>
                        <option value="BLOQUEADO"${usuario.status.name() == 'BLOQUEADO'? 'selected':''}>Bloqueado</option>
                    </select>
                </div>
            </c:if>
            <c:if test="${usuario == null}">
                <input type="hidden" name="status" value="ATIVO">
            </c:if>

            <%-- ── Acesso ao sistema ── --%>
            <div class="section-title">
                <i class="fa-solid fa-lock" style="color:#f59e0b;"></i> Acesso ao Sistema
                <span class="text-muted" style="font-size:.75rem; font-weight:400; text-transform:none; letter-spacing:0;">
                    ${usuario != null ? '(deixe em branco para manter a senha atual)' : ''}
                </span>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="senha">
                        <i class="fa-solid fa-key" style="color:#f59e0b;"></i>
                        Senha ${usuario == null ? '<span style="color:#dc2626;">*</span>' : ''}
                    </label>
                    <input type="password" id="senha" name="senha" class="form-control"
                           placeholder="Mín. 8 chars, letras, números e símbolo"
                           ${usuario == null ? 'required' : ''}>
                </div>
                <div class="form-group">
                    <label for="confirmacao">
                        <i class="fa-solid fa-shield-halved" style="color:#0077b6;"></i>
                        Confirmar Senha ${usuario == null ? '<span style="color:#dc2626;">*</span>' : ''}
                    </label>
                    <input type="password" id="confirmacao" name="confirmacao" class="form-control"
                           placeholder="Repita a senha"
                           ${usuario == null ? 'required' : ''}>
                </div>
            </div>

            <%-- ── Contato de emergência ── --%>
            <div class="section-title">
                <i class="fa-solid fa-phone-volume" style="color:#dc2626;"></i> Contato de Emergência
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="contatoEmergenciaNome">
                        <i class="fa-solid fa-person" style="color:#0ea5e9;"></i> Nome do contato
                    </label>
                    <input type="text" id="contatoEmergenciaNome" name="contatoEmergenciaNome"
                           class="form-control" value="${usuario.contatoEmergenciaNome}"
                           placeholder="Nome do familiar ou responsável">
                </div>
                <div class="form-group">
                    <label for="contatoEmergenciaTel">
                        <i class="fa-solid fa-phone" style="color:#16a34a;"></i> Telefone do contato
                    </label>
                    <input type="text" id="contatoEmergenciaTel" name="contatoEmergenciaTel"
                           class="form-control" value="${usuario.contatoEmergenciaTel}"
                           placeholder="(00) 90000-0000">
                </div>
            </div>

            <%-- ── Endereço ── --%>
            <div class="section-title">
                <i class="fa-solid fa-location-dot" style="color:#f97316;"></i> Endereço
            </div>

            <div class="form-row">
                <div class="form-group" style="flex:2;">
                    <label for="logradouro">
                        <i class="fa-solid fa-road" style="color:#6b7280;"></i> Logradouro
                    </label>
                    <input type="text" id="logradouro" name="logradouro" class="form-control"
                           value="${usuario.logradouro}" placeholder="Rua, Av., Travessa...">
                </div>
                <div class="form-group" style="flex:.5;">
                    <label for="numero">
                        <i class="fa-solid fa-house-flag" style="color:#6b7280;"></i> Número
                    </label>
                    <input type="text" id="numero" name="numero" class="form-control"
                           value="${usuario.numero}" placeholder="123">
                </div>
                <div class="form-group">
                    <label for="cep">
                        <i class="fa-solid fa-mailbox" style="color:#6b7280;"></i> CEP
                    </label>
                    <input type="text" id="cep" name="cep" class="form-control"
                           value="${usuario.cep}" placeholder="00000-000" maxlength="9">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="bairro">
                        <i class="fa-solid fa-map-pin" style="color:#6b7280;"></i> Bairro
                    </label>
                    <input type="text" id="bairro" name="bairro" class="form-control"
                           value="${usuario.bairro}" placeholder="Bairro">
                </div>
                <div class="form-group">
                    <label for="cidade">
                        <i class="fa-solid fa-city" style="color:#6b7280;"></i> Cidade
                    </label>
                    <input type="text" id="cidade" name="cidade" class="form-control"
                           value="${usuario.cidade}" placeholder="Cidade">
                </div>
                <div class="form-group" style="flex:.5;">
                    <label for="estado">
                        <i class="fa-solid fa-map" style="color:#6b7280;"></i> UF
                    </label>
                    <select id="estado" name="estado" class="form-control">
                        <option value="">--</option>
                        <c:forEach var="uf" items="${'AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO'.split(',')}">
                            <option value="${uf}" ${usuario != null && usuario.estado == uf ? 'selected':''}>${uf}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <%-- ── Informações de saúde ── --%>
            <div class="section-title">
                <i class="fa-solid fa-heart-pulse" style="color:#dc2626;"></i>
                Informações de Saúde
                <span class="text-muted" style="font-size:.75rem; font-weight:400; text-transform:none; letter-spacing:0;">(opcional)</span>
            </div>

            <div class="form-group">
                <label for="infoSaude">
                    <i class="fa-solid fa-file-medical" style="color:#dc2626;"></i>
                    Histórico e condições de saúde relevantes
                </label>
                <textarea id="infoSaude" name="infoSaude" class="form-control" rows="4"
                          placeholder="Ex: hipertensão, diabetes tipo 2, alergias conhecidas, histórico cirúrgico...">${usuario.infoSaude}</textarea>
            </div>

            <div style="display:flex; gap:.75rem; margin-top:1.5rem;">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar Cadastro
                </button>
                <a href="${pageContext.request.contextPath}/pacientes/lista" class="btn btn-secondary">
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
