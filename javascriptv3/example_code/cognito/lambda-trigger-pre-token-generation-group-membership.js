/* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: Apache-2.0

ABOUT THIS NODE.JS EXAMPLE: This example works with AWS SDK for JavaScript version 3 (v3),
which is pending release.  The preview version of the SDK is available
at https://github.com/aws/aws-sdk-js-v3. The 'SDK for JavaScript Developer Guide' for v3 is also
scheduled for release later in 2020, and the topic containing this example will be hosted at
https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-lambda-pre-token-generation.html.

Purpose:
lambda-trigger-pre-token-generation-group-membership.js uses the Pre Token Generation Lambda function to
modify the user's group membership.

Running the code:
1. On the AWS Lambda service dashboard, choose Create function.
2. On the Create function page, name the function, and choose Create function.
3. Copy and paste the code into the index.js file in the editor, and save the function.
4. Open the Amazon Cognito service.
5. Choose Manage user pools.
6. Choose the user pool you want to add the trigger to. (If you don't have a user pool, create one.)
7. In General Settings, choose Triggers.
8. In the Pre Token Generation pane, select the Lambda function.
*/

// snippet-start:[cognito.javascript.lambda-trigger.pre-token-generation-group-membershipV3]
exports.handler = async (event, context) => {
  try {
    event.response = {
      claimsOverrideDetails: {
        claimsToAddOrOverride: {
          attribute_key2: "attribute_value2",
          attribute_key: "attribute_value",
        },
        claimsToSuppress: ["email"],
        groupOverrideDetails: {
          groupsToOverride: ["group-A", "group-B", "group-C"],
          iamRolesToOverride: [
            "arn:aws:iam::XXXXXXXXXXXX:role/sns_callerA",
            "arn:aws:iam::XXXXXXXXX:role/sns_callerB",
            "arn:aws:iam::XXXXXXXXXX:role/sns_callerC",
          ],
          preferredRole: "arn:aws:iam::XXXXXXXXXXX:role/sns_caller",
        },
      },
    };
  } catch (err) {
    // Return to Amazon Cognito
    return null;
  }
};
// snippet-end:[cognito.javascript.lambda-trigger.pre-token-generation-group-membershipV3]
