# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 14:26:23 2017

@author: sunhp
"""
import string

dt = dict()

def apart(sr):
    sr = sr.strip()
    for i in list(string.punctuation):
        sr = sr.replace(i,' ',)
        sr = sr.strip()
    sr = sr.split(' ')
    while '' in sr:
        sr.remove('')
    return sr

def word_f(lst):
    for i in lst:
        dt[i] = dt.setdefault(i,0) + 1

a = open("C:\\Users\\sunhp\\Desktop\\U1.txt","r",encoding = "UTF-8")
line = a.readline()
while line:
    x = apart(line)
    word_f(x)





#a = "Halted, he peered down the dark winding stairs and called out coarsely: out out and dark "
#print(a)
#x = apart(a)
#word_f(x)
print(dt)


        