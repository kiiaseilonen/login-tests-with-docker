*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${URL}  http://host.docker.internal:5000
${BROWSER}    Firefox
${VALID_USERNAME}  ${USERNAME}
${VALID_PASSWORD}  ${PASSWORD}
${INVALID_USERNAME}  ${INVALID_USERNAME}
${INVALID_PASSWORD}  ${INVALID_PASSWORD}

*** Test Cases ***
Valid Login Test
    
    Open Browser  ${URL}  ${BROWSER}
    Input Text  id=username  ${VALID_USERNAME}
    Input Text  id=password  ${VALID_PASSWORD}
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
