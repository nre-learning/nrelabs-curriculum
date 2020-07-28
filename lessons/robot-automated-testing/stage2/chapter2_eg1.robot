*** Settings ***
Library	JunosDevice.py


*** Keywords ***
Log Facts
	&{facts}=       Gather Device Info
	FOR  ${key}  IN  @{facts.keys()}
	Log  ${facts["${key}"]}
	END

Validate Facts
	&{facts}=	Gather Device Info
    Should Be Equal As Strings  ${facts["hostname"]}  vqfx1
    Should Be Equal As Strings  ${facts["model"]}  VQFX-10000

*** Test Cases ***
Log Device Facts
	Connect Device  host=${HOST}	user=${USER}	password=${PASSWORD}
	Log Facts
	Close Device

Verify Facts
	Connect Device  host=${HOST}	user=${USER}	password=${PASSWORD}
	Validate Facts
	Close Device
