# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 10:40:04 2017
@author: sunhp
"""
import random

def chop(alist):#去掉头尾，list不需要返回，直接修改
    del alist[0]
    del alist[-1]

def middle(alist):#返回中间新list
    return alist[1:-1]

def has_duplicates(alist):#list的双重遍历
    for i in range(len(alist)):
        j = 1
        while i + j < len(alist):
            if alist[i] == alist[i+j]:
                return True
            j += 1
    return False

def in_list(a,blist):
    for i in range(len(blist)):
        if blist[i] == a:
            return True
    return False

def rand_birth():#生成随机生日年月
    m = random.randint(1,12)
    if in_list(m,[1,3,5,7,8,10,12]):
        d = random.randint(1,31)
    elif m == 2:
        d = random.randint(1,29)
    else:
        d = random.randint(1,30)
    mm = str(m).zfill(2)
    dd = str(d).zfill(2)
    return mm + dd

def rand_birth_n(n):
    birthlist = []
    for i in range(0,n):
        birthlist.append(rand_birth())
    return birthlist

def prob_same(n,s):#生日概率问题
    pos = 0
    for i in range(0,n):
        a = rand_birth_n(s)
        if has_duplicates(a):
            pos += 1
    p =  pos / n
    return float(p)

print(prob_same(1000,60))
