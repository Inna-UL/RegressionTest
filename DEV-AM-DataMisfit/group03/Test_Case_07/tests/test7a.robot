*** Settings ***
Documentation	Data Misfit TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. End Date Misfit Testing PET_V2
	[Tags]	Functional	POST	current
	Expire PET   ${data_misfit_testing_v2_hierarchy_Id}

2. Post Date Misfit Testing PET_V1
	[Tags]	Functional	POST	current
	Activate PET   ${data_misfit_testing_v1_hierarchy_Id}

3. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	group03/Test_Case_07/inputrequest/CreateProduct1.json

4. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

5. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

6. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

7. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

9. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

10. End Date Misfit Testing PET_V1
	[Tags]	Functional	POST	current
	Expire PET   ${data_misfit_testing_v1_hierarchy_Id}

11. Post Date Misfit Testing PET_V2
	[Tags]	Functional	POST	current
	Activate PET   ${data_misfit_testing_v2_hierarchy_Id}

12. View Asset Details
	[Tags]	Functional	POST	current
    Get Asset Details   ${asset_Id_Product1}

13. Modify Product1
	[Tags]	Functional	POST	current
    Modify Product1 Asset   group03/Test_Case_07/inputrequest/ModifyProduct1.json    ${asset_Id_Product1}
    ${card_change_freetxt1}     Get Asset Attribute Value with seq    ${response_api.json()}  cardinalityChange4_FreeText   1
	run keyword if  '${card_change_freetxt1}' != 'AxxRx ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel egestas lacus, et fermentum libero. Cras finibus velit lectus, a euismod nullamq'  Fail	test1 Teardown
	${card_change_freetxt2}     Get Asset Attribute Value with seq    ${response_api.json()}  cardinalityChange4_FreeText   2
	run keyword if  '${card_change_freetxt2}' != 'AxxRx ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel egestas lacus, et fermentum libero.'  Fail	test1 Teardown
	${card_change_freetxt3}     Get Asset Attribute Value with seq    ${response_api.json()}  cardinalityChange4_FreeText   3
	run keyword if  '${card_change_freetxt3}' != 'AxxRx ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel egestas lacus, et fermentum libero.'  Fail	test1 Teardown

#    set test variable	${card_change_freetxt1}	${response_api.json()["data"]["attributes"][38]["value"]}
#	run keyword if  '${card_change_freetxt1}' != 'AxxRx ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel egestas lacus, et fermentum libero. Cras finibus velit lectus, a euismod nullamq'  Fail	test1 Teardown
#    set test variable	${card_change_freetxt2}	${response_api.json()["data"]["attributes"][39]["value"]}
#	run keyword if  '${card_change_freetxt2}' != 'AxxRx ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel egestas lacus, et fermentum libero.'  Fail	test1 Teardown
#    set test variable	${card_change_freetxt3}	${response_api.json()["data"]["attributes"][40]["value"]}
#	run keyword if  '${card_change_freetxt3}' != 'AxxRx ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel egestas lacus, et fermentum libero.'  Fail	test1 Teardown