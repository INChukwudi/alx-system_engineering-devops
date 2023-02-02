#!/usr/bin/python3
"""
Function that queries the Reddit API
Prints the titles of the first 10 hot posts
for a given subreddit
"""
import requests


def top_ten(subreddit):
    """
    Prints the titles of the first 10 hot posts for a given subreddit
    """

    url = "https://www.reddit.com/r/{}/hot/.json".format(subreddit)
    headers = {
        "User-Agent": "linux:ubuntu_14_04_LTS:0x16_api_adanced"
    }
    params = {
        "limit": 10
    }
    response = requests.get(url, headers=headers, params=params,
                            allow_redirects=False)

    if response.status_code == 404:
        print("None")
        return

    results = response.json().get("data")
    [print(c.get("data").get("title")) for c in results.get("children")]
