*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Questions
	set global variable  ${role}    Public
	set global variable  ${user}    abcde
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    ConfigureRole_CertificateQuestions.json   Certificate
    should be equal  ${access_role}   Public

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}  Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Questions     ManojAutomation
    compare lists  ${att_role}   ['Public', 'Public', 'Public', 'Public']

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
    Disfigure Role Access    ConfigureRole_CertificateQuestions.json   Certificate
    should be equal  ${access_role}   Public