from __future__ import print_function
#import json
import base64
import requests

def lambda_handler(event, context):
    for record in event['Records']:
       #Kinesis data is base64 encoded so decode here
       payload=base64.b64decode(record["kinesis"]["data"])
       hashmap=json.loads(payload)

       if hashmap["source"] == "panoptes" and hashmap["type"] == "classification" and hashmap["data"]["links"]["project"] == "593":
           requests.post("https://education-api.zooniverse.org/kinesis",
                   headers={"content-type": "application/json"}, data=payload)
