import json
import boto3
import os


def lambda_handler(event, context):
    for record in event["Records"]:
        body = json.loads(record['body'])
        request_id = body['requestId']
        event = body['event']['body']
        
        table_name = os.environ['TABLE_NAME']

        dynamodb = boto3.resource("dynamodb")
        table = dynamodb.Table(table_name)
        table.put_item(
            Item={
                    'requestId': request_id,
                    'event': json.dumps(event)
                }
            )
        
    return {}