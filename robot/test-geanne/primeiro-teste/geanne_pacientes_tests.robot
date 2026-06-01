*** Settings ***
Library         SeleniumLibrary
Suite Setup     Abrir Navegador E Fazer Login
Suite Teardown  Close Browser

*** Variables ***
${URL_BASE}     http://localhost:8080
${BROWSER}      chrome
${LOGIN}        admin@saude.com
${SENHA}        Admin@123

*** Test Cases ***

CT01 - PE: Lista de pacientes deve carregar corretamente
    [Documentation]    Classe válida: tela de pacientes carrega com a tabela
    Go To    ${URL_BASE}/pacientes/lista
    Wait Until Page Contains    Pacientes e Usuários    timeout=5s
    Page Should Contain Element    xpath=//table
    Page Should Contain    Nome
    Page Should Contain    CPF
    Page Should Contain    E-mail
    Log    CT01 passou: lista de pacientes carregou corretamente

CT02 - PE: Botão de novo cadastro deve estar visível
    [Documentation]    Classe válida: botão de novo cadastro está presente e acessível
    Go To    ${URL_BASE}/pacientes/lista
    Wait Until Page Contains    Pacientes e Usuários    timeout=5s
    Page Should Contain Element    xpath=//a[contains(@href,'/pacientes/novo')]
    Log    CT02 passou: botão de novo cadastro está visível

*** Keywords ***
Abrir Navegador E Fazer Login
    Open Browser    ${URL_BASE}/login    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id=identificador    timeout=5s
    Input Text    id=identificador    ${LOGIN}
    Input Text    id=senha    ${SENHA}
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains Element    xpath=//a[contains(@href,'/pacientes')]    timeout=5s