# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 09:49:42 2017

@author: sunhp
"""

import turtle

def draw(t, length, n):
    if n == 0:
        return
    angle = 50
    t.fd(length*n)
    t.lt(angle)
    draw(t, length, n-1)
    t.rt(2*angle)
    draw(t, length, n-1)
    t.lt(angle)
    t.bk(length*n)

def koh(t,length):
    if length < 3:
        t.fd(length)
        return
    koh(t,length/3)
    t.lt(60)
    koh(t,length/3)
    t.rt(120)
    koh(t,length/3)
    t.lt(60)    
    koh(t,length/3)
    
def snow(t,length):
    koh(t,length)
    t.rt(120)
    koh(t,length)
    t.rt(120)
    koh(t,length)    

bob = turtle.Turtle()
bob.pd()


snow(bob,100)

turtle.mainloop()