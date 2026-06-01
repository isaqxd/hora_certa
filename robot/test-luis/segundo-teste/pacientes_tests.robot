*** Settings ***
Documentation     Suíte de testes de UI — Validação da Tabela de Decisão para Contatos de Emergência
Library           SeleniumLibrary

*** Variables ***
${URL_LOGIN}        http://localhost:8080/login
${URL_FORM}         http://localhost:8080/pacientes/novo
${BROWSER}          firefox

# Credenciais de acesso identificadas no ConexaoDB.java
${ADMIN_USER}       admin@saude.com
${ADMIN_PASS}       Admin@123

# Elementos da tela de Login
${INPUT_LOGIN_ID}   id=identificador
${INPUT_LOGIN_PW}   id=senha
${BTN_LOGIN}        css=button[type='submit']

# Elementos da tela Novo Paciente (form.jsp)
${INPUT_NOME}       id=nome
${INPUT_CPF}        id=cpf
${INPUT_EMAIL}      id=email
${SELECT_TIPO}      id=tipo
${INPUT_SENHA}      id=senha
${INPUT_CONF}       id=confirmacao
${INPUT_EMERG_NOM}  id=contatoEmergenciaNome
${INPUT_EMERG_TEL}  id=contatoEmergenciaTel
${BTN_SALVAR}       css=button[type='submit']

*** Test Cases ***
CT02 — Nome do Contato Vazio (Erro)
    [Documentation]    Mapeia a Regra 2: Telefone preenchido mas Nome vazio. Espera falha exibida no alert-danger.
    Realizar Autenticacao No Sistema
    Go To    ${URL_FORM}

    Input Text      ${INPUT_NOME}         Carlos Silva
    Input Text      ${INPUT_CPF}          111.111.111-11
    Input Text      ${INPUT_EMAIL}        carlos@email.com
    Select From List By Value    ${SELECT_TIPO}    PACIENTE
    Input Text      ${INPUT_SENHA}        Senha@123
    Input Text      ${INPUT_CONF}         Senha@123

    # Condição do Teste: Nome vazio, Telefone preenchido
    Input Text      ${INPUT_EMERG_NOM}    ${EMPTY}
    Input Text      ${INPUT_EMERG_TEL}    11999999999

    Click Button    ${BTN_SALVAR}

    # Deve permanecer no form.jsp e exibir o bloco de alerta de erro do backend
    Wait Until Element Is Visible    css=.alert-danger    timeout=5s
    Element Should Contain           css=.alert-danger    Erro ao salvar
    Sleep    2s
    [Teardown]    Close Browser
CT03 — Telefone do Contato Vazio (Erro)
    [Documentation]    Mapeia a Regra 3: Nome preenchido mas Telefone vazio. Espera falha exibida no alert-danger.
    Realizar Autenticacao No Sistema
    Go To    ${URL_FORM}

    Input Text      ${INPUT_NOME}         Carlos Almeida
    Input Text      ${INPUT_CPF}          111.256.111-11
    Input Text      ${INPUT_EMAIL}        carlosAlmeida@email.com
    Select From List By Value    ${SELECT_TIPO}    PACIENTE
    Input Text      ${INPUT_SENHA}        Senha@123
    Input Text      ${INPUT_CONF}         Senha@123

    # Condição do Teste: Nome preenchido, Telefone vazio
    Input Text      ${INPUT_EMERG_NOM}    Maria Silva
    Input Text      ${INPUT_EMERG_TEL}    ${EMPTY}

    Click Button    ${BTN_SALVAR}

    # Deve permanecer no form.jsp e exibir o bloco de alerta de erro do backend
    Wait Until Element Is Visible    css=.alert-danger    timeout=5s
    Element Should Contain           css=.alert-danger    Erro ao salvar
    Sleep    2s
    [Teardown]    Close Browser

CT04 — Ambos Vazios (Erro)
    [Documentation]    Mapeia a Regra 4: Ambos os campos de contato vazios. Espera falha exibida no alert-danger.
    Realizar Autenticacao No Sistema
    Go To    ${URL_FORM}

    Input Text      ${INPUT_NOME}         Carlos Silva
    Input Text      ${INPUT_CPF}          111.111.111-11
    Input Text      ${INPUT_EMAIL}        carlos@email.com
    Select From List By Value    ${SELECT_TIPO}    PACIENTE
    Input Text      ${INPUT_SENHA}        Senha@123
    Input Text      ${INPUT_CONF}         Senha@123

    # Condição do Teste: Ambos vazios
    Input Text      ${INPUT_EMERG_NOM}    ${EMPTY}
    Input Text      ${INPUT_EMERG_TEL}    ${EMPTY}

    Click Button    ${BTN_SALVAR}

    # Deve permanecer no form.jsp e exibir o bloco de alerta de erro do backend
    Wait Until Element Is Visible    css=.alert-danger    timeout=5s
    Element Should Contain           css=.alert-danger    Erro ao salvar
    Sleep    2s
    [Teardown]    Close Browser
CT01 — Ambos Preenchidos (Sucesso)
    [Documentation]    Mapeia a Regra 1: Nome e Telefone de emergência preenchidos. Espera sucesso e redirecionamento.
    Realizar Autenticacao No Sistema
    Go To    ${URL_FORM}

    # Preenche dados obrigatórios do Paciente
    Input Text      ${INPUT_NOME}         Carlos Almeida
    Input Text      ${INPUT_CPF}          111.256.111-11
    Input Text      ${INPUT_EMAIL}        carlosAlmeida@email.com
    Select From List By Value    ${SELECT_TIPO}    PACIENTE
    Input Text      ${INPUT_SENHA}        Senha@123
    Input Text      ${INPUT_CONF}         Senha@123

    # Condição do Teste: Ambos preenchidos
    Input Text      ${INPUT_EMERG_NOM}    Maria Silva
    Input Text      ${INPUT_EMERG_TEL}    11999999999

    Click Button    ${BTN_SALVAR}

    # Deve ir para a lista e exibir o alerta de sucesso injetado na URL/JSP
    Wait Until Page Contains    Cadastro salvo com sucesso!    timeout=5s
    Sleep    2s
    [Teardown]    Close Browser


*** Keywords ***
Realizar Autenticacao No Sistema
    Open Browser    ${URL_LOGIN}    ${BROWSER}
    Maximize Browser Window

    # Cooldown calibrado em inglês para evitar o ValueError anterior
    Set Selenium Speed    0.5 seconds

    Input Text      ${INPUT_LOGIN_ID}    ${ADMIN_USER}
    Input Text      ${INPUT_LOGIN_PW}    ${ADMIN_PASS}
    Click Button    ${BTN_LOGIN}

    # Valida que passamos pelo AuthFilter e entramos no sistema com sucesso
    Wait Until Page Contains    Dashboard    timeout=5s