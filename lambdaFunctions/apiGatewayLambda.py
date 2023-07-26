import json
import requests


def handler(event, context):
    print(event)
    post_data = json.loads(event["body"])
    print(post_data)
    if "SubscribeURL" in post_data:
        requests.get(post_data["SubscribeURL"])
    messages = post_data["Message"]
    user_ids = []
    status = []
    json_encoded = json.dumps(messages)
    print(json_encoded)
    json_decoded = json.loads(json_encoded)
    print(type(json_decoded))
    for record in json_decoded:
        print(record)
    return {
        "statusCode": 200,
        "body": json.dumps({
            "user_ids": user_ids,
            "status": status
        })
    }
