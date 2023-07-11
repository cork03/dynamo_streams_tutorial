import json
import boto3
import os

sns_client = boto3.client("sns")


def handler(event, context):
    user_ids = []
    for record in event["Records"]:
        image = record["dynamodb"]["NewImage"]
        user_ids.append(image["UserId"]["N"])
    print(user_ids)

    params = {
        "TopicArn": os.environ["SNS_TOPIC_ARN"],
        "Message": json.dumps(user_ids)
    }

    sns_client.publish(**params)

    return {
        "statusCode": 200
    }
