import json
import boto3
import os


def lambda_handler(event, context):
    for record in event["Records"]:
        body = json.loads(record['body'])
        request_id = body['requestId']
        
        bucket_name = os.environ['BUCKET_NAME']
        file_name = request_id + ".txt"
        s3_path = "requests/" + file_name

        s3 = boto3.resource("s3")
        s3.Bucket(bucket_name).put_object(Key=s3_path, Body=json.dumps(body))
        
    return {}