import json
import requests


def handler(event, context):
    requests.get(event["SubscribeURL"])
    messages = event["Message"]
    user_ids = []
    status = []
    for record in messages:
        user_ids.append(record["userId"])
        status.append(record["status"])

    return {
        "statusCode": 200,
        "body": json.dumps({
            "user_ids": user_ids,
            "status": status
        })
    }
