*** Settings ***
Library           SeleniumLibrary
Suite Teardown    Close All Browsers

###########################################################
          # First Run the Below Commands in Terminal #
#             pip show robotframework-seleniumlibrary
#             pip install robotframework

###########################################################
# YouTube Channel : https://www.youtube.com/@timepasspython
###########################################################


*** Variables ***
${EXTENSION_PATH}          urban.crx
${VPN_EXTENSION_URL}       chrome-extension://eppiocemhmnlbhjplcgkofciiegomcon/popup/index.html
${IP_CHECK_URL}            https://whatismyipaddress.com/
@{Top_location}    Germany	United Kingdom (UK)	United States (USA)	All Locations
@{All_location}    	Algeria    Argentina    Australia    Austria    Belarus    Belgium    Bolivia    Brazil    Bulgaria    Canada	Chile	China	Colombia	Costa Rica	Croatia	Cyprus	Czech Republic	Denmark	Ecuador	Egypt	Estonia	Finland	France	Georgia	Germany	Ghana	Greece	Guatemala	Honduras	Hong Kong	Hungary	Iceland	India	Indonesia	Iran	Ireland	Israel	Italy	Ivory Coast	Japan	Jordan	Kazakhstan	Kenya	Korea	Kuwait	Kyrgyzstan	Latvia	Lithuania	Luxembourg	Malaysia	Malta	Mexico	Mongolia	Morocco	Netherlands	New Zealand	Nicaragua	Nigeria	Norway	Pakistan	Panama	Paraguay	Peru	Philippines	Poland	Portugal	Puerto Rico	Romania	Russia	Saudi Arabia	Singapore	Slovakia	Slovenia	South Africa	Spain	Sri Lanka	Sweden	Switzerland	Taiwan	Thailand	Turkey	Ukraine	United Arab Emirates	United Kingdom (UK)	United States (USA)	Uruguay	Venezuela	Vietnam	


*** Test Cases ***
Open Multiple VPN Servers And Check IP
    [Documentation]    Open VPN servers and verify IP address for each.
    FOR    ${i}    IN    @{All_location}
        ${options}=    Create Chrome Options
        Call Method    ${options}    add_extension    ${EXTENSION_PATH}
        Call Method    ${options}    add_experimental_option    detach    ${True}       
        
        Open Browser    about:blank    chrome    options=${options}    
        Go To    ${VPN_EXTENSION_URL}
        Sleep    10s
        ${chwd}=    Get Window Handles
        ${length}=    Evaluate    len(${chwd})
        IF    ${length}>1
        Switch Window    ${chwd[0]}
        END               

        Wait Until Element Is Visible    //button[contains(normalize-space(.), 'I Agree')]    10s
        Click Element    //button[contains(normalize-space(.), 'I Agree')]
        Wait Until Element Is Visible    //input[@placeholder='search location']    10s
        Click Element    //input[@placeholder='search location']
        Scroll Element Into View    //li[contains(normalize-space(.), '${i}')]
        Wait Until Element Is Visible    //li[contains(normalize-space(.), '${i}')]    10s
        
        Click Element    //li[contains(normalize-space(.), '${i}')]
        ${count}=    Get Element Count    //div[@class='play-button play-button--play']
        IF    ${count}==1
            Click Element    //div[@class='play-button play-button--play']
        END
        Sleep    10s
        ${chwd}=    Get Window Handles
        Switch Window    ${chwd[1]}
        Go To    ${IP_CHECK_URL}
        Sleep    5s
        Close Window
    END

*** Keywords ***
Create Chrome Options
    [Documentation]    Sets up Chrome options with the required extensions and settings.
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    [Return]    ${options}

Create Webdriver Service
    [Arguments]    ${browser}    ${driver_path}
    [Documentation]    Sets up the Webdriver Service with the given driver path.
    ${service}=    Evaluate    sys.modules['selenium.webdriver'].${browser}.service.Service('${driver_path}')    sys, selenium.webdriver
    [Return]    ${service}


######################################################################################################################