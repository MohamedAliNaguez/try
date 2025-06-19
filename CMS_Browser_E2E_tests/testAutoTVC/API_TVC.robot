*** Settings ***
Library    OperatingSystem
Library    RequestsLibrary
Library    Collections
Library    DateTime
Library    BuiltIn
Library    String
Library    JSONLibrary

*** Variables ***
# Suite Configuration
${SUITE_NAME}               API_TVC

# API Configuration
${API_URL_CREATE_INSTALLER}          https://api.acdevftp.com/api/V1/createInstaller
${API_URL_GET_INSTALLER}             https://api.acdevftp.com/api/V1/getInstallers
${API_URL_GET_INSTALLER_INFO}        https://api.acdevftp.com/api/V1/getInstallerInfo
${API_URL_CREATE_CLOUD_DRIVE}        https://api.acdevftp.com/api/V1/createCloudDrive
${API_URL_UPDATE_CLOUD_DRIVE}        https://api.acdevftp.com/api/V1/updateCloudDrive
${API_URL_GET_CLOUD_DRIVE}           https://api.acdevftp.com/api/V1/getCloudDrive
${API_URL_CREATE_AI}                 https://api.acdevftp.com/api/V1/createAI
${API_URL_UPDATE_AI}                 https://api.acdevftp.com/api/V1/updateAI
${API_URL_GET_AI}                    https://api.acdevftp.com/api/V1/getAI
${API_URL_GET_DEVICE_LIST}           https://api.acdevftp.com/api/V1/getDeviceList
${API_URL_GET_URL_CONNECT_AS_INSTALLER}     https://api.acdevftp.com/api/V1/GetUrlConnectAsInstaller
${API_URL_LOGIN}                     https://api.acdevftp.com/api/auth/login
${API_URL_CREATE_DEVICE}            https://api.acdevftp.com/api/device
# Params
${API_KEY}                      F7B33EE2$18FF}1EA7?926Bm8542B7748559pAo2 
${API_KEY_INSTALLER}            g^M2pTbn@oTiUb5qEI0eR7roeJx@OZGylSFpxaDc             
${EMAIL}                        chayma.frigu61@acoba.com  
${NAME}                         chayma
${INSTALLER_ID}                 AB0374F9-5BB9-4505-A276-2247132269E7
${DEVICE_ID}                    
${CUSTOMER_ID}                  B428C830-83A3-1614-918E-75788BBAFA06
${DRIVE_TYPE}                   AC_ST_100
${START_DATE}                   2024-10-01
${END_DATE}                     2025-10-01
${END_DATE_UPDATE}              2025-10-01
${INTERVAL}                     month 
${INTERVAL_UPDATE}              year 
${CURRENCY}                     EUR                  
${AI_COUNT}                     1      
${DRIVE_ACTION}                 UPGRADE    
${AI_ACTION}                    UPGRADE
${PRICE}                        10
${AI_ID}                        
${DRIVE_ID}
${EMAIL_LOGIN}            montassar.jeddou@acoba.com
${PASSWORD_LOGIN}         Acoba1234?
${BEARER_TOKEN}           NONE

*** Test Cases ***
Initialize CSV Results File
    [Documentation]    Create CSV file with headers if it doesn't exist
    Setup CSV File

# Create Installer
#     [Documentation]    Create New Installer
#     ${payload}=    Create Dictionary    
#     ...    apiKey=${API_KEY}
#     ...    email=${EMAIL}
#     ...    name=${NAME}
#     ...    status=1
#     ${status}    ${body}=    Send Post Request    ${API_URL_CREATE_INSTALLER}    ${payload}
#     ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
#     ${csv_message}=    Set Variable    Create New Installer
#     ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
#     Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_CREATE_INSTALLER}    ${payload}    ${result}    ${body}
#     Sleep    1

# Get List Of Installers
#     [Documentation]    Get List Of Installers
#     ${payload}=    Create Dictionary    
#     ...    apiKey=${API_KEY}
#     ${status}    ${body}=    Send Post Request    ${API_URL_GET_INSTALLER}    ${payload}
#     ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
#     ${csv_message}=    Set Variable    Get List Of Installers
#     ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
#     Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_GET_INSTALLER}    ${payload}    ${result}    ${body}
#     Sleep    1
    
# Get Installer Information
#     [Documentation]    Get Installer Info
#     ${payload}=    Create Dictionary    
#     ...    apiKey=${API_KEY_INSTALLER}
#     ...    id=${INSTALLER_ID}
#     ${status}    ${body}=    Send Post Request    ${API_URL_GET_INSTALLER_INFO}    ${payload}
#     ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
#     ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
#     Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_GET_INSTALLER_INFO}    ${payload}    ${result}    ${body}
#     Sleep    1

