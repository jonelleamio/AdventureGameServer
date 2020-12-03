import requests
import json

def getCode(res:str) :
    return str(res).split("[")[1].split("]")[0]

url = 'http://localhost:4042'
guid = '20123182747' # get guid from connexion.content
guid2 = '0'
gurl = f"{url}/{guid}"

home = requests.post(url)
print (getCode(home))
print (home.content)
print ("\n\n##################\n\n")

connexion = requests.post('http://localhost:4042/connect')
print (getCode(connexion))
print (connexion.content)
print ("\n\n##################\n\n")

# regarder =  requests.get(f"{gurl}/regarder")
# print (getCode(regarder))
# print (regarder.content)
# print ("\n\n##################\n\n")

# myobj = {"direction": "N"}
# deplacement =  requests.post(f"{gurl}/deplacement", data=myobj)
# print (getCode(deplacement))
# print (deplacement.content)
# print ("\n\n##################\n\n")

# examiner =  requests.get(f"{gurl}/examiner/{guid2}")
# print (getCode(examiner))
# print (examiner.content)
# print ("\n\n##################\n\n")

# taper =  requests.get(f"{gurl}/taper/{guid2}")
# print (getCode(taper))
# print (taper.content)

