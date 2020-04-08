# Test Automation
     
  Pack has different set of tests for Frontend, Integration, P&O.

## Contents

- [Installation](#installation)
- [Framework & Scripts](#framework-and-scripts)
- [Running Scripts](#running-scripts)
- [Configuring test for different environment](#configuring-test-for-different-environment)
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
    
## Related Links
    - Automation Dashboard - https://devopsjira.verso.sonera.fi/secure/Dashboard.jspa?selectPageId=11504
    - Bitbucket Repository - https://git.verso.sonera.fi/projects/BBDIG/repos/claudia-pipeline/browse    