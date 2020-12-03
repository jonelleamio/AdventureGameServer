# AdventureGameServer
## A simple MUD game server
###Welcome to the world of undead
####Heres what you can do :</b>
<ul>
<li>POST < url >/connect</li>
<li>GET  < url >/< guid >/regarder</li>
<li>
POST < url >/< guid >/deplacement
<ul>
<li>data can be json or</li>
<li>x-www-form-urlencoded</li>
<li>{"direction": "N" | "S" | "E" | "W"}</li>
</ul>
</li>
<li>GET  < url >/< guidsource >/examiner/< guiddest ></li>
<li>POST < url >/< guidsource >/taper/< guidcible ></li>
</ul>

####Known errors
<ul>
<li>{"type" : "NOTPLAYER", "message" : ".."}</li>
<li>{"type" : "MORT", "message" : ".."}</li>
<li>{"type" : "DIFFSALLE", "message" : ".."}</li>
<li>{"type" : "MUR", "message" : ".."}</li>
<li>{"type" : "NOTDIRECTION", "message" : ".."}</li>
<li>{"type" : "EXIT", "message" : ".."}</li>
<li>{"type" : "ERROR", "message" : ".."}</li>
</ul>

### How to run
```
dart bin/AdventureGameServer.dart
```
### How to use
Dont have client yet ? </br>
To test features you can look at file `bin/test_server.py`
and run it step by step
First run connect to get guid
then put it in file. </br>
ET VOILA   !
```
python bin/test_server.py
```
You can soon test game as a line command game
```
dart bin/AdventureGame/Main.dart
```