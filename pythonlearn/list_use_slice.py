# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 10:51:00 2017
@author: sunhp
汽车里程表问题，回文检测
生日问题
"""

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
    a = str(n)
    while len(a) < 6:
        a = '0' + a
    t = a[2:]
    if t != t[::-1]:#回文判断的语句，[::]第三个是步长，-1是翻转
        continue
    b = str(n + 1)
    while len(b) < 6:
        b = '0' + b
    t = b[1:]
    if t != t[::-1]:
        continue
    c = str(n + 2)
    while len(c) < 6:
        c = '0' + c
    t = c[1:5]
    if t != t[::-1]:
        continue
    d = str(n + 3)
    while len(d) < 6:
        d = '0' + d
    if d != d[::-1]:
        continue
    print(a,b,c,d)

for c in range(15,50):
    s = 0
    number = 0
    m = s + c
    while m <= 99:
        ms = str(m)
        ms = ms.zfill(2)
        ss = str(s)
        ss = ss.zfill(2)
        s = s + 1
        m = s + c
        if ss != ms[::-1]:
            continue
        number = number + 1
        print(ss,number,ms,c)
