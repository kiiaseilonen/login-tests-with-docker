*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${URL}    http://localhost:5000
${BROWSER}    headlessfirefox

*** Test Cases ***
Valid Login Test
    Open Browser  ${URL}  ${BROWSER}
    Input Text  id=username  ${USERNAME}
    Input Text  id=password  ${PASSWORD}
    Click Button  //button[@type='submit']
    Wait Until Page Contains Element    id=welcome-text
    Title Should Be  Welcome
    Close Browser

Invalid Login Test
    Open Browser  ${URL}  ${BROWSER}
    Input Text  id=username  ${INVALID_USERNAME}
    Input Text  id=password  ${INVALID_PASSWORD}
    Click Button  //button[@type='submit']
    Page Should Contain  Invalid username or password
    Close Browser
