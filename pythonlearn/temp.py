# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 16:56:28 2017
@author: sunhp
临时用
"""

infe9 = "905.txt"
infe42 = "4290.txt"

def find_value(s,file):
    IN = open(file,"r",encoding = "UTF-8")
    lt = []
    line = IN.readline()
    while line:
        a = str(line)
        a = a.strip('\n')
        if a.find(s) != -1:
            lt.append(a)
        line = IN.readline()
    return lt

inf9 = open(infe9,"r",encoding = "UTF-8")
d = dict()
line = inf9.readline()
while line:
    id1 = str(line)
    id1 = id1.strip('\n')
    a = find_value(id1,infe42)
    d[id1] = a
    line = inf9.readline()
inf9.close()

out = open("Count.txt","w",encoding='utf-8')
for i in sorted(d.keys()):
    a = i
    for j in range(len(d[i])):
        out.writelines(a+'\t'+d[i][j]+'\n')
out.close()
