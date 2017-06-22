# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 10:51:00 2017

@author: sunhp
"""

#import math
"""
def is_palindrome(word):
    i = 0
    j = len(word) - 1
    while i < j:
        if word[i] != word[j]:
            return False
        i = i + 1
        j = j - 1
    return True
"""
for n in range(0,999999):
#    n = 198888
    a = str(n)
    while len(a) < 6:
        a = '0' + a
#    print(a)
    t = a[2:]
    if t != t[::-1]:
        continue
    b = str(n + 1)
    while len(b) < 6:
        b = '0' + b
#    print(b)
    t = b[1:]
    if t != t[::-1]:
        continue
    c = str(n + 2)
    while len(c) < 6:
        c = '0' + c
#    print(c)
    t = c[1:5]
    if t != t[::-1]:
        continue
    d = str(n + 3)
    while len(d) < 6:
        d = '0' + d
#    print(d)
    if d != d[::-1]:
        continue
    print(a,b,c,d)
    


#print(not is_palindrome('000100'))
    


