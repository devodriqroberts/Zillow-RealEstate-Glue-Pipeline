import json
import os
import pathlib
from datetime import datetime
from pathlib import Path

import boto3
import requests

DST_BUCKET  = os.environ.get("DST_BUCKET")
REGION      = os.environ.get("REGION")
RAW_FOLDER  = os.environ.get("RAW_FOLDER")
API_KEY     = os.environ.get("API_KEY")
API_HOST    = os.environ.get("API_HOST")
URL         = "https://zillow-com1.p.rapidapi.com/propertyExtendedSearch"


locations = {
    "ga": ["atlanta"],
    # "ga": ["atlanta", "savannah"], 
    # "tx": ["houston", "dallas"]
}

s3 = boto3.client("s3", region_name=REGION)


def lambda_handler(event, context):
    create_s3_directories_based_on_city(s3, DST_BUCKET, locations, RAW_FOLDER)

    date = get_time()[1]

    populate_database_table_s3_bucket(s3, DST_BUCKET, date, locations, RAW_FOLDER)


# create directories based on city name
def create_s3_directories_based_on_city(s3, bucket_name, locations_dict, s3_data_folder):

    for state, cities in locations_dict.items():
        for city_name in cities:
            table_name_s3_prefix = str(Path(s3_data_folder) / state / city_name)

            #  check if s3 object already exists
            try:
                s3.head_object(Bucket=bucket_name, Key=table_name_s3_prefix)
            except s3.exceptions.ClientError as e:
                if e.response["Error"]["Code"] == "404":
                    # key doesn't exists
                    s3.put_object(Bucket=bucket_name, Key=(table_name_s3_prefix + "/"))

                    pass
            else:
                # Key exists, do nothing
                pass


def get_time():
    dt = datetime.now()
    timestamp = str(datetime.timestamp(dt)).replace(".", "_")
    return timestamp, dt.strftime("%Y-%m-%d")


def fetch_api_data(url, query):
    headers = {
        "X-RapidAPI-Key": API_KEY,
        "X-RapidAPI-Host": API_HOST,
    }
    response = requests.get(url, headers=headers, params=query)

    if response.status_code == 200:
        data = json.loads(response.text)
        if "props" in data:
            return data["props"]
        else:
            raise Exception(f"'results' key not found in API response: {data}")
    else:
        raise Exception(f"Error fetching data: {response.text}")


def populate_database_table_s3_bucket(s3, bucket_name, date, locations_dict, s3_data_folder):

    for state, cities in locations_dict.items():
        for city_name in cities:
            try:
                file_name = f"{city_name}-{state}_{date}.json"
                query = {
                    "location": f"{city_name}, {state}", 
                    "status_type": "ForSale", 
                    "home_type": "Houses", 
                    "daysOn": 7
                }

                # fetching data
                data = fetch_api_data(URL, query)
                s3_object_key = str(Path(s3_data_folder) / state / city_name / file_name)
                try:
                    s3.put_object(
                        Bucket=bucket_name, Key=s3_object_key, Body=json.dumps(data)
                    )
                except s3.exceptions.ClientError as e:
                    raise Exception(
                        f"Error uploading data to S3: {e}"
                    ) from e  # Re-raise with more context

            except Exception as e:
                print(f"Error populating table '{city_name}, {state}': {e}")
