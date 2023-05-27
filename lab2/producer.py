import json
import boto3
import random, string

def generate_request_id():
   letters = string.ascii_lowercase
   return ''.join(random.choice(letters) for i in range(8))


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    
    request_id = generate_request_id()
    
    sqs = boto3.client('sqs')
    data = sqs.send_message(
        QueueUrl="https://sqs.{REGION}.amazonaws.com/{ACCOUNT_ID}/Requests",
        MessageBody=json.dumps({
            'event': event,
            'requestId': request_id
        })
    )
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({
            'event': event,
            'requestId': request_id
        }),
        "isBase64Encoded": False
    }

