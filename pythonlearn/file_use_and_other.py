# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 14:26:23 2017
@author: sunhp
important note the python text coding and decoding "UTF-8-sig" or "UTF-8" BOM
print dict by key or value
"""
import string
dt = dict()#字典型全局变量不需要声明，函数调用直接修改，列表同理

def apart(sr):#删除一句话的标点符号，sr是string
    sr = sr.strip()
    puc = list(string.punctuation + '—')
    for i in list(puc):
        sr = sr.replace(i,' ',)
        sr = sr.strip()
    sr = sr.split(' ')
    while '' in sr:
        sr.remove('')
    return sr

def word_f(lst):#统计列表中的词频，lst是list,直接使用dt返回
    for i in lst:
        i = i.upper()
        dt[i] = dt.setdefault(i,0) + 1

def most_common(h):#按词频高低排序，h是dict
    t = []
    for key, value in h.items():#遍历字典的元组方法
        t.append((value,key))
    t.sort(reverse=True)
    return t

a = open("Ulysses.txt","r",encoding = "UTF-8-sig")#带有BOM标的要加-sig
line = a.readline()#逐行读取文件的方法
while line:
    x = apart(line)
    word_f(x)
    line = a.readline()
a.close()

out = open("Words_Count.txt","w",encoding='utf-8')
#sort by keys
"""
for i in sorted(dt.keys()):
    print(i,dt[i]+'\n')
"""
#sort by values
dl = sorted(dt.items(), key=lambda item:item[1], reverse=True)

for i in range(len(dl)):
    x = str(dl[i])
    x = x[1:-1]
    x = x + '\n'
    out.writelines(x)

out.close()
