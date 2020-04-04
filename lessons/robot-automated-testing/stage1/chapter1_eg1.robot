*** Settings ***
Library	JunosDevice.py

*** Test Cases ***
Check Hostname
	Connect Device	host=${HOST}	user=${USER}	password=${PASSWORD}
	${hostname}=	Get Hostname
	Should Be Equal As Strings	${hostname}	vqfx1
	Close Device

Check Model
	Connect Device	host=${HOST}	user=${USER}	password=${PASSWORD}
	${model}=	Get Model
	Should Be Equal As Strings	${model}	VQFX-10000
	Close Device
