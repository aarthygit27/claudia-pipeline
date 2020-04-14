*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
*** Keywords ***
clickingOnSolutionValueEstimate
    [Arguments]    ${c}=${oppo_name}
    #log to console    ClickingOnSVE
    click element    xpath=//a[@title='Solution Value Estimate']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    40s


addProductsViaSVE
     [Arguments]    ${pname_sve}=${product_name}
     #log to console  ${pname_sve}.this is added via SVE
     select frame  xpath=//div[contains(@class,'slds')]/iframe
     #force click element  //div[@class='btn custom-button btn-primary pull-right']
     sleep  5s
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']    ${pname_sve}
     sleep  2s
     click element  //ul[contains(@class,"typeahead dropdown-menu")]
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@type='number']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@type='number']   ${product_quantity}
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.OneTimeTotalt']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.OneTimeTotalt']   ${NRC}
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.RecurringTotalt']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.RecurringTotalt']  ${RC}
     page should contain element  //th[contains(text(),"Annual Charge Unit")]
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.AnnualChargeUnit']
     input text  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.AnnualChargeUnit']  ${ARC}
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.SalesType']
     sleep  2s
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.SalesType']/option[@value='${sales_type_value}']
     sleep  5s
     click element  //input[@type="number"][@ng-model="p.ContractLength"]
     input text   //input[@type="number"][@ng-model="p.ContractLength"]   ${contract_lenght}
     #click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.ContractLength']/option[@value='${contract_lenght}']
     ${fyr_value}=      evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity} +${ARC}
     ${revenue_value}=  evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity} +${ARC}
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${fyr_value}.00'][1]
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${revenue_value}.00'][2]
     wait until page contains element  //button[contains(text(),"Save")]   60s
     click element  //button[contains(text(),"Save")]
     unselect frame
     sleep   30s
     [Return]   ${fyr_value}


Add multiple products in SVE
   [Arguments]     @{items}
    ${i} =    Set Variable    ${0}
    ${fyr_value_total}=   Set Variable   ${0}
    ${count_list}=  Get length  ${items}
    log to console  ${count_list}.number of items
    select frame   ${Page_iframe}
     :FOR    ${item}    IN    @{items}
     \    ${i} =    Set Variable    ${i + 1}
#     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][ ${i}]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']    ${item}
     \  Click element   css=.typeahead.dropdown-menu.ng-scope.am-fade.bottom-left li.ng-scope a.ng-binding
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@type='number']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@type='number']   ${product_quantity}
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.OneTimeTotalt']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.OneTimeTotalt']   ${NRC}
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.RecurringTotalt']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.RecurringTotalt']   ${RC}
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/select[@ng-model='p.SalesType']
     \  sleep  2s
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/select[@ng-model='p.SalesType']/option[@value='${sales_type_value${i}}']
     \  sleep  5s
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model="p.ContractLength"]
     \  Input text  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.ContractLength']  ${contract_lenght}
     \  ${fyr_value}=   evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     \  ${revenue_value}=  evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     \  page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${fyr_value}.00'][1]
     \  page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${revenue_value}.00'][2]
     \  Run keyword if   ${i}<${count_list}   click element   //div[text()='Add']
     \  ${fyr_value_total}=  evaluate  (${fyr_value_total}+${fyr_value})
     wait until page contains element  //button[normalize-space(.)='Save Changes']   60s
     force click element  //button[normalize-space(.)='Save Changes']
     sleep  30s
     unselect frame
     sleep  30s
    [Return]  ${fyr_value_total}
