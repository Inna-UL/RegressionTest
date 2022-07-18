*** Variables ***
#${API_ENDPOINT}	https://uat.informationplatform.ul.com	#For UAT Basic Auth
#${API_ENDPOINT}	https://platform-np-api-uat.azurewebsites.net	#For UAT Basic Auth
${API_ENDPOINT}	https://uliodev.azure-api.net/InformationPlatformServicesDEV  #For UAT OAuth2


#@{database}   pymysql    infopltfrm_transDBv07    RW_Automation    [RC]~yz#D.(6K=MV  ip-q-ss.mysql.database.azure.com    3306  	#DB for QA
@{database}   pymysql    infopltfrm_transDBv02    RW_Automation    [RC]~yz#D.(6K=MV  ip-u-ss.mysql.database.azure.com    3306  	#DB for UAT
#need to check with Sruthi the database parameters

${db}         @{database}[1]
${user}       @{database}[2]
${pass_wd}    @{database}[3]
${host}       @{database}[4]
${port}       @{database}[5]

${Api_ver}  5.30

#Basic Auth
${user_name}    ipuatusr    #for UAT
${password}     ipuatusr@uL123&$#   #for UAT
#OAuth 2
${AUTH_ENDPOINT}        https://login.microsoftonline.com/ul.onmicrosoft.com/oauth2/token
${Grant_Type}           client_credentials
${Client_ID}            6d236fcd-4939-4e1e-a12c-235ca8646fd6
${Client_Secret}        rIX8Q~KwB-0RlbGGdDUS1GstDkkejo6EZ_F~uc0U
${Scope}                User.Read


${certificate_hierarchy_Id}      f9545519-3205-426d-9086-416a94925e75          #for UAT -updated
${certificate2_hierarchy_Id}     73f7dbcb-1417-44c4-902f-4c2ffe7129bb          #for UAT -updated
#${certificate3_hierarchy_Id}                                                  #for UAT
${certificate_metadataId}        d03bac94-d0c1-400b-aa82-19000c8c43d3          #for UAT - updated
${certificate2_metadataId}       7fa4743e-6134-4d57-a287-256b0cf3be97          #for UAT  - updated
#${certificate3_metadataId}
${standard_hierarchy_Id}          ge28b891-a43e-4f59-9f15-2554f93359fe         #for UAT -updated- with clause group
${standard_hierarchy_Id}          b6be9207-cd54-4ed5-9fee-7e3b4e5a1f30         #for UAT - no clause group
${Reg_prod1_metadataId} 	      cbe97212-51fa-471d-be0d-9267de56f5d3         #for UAT updated
${Reg_prod2_metadataId} 	      9529e43d-b202-44f8-89da-9d1e1c265786         #for UAT updated
${Reg_prod3_metadataId} 	      47350fbb-0c48-4995-8581-2c42c92a2e47         #for UAT updated
${noEvalReqd_hierarchy_Id}        ge28b891-a43e-4f59-9f15-2554f93359fe         #for UAT updated
${regression_product_1_hierarchy_id}    cd2ada96-0201-436b-8238-3de7299be82e   #for UAT updated
${regression_product_2_hierarchy_id}    238b9baf-97bd-4197-aa1b-ade2a3b5d238   #for UAT updated
${regression_product_3_hierarchy_id}    6b58c770-424c-46bf-86b6-0f608bf58d20   #for UAT updated
${certificate_hierarchy_IdV2.1}     df661a42-d53a-482c-af97-141dd8997ca5       #for UAT
${certificate_metadataIdV2.1}       b79da7b0-bbcf-492e-a590-8a074c6d44c5       #for UAT
${certificate_hierarchy_IdV2.2}     29115518-32c0-42ba-92bd-45214cfe9cbb       #for UAT
${certificate_metadataIdV2.2}       d955e817-ae9f-44e1-94d0-4fb5526578e0       #for UAT
${Validation_standard_Id}	        04b421ea-9bc9-11e9-a3db-005056ac416e       #for UAT
${Validation_standardLabel_Id}	    ab0e091c-9bcb-11e9-a3db-005056ac416e       #for UAT
${Validation_standardLabel2_Id}	    e8c9eed3-9bcb-11e9-a3db-005056ac416e       #for UAT