Login And Set Bearer Token
    [Documentation]    Login to retrieve Bearer Token and store it
    ${payload}=    Create Dictionary    
    ...    email=${EMAIL_LOGIN}
    ...    password=${PASSWORD_LOGIN}
    ${status}    ${body}=    Send Post Request    ${API_URL_LOGIN}    ${payload}
    ${body_dict}=    Evaluate    json.loads('''${body}''')    json
    IF    ${status} == 200 and "data" in ${body_dict}
        ${BEARER_TOKEN}=    Set Variable    ${body_dict["data"]}
        Set Suite Variable    ${BEARER_TOKEN}
        Log To Console    ✅ Token récupéré avec succès: ${BEARER_TOKEN}
    ELSE
        Fail    ❌ Login échoué ou token manquant - Réponse: ${body}
    END
Create Device With Token
    [Documentation]    Create a new device using Bearer token and set DEVICE_ID as suite variable
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${BEARER_TOKEN}
    ${payload}=    Create Dictionary
    ...    manufacturer=Dahua
    ...    device_type=NVR
    ...    channels=16
    ...    name=testtchayma
    ...    site_id=0EA66914-879C-FEF5-4BE5-7F7B0C9480DC

    ${status}    ${body}=    Send Post Request With Headers  ${API_URL_CREATE_DEVICE}    ${payload}    ${headers}
    ${body_dict}=    Evaluate    json.loads('''${body}''')    json

    ${has_data}=    Evaluate    'data' in ${body_dict}    modules=builtins
    ${has_device_id}=    Evaluate    ${has_data} and 'device_id' in ${body_dict["data"]}    modules=builtins

    Run Keyword If    ${status} == 200 and ${has_device_id}
    ...    Set Suite Variable    ${DEVICE_ID}    ${body_dict["data"]["device_id"]}
    ...    ELSE
    ...    Fail    ❌ Device creation failed or missing ID - Réponse: ${body}

    Log To Console    ✅ Device créé avec ID: ${DEVICE_ID}



Create Cloud Drive For Customer
    [Documentation]    Create Cloud Drive For Customer
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    customer_id=${CUSTOMER_ID}
    ...    drive_type=${DRIVE_TYPE}
    ...    device_id=${DEVICE_ID}
    ...    start_date=${START_DATE}
    ...    end_date=${END_DATE}
    ...    price=${PRICE}
    ...    interval=${INTERVAL}
    ...    currency=${CURRENCY}

    ${status}    ${body}=    Send Post Request    ${API_URL_CREATE_CLOUD_DRIVE}    ${payload}

    # Convertir la réponse JSON
    ${body_dict}=    Evaluate    json.loads('''${body}''')    json
    IF    ${status} == 200
        
        IF    "data" in ${body_dict} and "id" in ${body_dict["data"]}
            ${DRIVE_ID}=    Set Variable    ${body_dict["data"]["id"]}
            Set Suite Variable    ${DRIVE_ID}
            ${result}=    Set Variable    PASSED
            Log To Console    Drive ID créé avec succès: ${DRIVE_ID}
        ELSE
            ${error_message}=    Set Variable    La réponse ne contient pas de données valides (data.id manquant)
            Log To Console    WARN: ${error_message}
            Log To Console    Réponse complète: ${body_dict}
        END
    ELSE
        ${error_message}=    Set Variable    Échec de la requête - Code: ${status}
        Log To Console    WARN: ${error_message}
    END

    ${datetime}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${csv_message}=    Set Variable    Create Cloud Drive For Customer

    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED

    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_CREATE_CLOUD_DRIVE}    ${payload}    ${result}    ${body}

    Sleep    1

Update Cloud Drive For Customer 
    [Documentation]    Update Cloud Drive For Customer
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    drive_id=${DRIVE_ID}
    ...    drive_type=${DRIVE_TYPE}
    ...    drive_action=${DRIVE_ACTION}
    ...    start_date=${START_DATE}
    ...    end_date=${END_DATE_UPDATE}
    ...    interval=${INTERVAL_UPDATE}
    ...    currency=${CURRENCY}
    ${status}    ${body}=    Send Post Request    ${API_URL_UPDATE_CLOUD_DRIVE}    ${payload}
    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
    ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${csv_message}=    Set Variable    Get List Of Installers
    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_UPDATE_CLOUD_DRIVE}    ${payload}    ${result}    ${body}
    Sleep    1

Get Cloud Drive Informations
    [Documentation]    Get Cloud Drive Informations
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    drive_id=${DRIVE_ID}  
    ${status}    ${body}=    Send Post Request    ${API_URL_GET_CLOUD_DRIVE}    ${payload}
    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
    ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${csv_message}=    Set Variable    Get List Of Installers
    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_GET_CLOUD_DRIVE}    ${payload}    ${result}    ${body}
    Sleep    1

