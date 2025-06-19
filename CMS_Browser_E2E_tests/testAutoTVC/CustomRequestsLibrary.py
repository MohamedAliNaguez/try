import requests

def digest_post_request(url, username, password, json_data=None):
    response = requests.post(
        url,
        json=json_data,
        headers={"Content-Type": "application/json"}
    )
    response.raise_for_status()
    return response
