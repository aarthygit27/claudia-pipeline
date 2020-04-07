# Test Automation
     
  Pack has different set of tests for Frontend, Integration, P&O.

## Contents

- [Installation](#installation)

## Installation
- Softwares & Frameworks
    - Install Python 3.7 from https://www.python.org/downloads/windows/
    - Add Python Application path and Scripts path to Environment Variables
    - Install Robot Frameework by using command - pip install robotframework
    - Install Selenium using command - pip install selenium==3.8.0
    - Install Selenium library using command -  pip install robotframework-seleniumlibrary (If you face any problem in running the tests install selenium2library using command - pip install robotframework-selenium2library==3.0.0)
    - Download Firefox ESR latest version
    - Download geckodriver 0.17.0 and place it to PATH.
    - Download Pycharm or RIDE IDE or any other which suits you
    - Download Git Bash from https://git-scm.com/downloads
- Project Repository Setup
    - Go to Project Repository in Bitbucket (https://git.verso.sonera.fi/projects/BBDIG/repos/claudia-pipeline/browse)
    - Click on the Clone action in the side bar and copy the http link. Example : https://git.verso.sonera.fi/scm/bbdig/claudia-pipeline.git
    - Open git bash and clone the repository using command - git clone https://git.verso.sonera.fi/scm/bbdig/claudia-pipeline.git
    - Navigate to repository using command - cd claudia-pipeline
    - The default branch that is cloned is master branch so specific branch must be selected (switch to merge branch) using command - git checkout merge
    - The test cases can be found in 'robot_tests' folders of the cloned repository 

## Framework and Scripts
- FrontEnd Automation
    - Path - robot_tests/frontendsanity
    - Here robot test cases are grouped w.r.t functionality in path - robot_tests/frontendsanity/tests
    - Below are the test cases and the keywords to be used for the test cases in respective functionality.
    

| Test                             | Description                                                                        | Varibles.robot                                   | Login.robot                              | Common.robot                                        | Account.robot                                             | Opportunity.robot |
|----------------------------------|------------------------------------------------------------------------------------|--------------------------------------------------|------------------------------------------|-----------------------------------------------------|-----------------------------------------------------------|-------------------|
| AccountManagement.robot          | Functionalities related to Business Account, <br>Group Account and Account related | Resusable xpath, data are <br>passed to the test | Keywords related to login <br>and logout | Generic keywords used across <br>the tests/keywords | Keywords specific to Account <br>management functionality |                   |
| AutomaticAvailabilityCheck.robot | Functionalities related to Automatic <br>Availability check                        | Resusable xpath, data are <br>passed to the test | Keywords related to login <br>and logout | Generic keywords used across <br>the tests/keywords |                                                           |                   |
|                                  |                                                                                    |                                                  |                                          |                                                     |                                                           |                   |    