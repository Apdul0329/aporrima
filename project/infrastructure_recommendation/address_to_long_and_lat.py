import requests; from urllib.parse import urlparse
import pandas as pd

def address_to_latlon(address):
    APP_KEY = input("앱 키 입력: ")
    global val
    url = "https://dapi.kakao.com/v2/local/search/address.json?&query=" + address
    result = requests.get(urlparse(url).geturl(),
                          headers={"Authorization":"KakaoAK "+APP_KEY})
    json_obj = result.json()
    for document in json_obj['documents']:
        val = [document['address_name'], document['y'], document['x']]
    return val
