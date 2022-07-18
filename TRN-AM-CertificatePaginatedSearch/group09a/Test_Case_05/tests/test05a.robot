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
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Certificate Creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

9. Link Product to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

10. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id}

11. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    run keyword and ignore error  Certify Certificate  Certificate/Certify_RegressionCertificatewithWDequaltoEmpty&EDequaltoTodaysDate.json

12. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Obsolete"	Fail	test1 Teardown

13. Modify Certificate
	[Tags]	Functional	certificate create	POST    current
    Modify Certificate    Certificate/Modify_RegressionSchemeCertificate.json   ${Certificate_Id}
    run keyword if  '${Certificate_Id}' == '${Certificate_Id_Modify}'     Fail

14. Get Certificate details from Certificate Table
	[Tags]	Functional	certificate create	POST    current
	Get CertificateId from Certificate Table     ${Cert_Owner_Ref_Modify}
    run keyword if  '${Certificate_Id}, ${Certificate_Id_Modify}' != '${Cert_Id}'     Fail
    Get Unique CertificateId from Certificate Table   ${Certificate_Id_Modify}
    Should Not be Empty     ${Unique_Certificate_Id}
    Get Certificate Version from Certificate Table   ${Certificate_Id_Modify}
    run keyword if  '${Certificate_Ver}' != '2.0'     Fail

15. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    Add Parties to Certificate    Certificate/Associate_Parties_RegressionCertificate.json     ${Certificate_Id_Modify}

16. Certify certificate with Decisioning
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Add_DecisionsToCertificate_RegressionScheme_diffProjectNo.json    ${Certificate_Id_Modify}

17. Modify Certificate
	[Tags]	Functional	certificate create	POST    current
    Modify Certificate for Version3    Certificate/Modify_RegressionSchemeCertificate_Revision2.json   ${Certificate_Id_Modify}
    run keyword if  '${Certificate_Id_Modify}' == '${Certificate_Id_Modify2}'     Fail

18. Get Certificate details from Certificate Table
	[Tags]	Functional	certificate create	POST    current
	Get CertificateId from Certificate Table     ${Cert_Owner_Ref_Modify2}
    run keyword if  '${Certificate_Id}, ${Certificate_Id_Modify}, ${Certificate_Id_Modify2}' != '${Cert_Id}'     Fail
    Get Unique CertificateId from Certificate Table   ${Certificate_Id_Modify2}
    Should Not be Empty     ${Unique_Certificate_Id}
    Get Certificate Version from Certificate Table   ${Certificate_Id_Modify2}
    run keyword if  '${Certificate_Ver}' != '3.0'     Fail

19. Search Certificate with searchText and "latestCompletedCertificate" field as "Y"
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${searchText_value}    ${certificate_name_1}-${current_time}
	set global variable  ${latestCompletedCertificate_value}    ${value_as_Y}
	Paginated Search for Certificate    Certificate_Search_with_searchText_latestCompletedCertificate.json
	Extract certificate search response   ${certificate_search}
	should be equal  ${certificate_total_count}     ${value_as_1}
	should be equal  ${certificate_offset}    ${EMPTY}
	should be equal  ${certificate_rows}   ${EMPTY}
	length should be  ${certificate_list}  ${value_as_1}
	should be empty  ${certificate_refiners}
	length should be  ${certificate_findkeys}  ${value_as_1}
#	should be equal  ${Asset_user}  ${user_1}

10a. Validate Certificate Details
    [Tags]	Functional	asset   Search	POST    current
	${certificate_list}  get_dictionary_from_list_of_dictionaries     ${certificate_list}     ${Cert_Owner_Ref}
    Extract values from certificate list  ${certificate_list}
    should be equal  ${is_privateLabel}  [${value_as_false}]
    Compare lists  [${certificate_status}, ${certificate_version}, ${revision_number}, ${certify}]   [["${status_Active}"], ["${value_as_2.0}"], ["${value_as_1}"], ["${value_as_Y}"]]
	compare lists  [${unique_certificateId}, ${CS_certificate_Id}, ${CS_certificate_hierarchyId}, ${CS_partySiteContainerId}]    [["${Certificate_Id}"], ["${Certificate_Id}"], ["${certificate_hierarchy_Id}"], ["${EMPTY}"]]
	compare lists  [${CS_certificate_type}, ${CS_certificate_name}, ${CS_Cerificate_owner_reference}, ${CS_issuing_body}, ${CS_mark}, ${CS_cert_ccn}]    [["${certificate_type_1}"], ["${certificate_name_1}-${current_time}"], ["${Cert_Owner_Ref}"], ["${issuing_body_1}"], ["${mark_1}"], ["${Scope_Code_1}"]]
	compare lists  [${CS_issueDate}, ${CS_revisionDate}, ${CS_withdrawalDate}, ${CS_expiryDate}]     [["${today_date} ${time_00}"], ["${EMPTY}"], ["${EMPTY}"], ["${EMPTY}"]]
	Extract values from parties list     ${parties}
    compare lists    ${partySiteNumber_list}    ["${BO_partysite_number_1}", "${PS_partysite_number_1}", "${AP_partysite_number_1}", "${LR_partysite_number_1}", "${OR_partysite_number_1}"]
    compare lists    ${accountNumber_list}   ["${BO_account_number_1}", "${PS_account_number_1}", "${AP_account_number_1}", "${LR_account_number_1}", "${OR_account_number_1}"]
    compare lists    ${relationshipType_list}    ["${party_brand_owner}", "${party_production_site}", "${party_applicant}", "${party_local_representative}", "${party_owner_reference}"]


10b. Validate findKeys searchText Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchText from findKeys dictionary  ${certificate_findkeys}
    should be equal  ${FK_searchText}  ${certificate_name_1}-${current_time}
#    Extract latestCompletedCertificate from findKeys dictionary   ${certificate_findkeys}
#    should be equal  ${FK_latestCompletedCertificate}  ${value_as_Y}