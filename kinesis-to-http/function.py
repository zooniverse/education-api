import json
import base64
import requests

ENDPOINT = "https://education-api.zooniverse.org/kinesis"
HEADERS  = {"content-type": "application/json"}
PROJECTS = ["593", "3525", "2308", "2545"]

def lambda_handler(event, context):
  payloads = [json.loads(base64.b64decode(record["kinesis"]["data"])) for record in event["Records"]]
  dicts    = [payload for payload in payloads if should_send(payload)]

  if dicts:
    r = requests.post(ENDPOINT, headers=HEADERS, data=json.dumps({"payload": dicts}))
    r.raise_for_status()

def should_send(payload):
  return payload["source"] == "panoptes" and payload["type"] == "classification" and (payload["data"]["links"]["project"] in PROJECTS)