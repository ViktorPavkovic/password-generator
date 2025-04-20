from string import ascii_lowercase, ascii_uppercase, digits
from random import choices
from boto3 import resource
from time import time
from os import environ

# Environment variables
TTL         = int(environ.get('TTL'))
STR_LENGTH  = int(environ.get('STR_LENGTH'))
STR_COUNT   = int(environ.get('STR_COUNT'))

SAVE_TO_DDB = environ.get('SAVE_TO_DDB').lower() == 'true'
if SAVE_TO_DDB:
  DDB_TABLE   = str(environ.get('DDB_TABLE'))
  dynamodb = resource('dynamodb')
  table = dynamodb.Table(DDB_TABLE)

# Define character set
CHARS = ascii_lowercase + ascii_uppercase + digits


# Generate a random string
def string_generator(length):
  return ''.join(choices(CHARS, k=length))

# Put object in DynamoDB
def put_to_ddb(data):
  table.put_item(Item={
    'password': data,
    'ttl': int(time()) + TTL
  })


# Main
def lambda_handler(event, context):
  password = '-'.join([string_generator(STR_LENGTH) for _ in range(STR_COUNT)])

  # Store to DDB if enabled
  if SAVE_TO_DDB:
    put_to_ddb(password)

  return password
