*** Settings ***
Documentation	Certificate Paginated Search TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

3. Get AssessmentId
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

4. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

5. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	should be equal  ${state}    ${asset_state_immutable}

6. Certificate creation
	[Tags]	Functional	certificate create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

7. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

8. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   ${certificate_type_1_url}   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   ${certificate_type_1_url}   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id}

9. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate_with_Dates.json     ${Certificate_Id}

10. Certificate2 creation with different Certificate Name
	[Tags]	Functional	certificate create	POST    current
    set test variable  ${certificate_name_1}   ${certificate_name_2}
    create certificate2   Certificate/CreationOfRegressionSchemeCertificate.json

11. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${cert_status}  Get certificate status
    should be equal  ${cert_status}  "${status_Active}"
    set test variable  ${Certificate_Id}    ${Certificate_Id2}
    ${cert_status}  Get certificate status
    should be equal  ${cert_status}  "${status_Under_Revision}"

12. Search Certificate with Offset as '1' & Rows as '2'
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${offset_value}  ${value_as_1}
	set global variable  ${rows_value}  ${value_as_2}
	Paginated Search for Certificate    Certificate_Search_with_offset&rows.json
	Extract certificate search response   ${certificate_search}
	should not be empty  ${certificate_total_count}
	should be equal  ${certificate_offset}    ${value_as_1}
	should be equal  ${certificate_rows}   ${value_as_2}
	length should be  ${certificate_list}  ${value_as_1}
	should be empty  ${certificate_refiners}
	length should be  ${certificate_findkeys}  ${value_as_1}
#	should be equal  ${Asset_user}  ${user_1}

12a. Validate Certificate Details
    [Tags]	Functional	asset   Search	POST    current
    Extract values from certificate list  ${certificate_list}
    should be equal  ${is_privateLabel}  [${value_as_false}]
	Compare lists  [${certificate_status}, ${certificate_version}, ${revision_number}, ${certify}]   [["${status_Under_Revision}"], ["${value_as_1.0}"], ["${value_as_0}"], ["${value_as_N}"]]
	compare lists  [${unique_certificateId}, ${CS_certificate_Id}, ${CS_certificate_hierarchyId}, ${CS_partySiteContainerId}]    [[ "${Certificate_Id2}"], ["${Certificate_Id2}"], [ "${certificate_hierarchy_Id}"], ["${EMPTY}"]]
	compare lists  [${CS_certificate_type}, ${CS_certificate_name}, ${CS_Cerificate_owner_reference}, ${CS_issuing_body}, ${CS_mark}, ${CS_cert_ccn}]    [["${certificate_type_1}"], ["${certificate_name_2}-${current_time}"], ["${Cert_Owner_Ref}"], ["${issuing_body_1}"], ["${mark_1}"], ["${Scope_Code_1}"]]
	compare lists  [${CS_issueDate}, ${CS_revisionDate}, ${CS_withdrawalDate}, ${CS_expiryDate}]     [["${EMPTY}"], ["${EMPTY}"], ["${EMPTY}"], ["${EMPTY}"]]
    should be equal  ${parties}  [[${EMPTY}]]

12b. Validate findKeys Lists Details
    [Tags]	Functional	asset   Search	POST    current
    Extract Certificate ownerReferenceList values from findKeys dictionary  ${certificate_findkeys}
    compare lists  ${FK_ownerReference_values}  ["${Cert_Owner_Ref}"]


