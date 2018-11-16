*** Settings ***
Documentation  This is a resource file
Library	 JunosDevice.py

*** Variables ***
${host}=    vqfx1
${user}=    root
${password}=    VR-netlab9
${hostname}=    vqfx1
${model}=   VQFX-10000

*** Keywords ***
Setup Actions
    Log     Setup Actions done here
    Connect Device  host=${host}	user=${user}	password=${password}

Teardown Actions
    Log    Teardown Actions done here
    Close Device

Validate Facts
	&{facts}=	Gather Device Info
    Should Be Equal As Strings  ${facts["hostname"]}  ${hostname}
    Should Be Equal As Strings  ${facts["model"]}  ${model}
