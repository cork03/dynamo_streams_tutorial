import json
import boto3
import os

sns_client = boto3.client("sns")


def handler(event, context):
    messages = []
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

    sns_client.publish(**params)

    return {
        "statusCode": 200
    }
