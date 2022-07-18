*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Search Asset with valid values
	[Tags]	Functional	asset   Search	POST    current
	${tomorrow_date}     tomorrow_date
	set global variable  ${tomorrow_date}   ${tomorrow_date}
	set global variable  ${fromModifiedDate_value}  ${today_date}
	set global variable  ${toModifiedDate_value}   ${tomorrow_date}
	Search Asset    Asset_Search_with_fromModifiedDate&toModifiedDate.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
	should not be empty  ${Asset_list}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be equal  ${Asset_user}  ${user_1}

2a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value   ${Asset_owner_reference}   ${Asset1_Owner_Ref}

2b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract fromModifiedDate and toModifiedDate from findKeys dictionary    ${Asset_findkeys}
    should be equal  ${FK_from&toModifiedDate}  [${today_date}, ${tomorrow_date}]