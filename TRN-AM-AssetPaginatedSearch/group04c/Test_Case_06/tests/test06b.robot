*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    notcurrent
    create product1 asset	CreationOfRegressionProduct1.json

2. Check Asset State
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	notcurrent
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	notcurrent
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Check Asset State After Evaluation
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Search Asset with valid collectionName
	[Tags]	Functional	asset   Search	POST    notcurrent
	set global variable  ${searchParameter_key}  ${collectionName_key}
	set global variable  ${operator_value}  ${exact_search_value}
	set global variable  ${searchParameter_value}   ${collection_1}
	Search Asset    Asset_Search_with_collectionParameter.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    should not be empty  ${Asset_list}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be equal  ${Asset_user}  ${user_1}

8a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    notcurrent
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value   ${Asset_owner_reference}   ${Asset1_Owner_Ref}

8b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    notcurrent
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    should not be empty  ${FK_searchParameters_dict}
    Extract collectionName values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists   ${SP_collectionName_values}    ["${collection_1}", "${exact_search_value}"]