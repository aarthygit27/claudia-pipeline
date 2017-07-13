# Migration tool
## Deploying or retrieving metadata
- NEVER DEPLOY ANYTHING TO TEST SANDBOX
- ant listMetadata lists all the metadata of single metadata type which is declared at build.properties as `sf.metadataType`.
- build.properties contains usernames & sandbox/dev URL configurations (currently tokens included)
- build.xml contains ant-scripts for moving & reading metadata
- unpackaged/package.xml contains all the metadata types which are retrieved when running `retrieveUnpackaged`

