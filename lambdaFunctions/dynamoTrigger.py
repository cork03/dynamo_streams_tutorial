import json
import os

import boto3

sns_client = boto3.client("sns")


def handler(event, context):
    messages = []
    print(event)
    for record in event["Records"]:
        image = record["dynamodb"]["NewImage"]
        message = {
            "userId": image["UserId"]["N"],
            "status": image["Status"]["S"]
        }
        messages.append(message)

    params = {
        "TopicArn": os.environ["SNS_TOPIC_ARN"],
        "Message": json.dumps(messages)
    }
    print(params)

    sns_client.publish(**params)

    return {
        "statusCode": 200
    }
