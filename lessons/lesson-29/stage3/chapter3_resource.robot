*** Settings ***
Documentation  This is a resource file
Library	 JunosDevice.py

*** Variables ***
${host}=    172.16.158.31
${user}=    root
${password}=    juniper1
${hostname}=    vsrx-robot
${model}=   VSRX

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
