# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 09:49:42 2017
@author: sunhp
基本线条形状绘画
"""

import turtle
import math

def square(t,length):
   t.pd()
   for i in range(4):
       t.fd(length)
       t.lt(90)
   print(t)

def polyline(t,n,length,a):
    t.pd()
    for i in range(n):
        t.fd(length)
        t.lt(a)

def polygon(t,n,length):
    t.pd()
    a = 360 / n
    polyline(t,n,length,a)

def arc(t,r,a):
    t.pd()
    length = 2 * math.pi * r * a / 360
    n = int(length / 3) + 1
    step_l = length / n
    step_a = a / n
    polyline(t,n,step_l,step_a)

def flower(t,r,n):
    t.pd()
    a = 2 * (180 - 360 / n)
    b = 360 / n
    for i in range(n):
        t.lt(b)
        arc(t,r,a)

bob = turtle.Turtle()
flower(bob,60,n = 7)
turtle.mainloop()