Create AI Subscription 
    [Documentation]    Create AI Subscription
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    customer_id=${CUSTOMER_ID}
    ...    ai_count=${AI_COUNT}
    ...    start_date=${START_DATE}
    ...    end_date=${END_DATE}
    ...    interval=${INTERVAL}
    ...    price=${PRICE}
    ...    currency=${CURRENCY}
    ${status}    ${body}=    Send Post Request    ${API_URL_CREATE_AI}    ${payload}
    
    # Convertir la réponse JSON en dictionnaire Python
    ${body_dict}=    Evaluate    json.loads('''${body}''')    json
    IF    ${status} == 200
        
        IF    "data" in ${body_dict} and "id" in ${body_dict["data"]}
            ${AI_ID}=    Set Variable    ${body_dict["data"]["id"]}
            Set Suite Variable    ${AI_ID}
            ${result}=    Set Variable    PASSED
            Log To Console    Drive ID créé avec succès: ${AI_ID}
        ELSE
            ${error_message}=    Set Variable    La réponse ne contient pas de données valides (data.id manquant)
            Log To Console    WARN: ${error_message}
            Log To Console    Réponse complète: ${body_dict}
        END
    ELSE
        ${error_message}=    Set Variable    Échec de la requête - Code: ${status}
        Log To Console    WARN: ${error_message}
    END
    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
    ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${csv_message}=    Set Variable    Create AI Subscription
    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_CREATE_AI}    ${payload}    ${result}    ${body}
    Sleep    1

Update AI Subscription 
    [Documentation]    Update AI Subscription 
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    AI_id=${AI_ID}
    ...    ai_action=${AI_ACTION}
    ...    ai_count=${AI_COUNT}
    ...    start_date=${START_DATE}
    ...    end_date=${END_DATE_UPDATE}
    ...    interval=${INTERVAL_UPDATE}
    ${status}    ${body}=    Send Post Request    ${API_URL_UPDATE_AI}    ${payload}
    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
    ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${csv_message}=    Set Variable    Get List Of Installers
    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_UPDATE_AI}    ${payload}    ${result}    ${body}
    Sleep    1

Get Ai Subscription Informations
    [Documentation]    Get Ai Subscription Informations
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    AI_id=${AI_ID}
    ${status}    ${body}=    Send Post Request    ${API_URL_GET_AI}    ${payload}
    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
    ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${csv_message}=    Set Variable    Get List Of Installers
    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_GET_AI}    ${payload}    ${result}    ${body}
    Sleep    1

Get Device List
    [Documentation]    Get Device List
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    customer_id=${CUSTOMER_ID}
    ${status}    ${body}=    Send Post Request    ${API_URL_GET_DEVICE_LIST}    ${payload}
    ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${csv_message}=    Set Variable    Get List Of Installers
    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_GET_DEVICE_LIST}    ${payload}    ${result}    ${body}

    Sleep    1

Get Url Connect As Installer
    [Documentation]    Get Url Connect As Installer
    ${payload}=    Create Dictionary    
    ...    apiKey=${API_KEY_INSTALLER}
    ...    id=${INSTALLER_ID}
    ${status}    ${body}=    Send Post Request    ${API_URL_GET_URL_CONNECT_AS_INSTALLER}    ${payload}
    ${datetime}=  Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${result}=    Run Keyword If    ${status} == 200    Set Variable    PASSED    ELSE    Set Variable    FAILED
    Append To Csv File    ${CSV_FILE}    ${datetime}    ${API_URL_GET_URL_CONNECT_AS_INSTALLER}    ${payload}    ${result}    ${body}
    Sleep    1

*** Keywords ***
Setup CSV File
    ${now}=      Get Current Date    result_format=%Y%m%d_%H%M%S 
    ${file}=     Set Variable    camera_test_results_${now}.csv
    ${header}=   Create List    Date/Heure    Configuration    Valeur testée    Résultat    body
    ${header_str}=    Catenate    SEPARATOR=,    @{header}
    Create File       ${file}    ${header_str}\n
    Set Suite Variable    ${CSV_FILE}    ${file}
    Set Suite Variable    ${now}

Append To Csv File
    [Arguments]    ${file}    @{row}
    ${line}=    Catenate    SEPARATOR=\n    @{row}
    Append To File    ${file}    ${line}\n

Send Post Request
    [Arguments]    ${endpoint}    ${payload}
    Create Session    api_session    ${endpoint}    verify=True

    &{headers}=    Create Dictionary    Content-Type=application/json
    ${payload_json}=    Evaluate    json.dumps(${payload})    json

    Log To Console    \nSending POST request to ${endpoint}:\n${payload_json}

    ${response}=    Post Request    api_session    ${endpoint}    headers=${headers}    data=${payload_json}

   
    RETURN    ${response.status_code}    ${response.text}

Send Post Request With Headers
    [Arguments]    ${endpoint}    ${payload}    ${headers}
    Create Session    api_session    ${endpoint}    verify=True

    ${payload_json}=    Evaluate    json.dumps(${payload})    json

    Log To Console    \nSending POST request to ${endpoint}:\n${payload_json}
    Log To Console    \nUsing Headers: ${headers}

    ${response}=    Post Request    api_session    ${endpoint}    headers=${headers}    data=${payload_json}

    RETURN    ${response.status_code}    ${response.text}