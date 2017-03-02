#!/usr/bin/python2

from concat_js import *

processes = []
stylesheets = []

for p in os.listdir( "modules" ):
    for m in os.listdir("modules/" + p):
        if m == "views":
            processes.append("gen/" + m + "/" + p + ".js")
            concat_js( "modules/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

        elif m == "stylesheets":
            stylesheets.append("gen/" + m + "/" + p + ".css")
            concat_js( "modules/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

exec_cmd_silent( "echo > processes.js " )
exec_cmd_silent( "echo > stylesheets.css " )

print ("\033[0;35mConcat file : processes.js\033[m");
for v in sorted(processes):
    exec_cmd_silent( "cat processes.js " + v + " > processes_tmp.js" )
    exec_cmd_silent( "mv processes_tmp.js processes.js" )
print ("\033[0;35mConcat file : stylesheets.css\033[m");
for s in sorted(stylesheets):
    exec_cmd_silent( "cat stylesheets.css " + s + " > stylesheets_tmp.css" )
    exec_cmd_silent( "mv stylesheets_tmp.css stylesheets.css" )

print ("\033[0;35mCopy html files in html folder\033[m");
exec_cmd_silent( "cp modules/Admin/admin.html ../" )
exec_cmd_silent( "cp modules/Desk/desk.html ../" )
exec_cmd_silent( "cp modules/Lab/lab.html ../" )
