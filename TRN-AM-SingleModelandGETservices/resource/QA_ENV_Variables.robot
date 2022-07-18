*** Variables ***
#${API_ENDPOINT}	https://qa.informationplatform.ul.com	#For QA
#${API_ENDPOINT}	https://platform-np-api-qa.azurewebsites.net	#For QA
${API_ENDPOINT}	https://uliodev.azure-api.net/InformationPlatformServicesQA  #For QA OAuth2


#@{database}	pymysql	infopltfrm_transDBv05	ul_transUser	q2Rbd6Wgpg	usnbkinpt020q.global.ul.com 	3316	#DB for UAT
@{database}   pymysql    infopltfrm_transDBv07    RW_Automation    [RC]~yz#D.(6K=MV  ip-q-ss.mysql.database.azure.com    3306  	#DB for QA


${db}         @{database}[1]
${user}       @{database}[2]
${pass_wd}    @{database}[3]
${host}       @{database}[4]
${port}       @{database}[5]


${Api_ver}  5.29

${user_name}    ipqausr    #for QA
${password}     ipqausr@uL123&$#   #for QA
#OAuth 2
${AUTH_ENDPOINT}        https://login.microsoftonline.com/ul.onmicrosoft.com/oauth2/token
${Grant_Type}           client_credentials
${Client_ID}            6d236fcd-4939-4e1e-a12c-235ca8646fd6
${Client_Secret}        rIX8Q~KwB-0RlbGGdDUS1GstDkkejo6EZ_F~uc0U
${Scope}                User.Read

${certificate_hierarchy_Id}      3165b616-9e92-4db7-b976-aab81e49b133          #for QA
${certificate2_hierarchy_Id}     da6c7ba0-14e0-4348-a7e2-4dc8e563c40c          #for QA
#${certificate3_hierarchy_Id}                                                  #for QA
${certificate_metadataId}        9e97faeb-5e76-4955-9fbb-ac02c9549c0b          #for QA
${certificate2_metadataId}       c4eecc2f-2e8d-443e-baf7-dc02f2637ea5          #for QA
#${certificate3_metadataId}                                                    #for QA
${standard_hierarchy_Id}          8292d10a-f5bb-4461-abe3-1b51917149a7         #for QA - with clause group
${standard_hierarchy_Id}          b6be9207-cd54-4ed5-9fee-7e3b4e5a1f30         #for QA - no clause group
${Reg_prod1_metadataId}           8fedd68b-3d71-4b3f-b64e-ddf2e7716a13         #for QA
${Reg_prod2_metadataId}           115e876a-50d7-405f-967f-d194fbf97700         #for QA
${Reg_prod3_metadataId}           da456da5-daad-4eaa-be9e-b5090f1cae48         #for QA
${noEvalReqd_hierarchy_Id}     8292d10a-f5bb-4461-abe3-1b51917149a7            #for QA
${regression_product_1_hierarchy_id}    6f30fd07-66c9-45c2-8d65-27020ff12b97   #for QA
${regression_product_2_hierarchy_id}   fd881767-6bab-4b3a-9c7f-c95b83c6e031    #for QA
${regression_product_3_hierarchy_id}    4b61e8df-dbfc-4772-9db5-9790497d026f   #for QA
${certificate_hierarchy_IdV2.1}     df661a42-d53a-482c-af97-141dd8997ca5       #for QA
${certificate_metadataIdV2.1}       b79da7b0-bbcf-492e-a590-8a074c6d44c5       #for QA
${certificate_hierarchy_IdV2.2}     29115518-32c0-42ba-92bd-45214cfe9cbb       #for QA
${certificate_metadataIdV2.2}       d955e817-ae9f-44e1-94d0-4fb5526578e0       #for QA
${Validation_standard_Id}	        04b421ea-9bc9-11e9-a3db-005056ac416e       #for QA
${Validation_standardLabel_Id}	    ab0e091c-9bcb-11e9-a3db-005056ac416e       #for QA
${Validation_standardLabel2_Id}	    e8c9eed3-9bcb-11e9-a3db-005056ac416e       #for QA