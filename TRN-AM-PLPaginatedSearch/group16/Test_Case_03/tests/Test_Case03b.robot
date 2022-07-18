*** Settings ***
Documentation	PL Paginated Search TestSuite
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
    set global variable  ${product_collection_id}   ${collection_id}

4. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

8. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

9. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

10. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

11. Certificate creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

12. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}  ${response}
    Link Product to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json

13. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    Get HasAssets   Regression%20Scheme   ${Certificate_Name}
    Get HasEvaluations  Regression%20Scheme   ${Certificate_Name}
    associate parties to certificate    Certificate/Associate_Parties_RegressionCertificate.json

14. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Certify Certificate  Certificate/Certify_RegressionCertificate.json

15. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

16. Create Private Label1
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json

17. Add Asset To Private Label1
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  Add Asset To Private Label  Private_Label/Add_Asset_To_Private_Label.json   ${PrivateLabel_Id}
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

18. Create Private Label(PL2)
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label2    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate_Cert2.json

19. Add Asset To Private Label(PL2)
    [Tags]	Functional	certificate	PL  create	POST    current
    ${response}  Add Asset To Private Label  Private_Label/Add_Asset_To_Private_Label_With_Different_Taxonomy.json   ${PrivateLabel_Id2}
    set global variable  ${PrivateLabel_Asset_Id2}   ${response}

20. Add Parties To Private Labels
    [Tags]	Functional	certificate	PL  POST    current
    Add Parties To Private Label  Private_Label/Add_Parties_To_Private_Label.json    ${PrivateLabel_Id}
    Add Parties To Private Label  Private_Label/Add_Parties_To_Private_Label.json    ${PrivateLabel_Id2}

21. Certify Private Labels
    [Tags]	Functional	certificate	PL  POST    current
    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate.json
    Certify Private Label  Private_Label/Certify_PrivateLabel2Certificate.json

//////

21. Search Certificate with Offset 'Empty' & Rows:'1'
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${offset_value}  ${EMPTY}
	set global variable  ${rows_value}  ${value_as_1}
	set global variable  ${isPLCertificate_value}    ${value_as_Y}
	Paginated Search for PL Certificate    PL_Certificate_Search_with_offset&rows.json
	Extract certificate search response   ${certificate_search}
	should be equal  ${certificate_total_count}   ${value_as_2}
	should be equal  ${certificate_offset}    ${EMPTY}
	should be equal  ${certificate_rows}   ${value_as_1}
	length should be  ${certificate_list}  ${value_as_1}
	should be empty  ${certificate_refiners}
	length should be  ${certificate_findkeys}  ${value_as_2}

21a. Validate PL Certificate Details
    [Tags]	Functional	asset   Search	POST    current
	${certificate_list}  get_dictionary_from_list_of_dictionaries     ${certificate_list}     ${Cert_Owner_Ref}
    Extract values from certificate list  ${certificate_list}
    should be equal  ${is_privateLabel}  [${value_as_true}]
    Compare lists  [${certificate_status}, ${certificate_version}, ${revision_number}, ${certify}]   [["${status_Active}"], ["${value_as_1.0}"], ["${value_as_0}"], ["${value_as_Y}"]]
	compare lists  [${unique_certificateId}, ${CS_certificate_Id}, ${CS_certificate_hierarchyId}, ${CS_partySiteContainerId}]    [["${PrivateLabel_Id}"], ["${PrivateLabel_Id}"], ["${certificate_hierarchy_Id}"], ["${EMPTY}"]]
	compare lists  [${CS_certificate_type}, ${CS_certificate_name}, ${CS_Cerificate_owner_reference}, ${CS_issuing_body}, ${CS_mark}, ${CS_cert_ccn}]    [["${certificate_type_1}"], ["PL-${certificate_name_1}-${current_time}"], ["${Cert_Owner_Ref}"], ["${issuing_body_1}"], ["${mark_1}"], ["${Scope_Code_1}"]]
	compare lists  [${CS_issueDate}, ${CS_revisionDate}, ${CS_withdrawalDate}, ${CS_expiryDate}]     [["${today_date} ${time_00}"], ["${EMPTY}"], ["${EMPTY}"], ["${EMPTY}"]]
#    Extract values from parties list     ${parties}
#    compare lists    ${partySiteNumber_list}    ["${BO_partysite_number_1}", "${PS_partysite_number_1}", "${AP_partysite_number_1}", "${LR_partysite_number_1}", "${OR_partysite_number_1}"]
#    compare lists    ${accountNumber_list}   ["${BO_account_number_1}", "${PS_account_number_1}", "${AP_account_number_1}", "${LR_account_number_1}", "${OR_account_number_1}"]
#    compare lists    ${relationshipType_list}    ["${party_brand_owner}", "${party_production_site}", "${party_applicant}", "${party_local_representative}", "${party_owner_reference}"]

21b. Validate findKeys searchText Details
    [Tags]	Functional	asset   Search	POST    current
    Extract Certificate ownerReferenceList values from findKeys dictionary  ${certificate_findkeys}
    compare lists  ${FK_ownerReference_values}  ["${Cert_Owner_Ref}"]