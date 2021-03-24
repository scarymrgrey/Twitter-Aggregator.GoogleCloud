import tweepy
import json
import os
from google.cloud import pubsub_v1

publisher = pubsub_v1.PublisherClient()


def get_message(msg):
    return msg.encode("utf-8")


def env(v_name):
    return os.environ.get(v_name, 'Specified environment variable is not set.')


def callback(future):
    print("publish finished!")


def publish_success_to_control_pubsub(future):
    topic_path = publisher.topic_path("fedex-twitter", "CONTROL_QUEUE")
    new_future = publisher.publish(topic_path, get_message("AGGREGATE_FEED"))
    new_future.add_done_callback(callback)


def execute_consume_feed():
    api_key = env("TWITTER_API_KEY")
    api_secret_key = env("TWITTER_API_SECRET_KEY")
    access_token = env("TWITTER_ACCESS_TOKEN")
    access_token_secret = env("TWITTER_ACCESS_TOKEN_SECRET")
    auth = tweepy.OAuthHandler(api_key, api_secret_key)
    auth.set_access_token(access_token, access_token_secret)
    api = tweepy.API(auth)
    date_since_pro = env("DATE_SINCE")
    places = api.geo_search(query=env("COUNTRY"), granularity="country")
    place_id = places[0].id
    search_words = "place:%s" % place_id

    tweets = tweepy.Cursor(api.search_full_archive, environment_name='dev', query=search_words,
                           fromDate=date_since_pro).items()

    topic_path = publisher.topic_path("fedex-twitter", "tweets-topic")

    latest_future = pubsub_v1.publisher.futures.Future()
    for tweet in tweets:
        json_string = json.dumps({'tweet_text': tweet.text})
        latest_future = publisher.publish(topic_path, json_string.encode("utf-8"))

    latest_future.add_done_callback(publish_success_to_control_pubsub)


def consume_feed(event, context):
    if 'data' in event:
        message = event['data']
        if message == "CONSUME_FEED":
            print("CONSUME_FEED")
            execute_consume_feed()
            print("FEED CONSUMED")


execute_consume_feed()
