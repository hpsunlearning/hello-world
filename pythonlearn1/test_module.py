# -*- coding: utf-8 -*-
"""
Created on Mon Jun 26 13:22:44 2017

@author: sunhp
"""

if __name__ == '__main__':
    print("main")
    
def linecount(filename):
    count = 0
    for line in open(filename):
        count += 1
    return count

