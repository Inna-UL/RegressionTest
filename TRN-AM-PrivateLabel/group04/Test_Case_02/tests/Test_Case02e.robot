*** Settings ***
Documentation	SIS Regression TestSuite
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

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    notcurrent
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check for Asset State
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	notcurrent
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

4. Validate above Asset's part of same collection
    [Tags]	Functional	GET    notcurrent
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	notcurrent
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

8. Requirement Assignment To Product
	[Tags]	Functional	POST	notcurrent
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

9. Get Assessment_ParamId
	[Tags]	Functional	GET	notcurrent
	Get Assesment_ParamID	${asset_Id_Product1}

10. Render Verdict
	[Tags]	Functional	POST	notcurrent
	${response1}	Render Verdict  group04/Test_Case_02/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group04/Test_Case_02/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group04/Test_Case_02/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

11. Complete Evaluation
	[Tags]	Functional	POST	notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

12. Certificate creation
	[Tags]	Functional	certificate	create	POST    notcurrent
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

13. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    notcurrent
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}  ${response}
    Link Product to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json

14. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    notcurrent
    Get HasAssets   Regression%20Scheme   ${Certificate_Name}
    Get HasEvaluations  Regression%20Scheme   ${Certificate_Name}
    associate parties to certificate    Certificate/Associate_Parties_RegressionCertificate.json

15. Certify certificate
    [Tags]	Functional	certificate	create	POST    notcurrent
    Certify Certificate  Certificate/Certify_RegressionCertificate.json

16. Validate Certificate Status
    [Tags]	Functional	certificate	create	notcurrent
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

17. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    notcurrent
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json

18. Search for the Private Label
    [Tags]	Functional	create  POST	notcurrent
    ${response}  run keyword and ignore error  Search private label   ownerReference=Incorrect
#    run keyword if  ${response_search_api} != {"apiversion":"${Api_ver}","code":204,"status":"No Content","message":"No Content","data":{}}    Fail	test1 Teardown
    run keyword if  ${response_search_api} != {"code":204,"status":"No Content","message":"No Content","data":{}}    Fail	test1 Teardown
    log to console  ${response_search_api}
