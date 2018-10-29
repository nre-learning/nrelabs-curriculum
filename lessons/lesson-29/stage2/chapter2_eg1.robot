*** Settings ***
Library	JunosDevice.py

*** Test Cases ***
Check Hostname
	Connect Device	host=${HOST}	user=${USER}	password=${PASSWORD}
	${hostname}=	Get Hostname
	Should Be Equal As Strings	${hostname}	vsrx-robot
	Close Device

Check Model
	Connect Device	host=${HOST}	user=${USER}	password=${PASSWORD}
	${model}=	Get Model
	Should Be Equal As Strings	${model}	VSRX
	Close Device
