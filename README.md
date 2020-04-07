# Test Automation
     
  Pack has different set of tests for Frontend, Integration, P&O.

## Contents

- [Installation](#installation)
- [Framework](#framework-and-scripts)

## Installation

#### Softwares & Frameworks
    - Install Python 3.7 from https://www.python.org/downloads/windows/
    - Add Python Application path and Scripts path to Environment Variables
    - Install Robot Frameework by using command - pip install robotframework
    - Install Selenium using command - pip install selenium==3.8.0
    - Install Selenium library using command -  pip install robotframework-seleniumlibrary (If you face any problem in running the tests install selenium2library using command - pip install robotframework-selenium2library==3.0.0)
    - Download Firefox ESR latest version
    - Download geckodriver 0.17.0 and place it to PATH.
    - Download Pycharm or RIDE IDE or any other which suits you
    - Download Git Bash from https://git-scm.com/downloads
    
#### Project Repository Setup
    - Go to Project Repository in Bitbucket (https://git.verso.sonera.fi/projects/BBDIG/repos/claudia-pipeline/browse)
    - Click on the Clone action in the side bar and copy the http link. Example : https://git.verso.sonera.fi/scm/bbdig/claudia-pipeline.git
    - Open git bash and clone the repository using command - git clone https://git.verso.sonera.fi/scm/bbdig/claudia-pipeline.git
    - Navigate to repository using command - cd claudia-pipeline
    - The default branch that is cloned is master branch so specific branch must be selected (switch to merge branch) using command - git checkout merge
    - The test cases can be found in 'robot_tests' folders of the cloned repository 

## Framework and Scripts

#### FrontEnd Automation
    - Path - robot_tests/frontendsanity
    - Here robot test cases are grouped w.r.t functionality in path - robot_tests/frontendsanity/tests
    - Below are the existing keywords and description.
    - Do not create new keywords file for any existing functionality.
    - For new test case development, try to use the existing keywords first. If no generic keyword is found, search for the relevant keyword and check if that can be used with slight modification. If nothing works out, go ahead and create new keyword. 
    
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