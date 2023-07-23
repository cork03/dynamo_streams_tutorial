import json
import requests


def handler(event, context):
    print(event)
    post_data = json.loads(event["body"])
    print(post_data)
    requests.get(post_data["SubscribeURL"])
    messages = post_data["Message"]
    user_ids = []
    status = []
    for record in messages:
        user_ids.append(record["userId"])
        status.append(record["status"])
    print(user_ids)
    print(status)
    return {
        "statusCode": 200,
        "body": json.dumps({
            "user_ids": user_ids,
            "status": status
        })
    }
