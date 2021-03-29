import os
def execute_aggregations():
    from google.cloud import bigquery
    client = bigquery.Client()

    project_name = os.environ.get("projectId", 'Specified environment variable is not set.')
    query = f"""
        INSERT tweetsds.aggregated (trends, count)
        WITH t AS (
            SELECT 
                REGEXP_EXTRACT_ALL(tweet_text, r"#(\w+)") AS hashtags
                FROM `tweetsds.tweets`
            )

        SELECT unnested_hashtags AS trend , count(unnested_hashtags) as count FROM t, UNNEST(t.hashtags) unnested_hashtags
        GROUP BY unnested_hashtags
    """
    query_job = client.query(query)
    query_job.result()


def tweets_control_pubsub(event, context):
    import base64
    print(event)
    if 'data' in event:
        message = base64.b64decode(event['data']).decode('utf-8')
        if message == "AGGREGATE_FEED":
            print("AGGREGATE_FEED")
            execute_aggregations()
            print("TWEETS_AGGREGATED")
