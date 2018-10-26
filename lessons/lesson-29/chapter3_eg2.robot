*** Settings ***
Resource    chapter3_resource.robot
Test Setup  Setup Actions
Test Teardown   Teardown Actions

*** Test Cases ***
Verify Facts
	Validate Facts