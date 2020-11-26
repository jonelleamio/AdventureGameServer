import requests
import json

url = 'http://localhost:4042'
guid = '123456789'
guid2 = '987654321'
gurl = f"{url}/{guid}"

home = requests.post(url)
connexion = requests.post('http://localhost:4042/connect')
regarder =  requests.get(f"{gurl}/regarder")
deplacement =  requests.post(f"{gurl}/deplacement")
examiner =  requests.get(f"{gurl}/examiner/{guid2}")
taper =  requests.get(f"{gurl}/taper/{guid2}")

def getCode(res:str) :
    return str(res).split("[")[1].split("]")[0]

print (getCode(home))
print (getCode(connexion))
print (getCode(regarder))
print (getCode(deplacement))
print (getCode(examiner))
print (getCode(taper))

