#!/usr/bin/python3
"""
Exports TODO list progress for a given employee ID to CSV format
"""
import csv
import requests
import sys

if __name__ == "__main__":
    user_id = sys.argv[1]
    url = "https://jsonplaceholder.typicode.com/"
    user = requests.get(url + "users/{}".format(user_id)).json()
    username = user.get("username")
    todos = requests.get(url + "todos", params={"userId": user_id}).json()

    with open("{}.csv".format(user_id), "w", newline="") as cf:
        w = csv.writer(cf, quoting=csv.QUOTE_ALL)
        for t in todos:
            w.writerow([user_id, username, t.get("completed"), t.get("title")])
