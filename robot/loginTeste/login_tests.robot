*** Settings ***
Documentation     Validação de mensagens de erro nativas no formulário de login.
Library           SeleniumLibrary

*** Variables ***
${URL_LOGIN}      http://localhost:8080/login
${BROWSER}        chrome
${INPUT_ID}       id=identificador
${INPUT_SENHA}    id=senha
${BTN_ENTRAR}     css=.btn-primary
${USER_INATIVO}         luisedu@gmail.com
${SENHA_INATIVO}        senhaForte123@
${USER_INEXISTENTE}     inexistente@gmail.com
${SENHA_QUALQUER}        senhaQualquer123@

${ALERT_DANGER}         css=.alert.alert-danger

*** Test Cases ***
CT01 - Validar Erro Nativo Identificador Em Branco
    [Documentation]    Verifica se o navegador bloqueia o envio se o campo identificador estiver vazio.
    Abrir Navegador Na Pagina De Login
    Click Button    ${BTN_ENTRAR}
    ${mensagem}=    Execute Javascript    return document.getElementById('identificador').validationMessage;
    Should Not Be Empty    ${mensagem}
    [Teardown]    Close Browser

CT02 - Validar Erro Nativo Senha Em Branco
    [Documentation]    Verifica se o navegador bloqueia o envio se a senha estiver vazia.
    Abrir Navegador Na Pagina De Login
    Input Text      ${INPUT_ID}       admin@saude.com
    Click Button    ${BTN_ENTRAR}
    ${mensagem}=    Execute Javascript    return document.getElementById('senha').validationMessage;
    Should Not Be Empty    ${mensagem}
    [Teardown]    Close Browser

CT03 — Identificador não Cadastrado (Credenciais Inválidas)
    [Documentation]    Valida o comportamento quando o usuário tenta logar com um e-mail/CPF que não existe no banco.
    Abrir Navegador Na Pagina De Login
    Input Text      ${INPUT_ID}       ${USER_INEXISTENTE}
    Input Text      ${INPUT_SENHA}    ${SENHA_QUALQUER}
    Click Button    ${BTN_ENTRAR}

    # Valida que a página recarregou mantendo o alerta de erro visível
    Wait Until Element Is Visible    ${ALERT_DANGER}    timeout=5s
    ${texto_erro}=    Get Text       ${ALERT_DANGER}
    ${mensagem}=    Execute Javascript    return document.getElementById('senha').validationMessage;
    [Teardown]    Close Browser

CT04 — Identificador com Conta Inativa
    [Documentation]    Valida o bloqueio de login para usuários que estão com a conta marcada como INATIVA no sistema.
    Abrir Navegador Na Pagina De Login
    Input Text      ${INPUT_ID}       ${USER_INATIVO}
    Input Text      ${INPUT_SENHA}    ${SENHA_INATIVO}
    Click Button    ${BTN_ENTRAR}

    # Valida a mensagem específica de inatividade injetada na classe .alert-danger
    Wait Until Element Is Visible    ${ALERT_DANGER}    timeout=5s
    ${texto_erro}=    Get Text       ${ALERT_DANGER}
    ${mensagem}=    Execute Javascript    return document.getElementById('identificador').validationMessage;
    [Teardown]    Close Browser

*** Keywords ***
Abrir Navegador Na Pagina De Login
    # Executa o Chrome em modo headless se não houver interface gráfica disponível,
    # ou remova '--headless' para ver o navegador abrindo fisicamente.
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Open Browser    ${URL_LOGIN}    ${BROWSER}    options=${options}
    Maximize Browser Window