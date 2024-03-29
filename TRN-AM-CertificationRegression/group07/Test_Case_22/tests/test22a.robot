*** Settings ***
Documentation	Certification Regression TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. End Date CET_V1
	[Tags]	Functional	POST	current
	Expire CET   ${certificate_hierarchy_Id}

2. Post Date CET_V2.2
	[Tags]	Functional	POST	current
	Activate CET   ${certificate_hierarchy_IdV2.2}

2. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

3. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

4. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

5. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

6. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

7. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

9. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

10. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

11. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group07/Test_Case_01/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group07/Test_Case_01/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group07/Test_Case_01/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

12. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

13. Certificate creation
	[Tags]	Functional	certificate create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

14. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}  ${response}
    Link Product to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json

15. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    associate parties to certificate    Certificate/Associate_Parties_Owner_Applicant_Reference_RegressionCertificate.json

16. Certify certificate with Decisioning
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Add_DecisionsToCertificate_RegressionScheme.json    ${Certificate_Id}

17. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

18. End Date CET_V2.2
	[Tags]	Functional	POST	current
	Expire CET   ${certificate_hierarchy_IdV2.2}

19. Post Date CET_V1
	[Tags]	Functional	POST	current
	Activate CET   ${certificate_hierarchy_Id}

20. Modify Certificate
	[Tags]	Functional	certificate create	POST    current
    Modify Certificate    Certificate/Modify_RegressionSchemeCertificate.json   ${Certificate_Id}
    run keyword if  '${Certificate_Id}' == '${Certificate_Id_Modify}'     Fail

21. Certify certificate with Decisioning
    [Tags]	Functional	certificate	create	POST    current
    ${response}     run keyword and ignore error    Add Decisions to Certificate  Certificate/Add_DecisionsToCertificate_RegressionScheme_diffProjectNo.json    ${Certificate_Id_Modify}
    ${msg}  Get Error Message  ${response_api}
	run keyword if  "${msg}" != " Error: Required information is missing from the Parties tab. Please add mandatory role(s) - localRepresentative, productionSite. "  Fail	test1 Teardown
	log to console  ${msg}

22. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown
