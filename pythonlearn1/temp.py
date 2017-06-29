# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 16:56:28 2017

@author: sunhp
"""

infe9 = "905.txt"
infe42 = "4290.txt"

#inf9 = open(infe9,"r",encoding = "UTF-8")
#inf42 = open(infe42,"r",encoding = "UTF-8")



#line = inf9.readline()
#while line:
#    id1 = line
#    id1 = id1.strip('\n')

def find_value(s,file):
    IN = open(file,"r",encoding = "UTF-8")
    lt = []
    line = IN.readline()
    while line:
        a = str(line)
        a = a.strip('\n')
        if a.find(s) == 0:
            lt.append(a)
        line = IN.readline()
    return lt

inf9 = open(infe9,"r",encoding = "UTF-8")
d = dict()
line = inf9.readline()
while line:
    id1 = str(line)
    id1 = id1.strip('\n')
    dict[id1] = find_value(id1,infe42)
    line = inf9.readline()


