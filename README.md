# Test Automation
     
  Pack has different set of tests for Frontend, Integration, P&O.

## Contents

- [Installation](#installation)
- [Framework & Scripts](#framework-and-scripts)
- [Steps for new Development](#steps-for-new-development)
- [Running Scripts](#running-scripts)
- [Configuring test for different environment](#configuring-test-for-different-environment)
- [Standards & Guidelines](#standards--guidelines)
- [Related Links](#related-links)

## Installation

### Softwares & Frameworks
    - Install Python 3.7 from https://www.python.org/downloads/windows/
    - Add Python Application path and Scripts path to Environment Variables
    - Install Robot Frameework by using command - pip install robotframework
    - Install Selenium using command - pip install selenium==3.8.0
    - Install Selenium library using command -  pip install robotframework-seleniumlibrary (If you face any problem in running the tests install selenium2library using command - pip install robotframework-selenium2library==3.0.0)
    - Download Firefox ESR latest version
    - Download geckodriver 0.26 and place it to PATH.
    - Download Pycharm or RIDE IDE or any other which suits you
    - Download Git Bash from https://git-scm.com/downloads
    
### Project Repository Setup
    - Go to Project Repository in Bitbucket (https://git.verso.sonera.fi/projects/BBDIG/repos/claudia-pipeline/browse)
    - Click on the Clone action in the side bar and copy the http link. Example : https://git.verso.sonera.fi/scm/bbdig/claudia-pipeline.git
    - Open git bash and clone the repository using command - git clone https://git.verso.sonera.fi/scm/bbdig/claudia-pipeline.git
    - Navigate to repository using command - cd claudia-pipeline
    - The default branch that is cloned is master branch so specific branch must be selected (switch to merge branch) using command - git checkout merge
    - The test cases can be found in 'robot_tests' folders of the cloned repository 

## Framework and Scripts

### FrontEnd Automation
    - Path - robot_tests/frontendsanity
    - Here robot test cases are grouped w.r.t functionality in path - robot_tests/frontendsanity/tests
    - Below are the existing keywords and description.
    - Do not create new keywords file for any existing functionality.
    - For new test case development, try to use the existing keywords first. If no generic keyword is found, search for the relevant keyword and check if that can be used with minimal modification. If nothing works out, go ahead and create new keyword. 
    
| Keywords                    | Description                                                                                                                               |
|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| Account.robot               | Keywords related to Account Management and related functionalities                                                                        |
| Availability.robot          | Keywords related to Automatic and Manual availability                                                                                     |
| Cases&ApprovalRequest.robot | Keywords related to GTM request, Pricing request approval process, Investment case approval process, Pricing escalation approval process  |
| Common. robot               | All common keywords used across tests/keywords                                                                                            |
| Contact.robot               | Keywords related to Contacts and related functionality                                                                                    |
| Contract.robot              | Keywords related to Contract and related functionality                                                                                    |
| CPQ.robot                   | Keywords related to CPQ, Adding and validating products in the cart, Updating settings, salestype etc..                                   |
| LeadValidation.robot        | Keywords related to Lead functionality                                                                                                    |
| Login.robot                 | Keywords related to Login (different users) & Logout                                                                                      |
| Opportunity.robot           | Keywords related to creating Opportunity, update fields in Opportunity, validation, closing Oppo, Opportunity lists.                      |
| Order.Robot                 | Keywords related to creating Order, entering details in Post-create Order omniscript, submitting, validation                              |
| OtherSystem.robot           | Keywords related to validation of callout after Order submission.                                                                         |
| Quote.robot                 | Keywords related to creating Quote, credit score approval, Manual enqiry, send quote email.                                               |
| SalesConsole.robot          | Keywords related to Sales console functionality                                                                                           |
| SolutionValueEstimate.robot | Keywords related to adding products in SVE.                                                                                               |

## Steps for new development
    - Checkout merge branch and make sure that local merge branch is updated from remote. To ensure perform - git pull origin merge
    - Now create a new branch from merge using command - git checkout -b <newbranch> merge
    - Push the created branch to remote using command - git push origin <newbranch>
    - Do the development of the assigned task and commit the changes to your newbranch
    - Once all the changes are committed and pushed, validate once and then create a pull request from actions menu of BitBucket.
    - Select Source and Destination branch, assign it to respective person for review.
    - The reviewer will update comments in Bitbucket for any modification needed.
    - Once Pull request is merged successfully update your local branches from repository. 

## Running Scripts
### Multiple tests using tag
    - Run all tests with the http://run.py script. The http://run.py handles adding all correct directories to the PYTHONPATH.
    - Example: python http://run.py -i AUTOLIGHTNING -e wip. The tests typically add a lot of Selenium screenshots so it's recommended to create a directory to put all output files and then add -d outputDirectoryName when running tests.
    
### In GUI
    - Import the project in Python
    - Open the test robot file, right click on the test and click on Run.
    - Once the test is completed the location of log.html, report.html is provided
    - If u want to run any particular set of test cases, go terminal and navigate to the project directory using command cd robot_tests
    - Run scripts using command - python run.py -i <tag_name> -e wip -d C:\Users\<tcad id>\Desktop\Screenshots,
  
### In Jenkins
    - path - https://jenkins.verso.sonera.fi/job/b2b-digisales/job/Tests/job/Merge%20tests/
    - Go to configure section of the build and update details of branch, build command.
    - Few builds are configured in a way to get the automated mail after the execution. Example - Sanity build

## Configuring test for different environment
    - Environment details should be updated in ${ENVIRONMENT} and ${ENVIRONMENT_CONSOLE} variables. (robot_tests/frontendsanity/resources/Variables.robot)
    - Also, make sure the username and password for the environmet is coreect. 
    - The default account used is “DigiSales Lightning User”, this can be used by passing the parameter in the common login keyword.
      Example - Go To Salesforce and Login into Lightning       B2B DigiSales
    - Similarly, we can pass parameter for other users as well. If the user keyword is not present in Login.robot, kindly create a new keyword.
    
## Standards & Guidelines
### Naming Convention & Documentation
    - Test case, Keyword and variables name should be easy to understand, descriptive and not too long.
    - All Robot files should be functionally named. As the groupind is done w.r.t functionality.
    - All Tests and keywords should have [Documentation], which explain the background, prerequisites and brief functional explanation.
    - Any negative test cases should be prefixed with Negative : <TC Name>
    
### Test Structure
    - All the test files should have generic documentation which explains the brief functionality of the test with the environment to be executed. This is useful in report generation.
    - Test setup and teardown are used for cleanup
    - Import only the required resource files
    - Pass static data & xpath from variables file, avoid hardcoding
    - Include Tags with respective task id, generic tag and functionity tag.
    - Try to use keywords with dynamic data wherever possible to ensure the reusability. 
    - Do not include any logic in the testcase, all the manipulations should be done in the keyword.
    - Use abstraction level consistently

### Keyword Structure
    - Explain in Documentation what the keyword does, not how it does
    - Import only the required resource files
    - Clear structure is required.
    - Can contain programming loops and conditions
   
### Passing and returning values
    - Common approach is to return values from keywords, assign them to variables and then pass them as arguments to other keywords.
    - Alternative approach is using the BuiltIn 'Set Test Variable' keyword
   
## Related Links
    - Automation Dashboard - https://devopsjira.verso.sonera.fi/secure/Dashboard.jspa?selectPageId=11504
    - Bitbucket Repository - https://git.verso.sonera.fi/projects/BBDIG/repos/claudia-pipeline/browse    
    - To know more on Robot Framework - https://wiki.intra.sonera.fi/display/VERSO/Test+Automation+-+Robot+Framework