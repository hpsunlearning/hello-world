# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 13:02:46 2017

@author: sunhp
"""

def histogram(astr):
    d = dict()
    for c in astr:
        d[c] = 1 + d.get(c,0)
    return d

def print_hist(h):
    k = list(h.keys())
    k.sort()
    for i in k:
        print(i,h[i])
        
def reverse_lookup(d,v):
    df = []
    for k in d:
        if d[k] == v:
            df.append(k)
    return df

def invert_dict(d):
    inv = dict()
    for key in d:
        val = d[key]
        if [key] != inv.setdefault(val,[key]):
            inv[val].append(key)
    return inv

def has_duplicate(alist):
    d = dict()
    for i in range(len(alist)):
        d.setdefault(alist[i],0)
    if len(d) < len(alist):
        return True
    return False

       
#eng2sp = {'one': 'uno', 'two': 'dos', 'shree': 'tres', 'kkk':'uno'}
a = [1,23,45,6,8,9,'fg','g','f',9]

print(has_duplicate(a))

