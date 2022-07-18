*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1. Validate Master Asset Template
	[Tags]	Functional	Test	GET    current
    ${coll_attr}     Get Metadata Collection Attributes       Regression%20test%20Product%201
    compare lists  ${coll_attr}  ["Collection Name", "Project Number", "Order Number", "Quote Number"]
#    Compare lists   ${coll_attr}    ["Product Type", "Owner Reference (Party Site ID)", "Reference Number", "Family / Series", "Model Name", "Creation Date", "Collection Name", "Project Number", "Order Number", "Quote Number", "TP1 Attribute 1", "Shared Attribute 1", "TP1 Attribute 2", "Shared Attribute 2", "TP1 Attribute 3", "Shared Attribute 3", "TP1 Attribute 4", "TP1 Attribute 5", "TP1 Attribute 6", "TP1 Attribute 7", "TP1 Attribute 8", "TP1 Attribute 9", "TP1 Attribute 10", "TP1 Attribute 11", "TP1 Attribute 12", "TP1 Attribute 13", "TP1 Attribute 14", "TP1 Attribute 15", "TP1 Attribute 16", "TP1 Attribute 17", "TP1 Attribute 18", "TP1 Attribute 19", "TP1 Attribute 20", "TP1 Attribute 21", "TP1 Attribute 22", "TP1 Attribute 23", "TP1 Attribute 24", "TP1 Attribute 25", "TP1 Attribute 26", "TP1 Attribute 27", "TP1 Attribute 28", "TP1 Attribute 29", "TP1 Attribute 30", "TP1 Attribute 31", "TP1 Attribute 32", "TP1 Attribute 33", "TP1 Attribute 34", "TP1 Attribute 35", "TP1 Attribute 36", "TP1 Attribute 37", "TP1 Attribute 38", "TP1 Attribute 39", "TP1 Attribute 40", "TP1 Attribute 41", "TP1 Attribute 42", "TP1 Attribute 43", "TP1 Attribute 44", "TP1 Attribute 45", "TP1 Attribute 46", "TP1 Attribute 47", "TP1 Attribute 48", "TP1 Attribute 49", "TP1 Attribute 50", "TP1 Attribute 51", "TP1 Attribute 52", "TP1 Attribute 53", "TP1 Attribute 54", "TP1 Attribute 55", "TP1 Attribute 56", "TP1 Attribute 57", "TP1 Attribute 58", "TP1 Attribute 59", "TP1 Attribute 60", "TP1 Attribute 61", "TP1 Attribute 62", "TP1 Attribute 63", "TP1 Attribute 64", "TP1 Attribute 65", "TP1 Attribute 66", "TP1 Attribute 67", "TP1 Attribute 68", "TP1 Attribute 69", "Shared Attribute 4", "Shared Attribute 5", "Shared Attribute 6", "Shared Attribute 7", "Shared Attribute 8", "Shared Attribute 9", "Shared Attribute 10", "Shared Attribute 11", "Shared Attribute 12", "TP1 Attribute 70", "TP1 Attribute 71", "TP1 Attribute 72", "TP1 Attribute 73", "Model Nomenclature", "CCN"]
    ${shared_attr}     Get Metadata Shared Attributes       Regression%20test%20Product%201
#    Compare lists   ${shared_attr}   ["Product Type", "Owner Reference (Party Site ID)", "Reference Number", "Family / Series", "Model Name", "Creation Date", "Collection Name", "Project Number", "Order Number", "Quote Number", "TP1 Attribute 1", "Shared Attribute 1", "TP1 Attribute 2", "Shared Attribute 2", "TP1 Attribute 3", "Shared Attribute 3", "TP1 Attribute 4", "TP1 Attribute 5", "TP1 Attribute 6", "TP1 Attribute 7", "TP1 Attribute 8", "TP1 Attribute 9", "TP1 Attribute 10", "TP1 Attribute 11", "TP1 Attribute 12", "TP1 Attribute 13", "TP1 Attribute 14", "TP1 Attribute 15", "TP1 Attribute 16", "TP1 Attribute 17", "TP1 Attribute 18", "TP1 Attribute 19", "TP1 Attribute 20", "TP1 Attribute 21", "TP1 Attribute 22", "TP1 Attribute 23", "TP1 Attribute 24", "TP1 Attribute 25", "TP1 Attribute 26", "TP1 Attribute 27", "TP1 Attribute 28", "TP1 Attribute 29", "TP1 Attribute 30", "TP1 Attribute 31", "TP1 Attribute 32", "TP1 Attribute 33", "TP1 Attribute 34", "TP1 Attribute 35", "TP1 Attribute 36", "TP1 Attribute 37", "TP1 Attribute 38", "TP1 Attribute 39", "TP1 Attribute 40", "TP1 Attribute 41", "TP1 Attribute 42", "TP1 Attribute 43", "TP1 Attribute 44", "TP1 Attribute 45", "TP1 Attribute 46", "TP1 Attribute 47", "TP1 Attribute 48", "TP1 Attribute 49", "TP1 Attribute 50", "TP1 Attribute 51", "TP1 Attribute 52", "TP1 Attribute 53", "TP1 Attribute 54", "TP1 Attribute 55", "TP1 Attribute 56", "TP1 Attribute 57", "TP1 Attribute 58", "TP1 Attribute 59", "TP1 Attribute 60", "TP1 Attribute 61", "TP1 Attribute 62", "TP1 Attribute 63", "TP1 Attribute 64", "TP1 Attribute 65", "TP1 Attribute 66", "TP1 Attribute 67", "TP1 Attribute 68", "TP1 Attribute 69", "Shared Attribute 4", "Shared Attribute 5", "Shared Attribute 6", "Shared Attribute 7", "Shared Attribute 8", "Shared Attribute 9", "Shared Attribute 10", "Shared Attribute 11", "Shared Attribute 12", "TP1 Attribute 70", "TP1 Attribute 71", "TP1 Attribute 72", "TP1 Attribute 73", "Model Nomenclature", "CCN"]
     ${re_shared_attr}    extract_shared_attributes   ${shared_attr}
    compare lists   ${re_shared_attr}  ['Shared Attribute 1', 'Shared Attribute 2', 'Shared Attribute 3', 'Shared Attribute 4', 'Shared Attribute 5', 'Shared Attribute 6', 'Shared Attribute 7', 'Shared Attribute 8', 'Shared Attribute 9', 'Shared Attribute 10', 'Shared Attribute 11', 'Shared Attribute 12']



