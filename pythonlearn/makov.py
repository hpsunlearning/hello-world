# -*- coding: utf-8 -*-
"""
Created on Fri Jun 23 11:05:57 2017
@author: sunhp
构建文本的makov模型，基础是dict_use
"""

import random
import string

def makov_file(file,level=2,code="UTF-8-sig"):
    IN = open(file,"r",encoding = "UTF-8-sig")
    mdic = dict()
    line = IN.readline()
    while line:
        w = apart(line)
        makov(w,mdic,level)
        line = IN.readline()
    IN.close()
    return mdic

def apart(sr):
    sr = sr.strip()
#    puc = list(string.punctuation + '—' + string.whitespace)#是否保留标点
    puc = list('—' + string.whitespace)
    for i in list(puc):
        sr = sr.replace(i,' ',)
        sr = sr.strip()
    sr = sr.split(' ')
    while '' in sr:
        sr.remove('')
    return sr

def makov(lst,mdic,level=2):#构建makov链，lst是list，mdic是dict，level是前状态等级
    for i in range(len(lst)-level):
        mk1 = lst[i:i+level]
        mk2 = ''
        for j in range(len(mk1)):
            mk2 = mk2 + ' ' + str(mk1[j])
            mk2 = mk2.strip()
        if mdic.__contains__(mk2):
            mdic[mk2].append(lst[i+level])
        else:
            mdic[mk2] = [lst[i+level]]
    return mdic

def hist(lst):
    h = dict()
    for word in lst:
        h[word] = h.get(word,0) + 1
    return h

def fwords(h):
    words = sorted(h.keys())
    feq = 0
    feq_word = []
    for i in words:
        feq = feq + h[i]
        feq_word.append([i,feq])
    return feq_word

def makov_table(mdic):#构建makov概率表
    mt = dict()
    for i in sorted(mdic.keys()):
        v = fwords(hist(mdic[i]))
        mt[i] = v
    return mt

def getrword(lst):#按概率表生成词，lst是二维，词，累积词频
    n = random.randint(1,lst[-1][1])
    h = 0
    t = len(lst) - 1
    m = int((h + t) / 2)
    while h < t:#二分法概率查找，高效
        if lst[m][1] == n:
            return lst[m][0]
        elif lst[m][1] < n:
            if lst[m + 1][1] >= n:
                return lst[m+1][0]
            else:
                h = m
                m = int((h + t) / 2)
        else:
            if lst[m - 1][1] <= n:
                return lst[m-1][0]
            else:
                t = m
                m = int((h + t) / 2)
    return lst[m][0]

def creatpaper(n,first,mt,level=2):#生成文章
    a = ''
    for word in mt.keys():
        if word.startswith(first):
            a = word
            break
    if a == '':
        a = word
    for i in range(1,n):
        a = makovchain(a,mt,level=2)

    return a

def makovchain(s,mt,level=2):#按makov概率表生成词
    lst = s.split()
    a = lst[-level:]
    b = ''
    for i in range(len(a)):
        b = b + ' ' + str(a[i])
    b = b.strip()
    if mt.__contains__(b):
        c = getrword(mt[b])
    else:
        c = random.choice(list(mt.keys()))
    s = s + ' ' + c
    return s

file = "Ulysses1.txt"
mdic = makov_file(file,level=3,code="UTF-8-sig")
mt = makov_table(mdic)
a = creatpaper(20,"long",mt,level=3)

"""测试
a = [['b', 2], ['c', 8], ['d', 13], ['e', 19], ['f', 22], ['g', 25], ['h', 31], ['i', 40]]
x = getrword(31,a)
print(x)
a = "a a b a a b c a a c a a d b c d d c c d a b b b b d d c c c a c d b c d"
"""
"""测试
a = 'gurgling face that blessed him, equine in its length, and at the light'
b = apart(a)
mdic = dict()
mdic = makov(b,mdic)
mt = makov_table(mdic)
a = creatpaper(100,"an",mt,level=2)
"""
