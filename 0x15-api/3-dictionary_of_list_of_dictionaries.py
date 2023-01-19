#!/usr/bin/python3
"""
Exports TODO list information for all employees to JSON format
"""
import json
import requests

if __name__ == "__main__":
    url = "https://jsonplaceholder.typicode.com/"
    users = requests.get(url + "users").json()

    with open("todo_all_employees.json", "w") as jsonfile:
        for u in users:
            todos = requests.get(url + "todos",
                                 params={"userId": u.get("id")}).json()
            json.dump({u.get("id"): [{
                    "username": u.get("username"),
                    "task": t.get("title"),
                    "completed": t.get("completed")
                } for t in todos]}, jsonfile)
