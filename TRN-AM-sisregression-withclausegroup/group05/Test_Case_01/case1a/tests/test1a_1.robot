*** Settings ***
Documentation	SIS Regression TestSuite
Resource	../../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}


4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product1}

7. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_08_withproduct1.json	${asset_Id_Product1}

8. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

9. Get Sub-Requirement
	[Tags]	Functional	GET	current
    ${response}     Get Sub-Requirement     ${asset_Id_Product1}    ${assessmentId}     Group%201
    ${Impact_eval}   Get Impact Evaluation  ${response}    Test Case 8 - Add Test
    run keyword if  '${Impact_eval}' != 'False'   Fail	test1 Teardown
    ${Eval_comp}   Get Evaluation Complete  ${response}   Test Case 8 - Add Test
    run keyword if  '${Eval_comp}' != 'False'   Fail	test1 Teardown

10. Get Context
	[Tags]	Functional	GET	current
    ${response}     Get Context     ${asset_Id_Product1}    ${assessmentId}     Group%201   Test%20Case%208%20-%20Add%20Test
    ${Context_desc}   Get Context Description  ${response}  ${asset_Id_Product1}    ${assessmentParamId}
    run keyword if  '${Context_desc}' != 'Automation_Product1_context'   Fail	test1 Teardown
    ${Asset_linkages}   Get Asset Linkages  ${response}     ${asset_Id_Product1}    ${assessmentParamId}
    should be empty     ${Asset_linkages}
    ${Eval_clauses}   Get Evaluated Clauses  ${response}     ${assessmentParamId}
    run keyword if  '${Eval_clauses}' != 'False'   Fail	test1 Teardown
    ${Verdict_render}   Get Verdict Rendered  ${response}   ${assessmentParamId}
    run keyword if  '${Verdict_render}' != 'False'   Fail	test1 Teardown

