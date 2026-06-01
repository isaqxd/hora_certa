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

CT01 - BVA: Nome com 2 caracteres - defeito identificado
    [Documentation]    Sistema aceita nome com 2 chars (abaixo do mínimo) - defeito
    Go To    ${URL_BASE}/pacientes/novo
    Wait Until Page Contains    Cadastro    timeout=5s
    Input Text    id=nome    Ab
    Input Text    id=email    ct01geanne@saude.com
    Input Text    id=cpf    44433322211
    Input Text    id=contatoEmergenciaTel    99111-0001
    Input Text    id=senha    Teste@123
    Input Text    id=confirmacao    Teste@123
    Click Button    xpath=//button[@type='submit']
    Sleep    3s
    Page Should Contain    Pacientes
    Log    CT01: sistema não rejeitou nome com 2 chars — defeito confirmado

CT02 - BVA: Nome com 3 caracteres deve ser aceito
    [Documentation]    Verifica que nome no limite mínimo (3 chars) é aceito
    Go To    ${URL_BASE}/pacientes/novo
    Wait Until Page Contains    Cadastro    timeout=5s
    Input Text    id=nome    Bia
    Input Text    id=email    ct02geanne@saude.com
    Input Text    id=cpf    55544433322
    Input Text    id=contatoEmergenciaTel    99111-0002
    Input Text    id=senha    Teste@123
    Input Text    id=confirmacao    Teste@123
    Click Button    xpath=//button[@type='submit']
    Sleep    3s
    Page Should Contain    Pacientes
    Log    CT02 passou: nome com 3 chars foi aceito

*** Keywords ***
Abrir Navegador E Fazer Login
    Open Browser    ${URL_BASE}/login    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id=identificador    timeout=5s
    Input Text    id=identificador    ${LOGIN}
    Input Text    id=senha    ${SENHA}
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains Element    xpath=//a[contains(@href,'/pacientes')]    timeout=5s