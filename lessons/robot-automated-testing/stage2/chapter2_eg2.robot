*** Settings ***
Resource    chapter2_resource.robot
Test Setup  Setup Actions
Test Teardown   Teardown Actions

*** Test Cases ***
Verify Facts
	Validate Facts
