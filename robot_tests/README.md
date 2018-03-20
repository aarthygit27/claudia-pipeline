# Robot Tests

Run all tests with the `run.py` script. The `run.py` handles adding all correct directories to the PYTHONPATH.

Example: `python run.py -i sales -e wip`. The tests typically add _a lot_ of Selenium screenshots so it's recommended
to create a directory to put all output files and then add `-d outputDirectoryName` when running tests.

## Libs

Libs contain own Python libraries. Most keywords defined there are legacy from MuBe.

## Resources

Different robot keyword and variable files. They are divided to have one file for each component/site (AIDA, Salesforce, CPQ, TellU, MuBe, UAD).
Each of these resource the `common.robot` file, which resources the `common_variables.robot` file.

## Tests

Tests are divided by JIRA ticket business area. When a new test is added, add a `wip` tag for that test so Jenkins doesn't run those
jobs when they aren't finished yet. Once the test is finished, remove the `wip` tag from the robot file and add `AUTO` label for
the JIRA Test Case Template ticket.

Before the tests are run ensure that the `DEFAULT_TEST_ACCOUNT` has the following contact person:
- Name: `Paavo Pesusieni`
- Business Card Title: `Sponge of sponges`
- Language: `Finnish`
- Mobile: `+3588881234`
- Email: `9876543210noreply@teliacompany.com`
- Gender: `0 - not known`
- Sales Role: `Business Contact`

## Jenkins

https://jenkins.verso.sonera.fi/

Jobs are run in b2b-digisales/Tests. Smoke tests and sales tests are automatically run once a day. Performance monitoring tests are
run once every 20 minutes and they need the `monitor@teliacompany.com.preprod` user to be available in PREPROD.

**REMEMBER TO TAKE ALL SCHEDULED RUNS OFF DURING SANDBOX REFRESH**