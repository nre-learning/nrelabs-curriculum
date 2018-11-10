*** Settings ***
Library	substring.py

*** Variables ***
${str1}=	Robot
${str2}=	Robot

*** Test Cases ***
Check Equal1
	Should Be Equal As Strings	${str1}	Framework

Check Equal2
	Should Be Equal As Strings	${str1}	robot

Check Equal3
	Should Be Equal As Strings	${str1}	${str2}

CheckSubstring1
	is a substring	Jun	Juniper

CheckSubstring2
	is a substring	June	Juniper
