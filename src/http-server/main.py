from flask import escape
import json
from google.cloud import bigquery


def start_http(request):
    query_job = execute_aggregations()
    records = [dict(row) for row in query_job]
    json_obj = json.dumps(str(records))
    return escape(json_obj)


def execute_aggregations():
    client = bigquery.Client()

    query = """
        SELECT * FROM `fedex-twitter.tweetsds.aggregated` ORDER BY Count DESC LIMIT 20
    """
    query_job = client.query(query)
    return query_job
