# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 14:26:23 2017

@author: sunhp

important note the python text coding and decoding "UTF-8-sig" or "UTF-8" BOM

print dict

"""
import string
dt = dict()

def apart(sr):
    sr = sr.strip()
    puc = list(string.punctuation + '—')
#    print(puc)
    for i in list(puc):
        sr = sr.replace(i,' ',)
        sr = sr.strip()
    sr = sr.split(' ')
    while '' in sr:
        sr.remove('')
    return sr

def word_f(lst):
    for i in lst:
        i = i.upper()
        dt[i] = dt.setdefault(i,0) + 1
        
def most_common(h):
    t = []
    for key, value in h.items():
        t.append((value,key))
        
    t.sort(reverse=True)
    return t

a = open("C:\\Users\\sunhp\\Desktop\\Ulysses1.txt","r",encoding = "UTF-8-sig")
line = a.readline()
while line:
    x = apart(line)
    word_f(x)
    line = a.readline()
a.close()

out = open("C:\\Users\\sunhp\\Desktop\\Count.txt","w",encoding='utf-8')
"""
sort by keys
for i in sorted(dt.keys()):
    print(i,dt[i])
"""
#sort by values  
dl = sorted(dt.items(), key=lambda item:item[1], reverse=True)



for i in range(len(dl)):
    x = str(dl[i])
    x = x[1:-1]
    x = x + '\n'
    out.writelines(x)
out.close()
        