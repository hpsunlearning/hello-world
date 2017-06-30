# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 15:46:03 2017
@author: sunhp
used for WordCloud generate
"""

from os import path
from scipy.misc import imread
from PIL import Image
import matplotlib.pyplot as plt
import jieba
import numpy as np
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator

def importStopword(filename=''):
    global stopwords
    f = open(filename, 'r',encoding='utf-8')
    line = f.readline().rstrip()
    while line:
        stopwords.setdefault(line,0)
        stopwords[line] = 1
        line = f.readline().rstrip()
    f.close()

def processChinese(text):
    seg_generator = jieba.cut(text)
    seg_list = [i for i in seg_generator if i not in stopwords]
    seg_list = [i for i in seg_list if i != u' ']
    seg_list = r' '.join(seg_list)
    return seg_list

d = path.dirname('.')
text = open(path.join(d, 'paper.txt'),encoding ='utf-8').read()
#text = processChinese(text)#对中文分词

back_coloring = imread(path.join(d, "pic.jpg")) #一般配色
#back_coloring = np.array(Image.open(path.join(d,"pic.jpg"))) #高阶配色

wc = WordCloud(
#                font_path =path.join(d, 'font.ttf'),#设置字体
                background_color="white",#设置背景颜色
                mask=back_coloring,#设置背景图片
                max_words=2000,
                max_font_size=40,
                width=800,#设置图片大小
                height=600,
#                prefer_horizontal=0.9,#水平词出现频率0，-1
                ranks_only=True,#用于频度的排序而不考虑实际频数的大小
#                scale=1,#计算与绘制图像的比例，按比例放大
                random_state=42
                )

#直接生成词云
wc.generate(text)

#从词频生成词云，词频为dict形式
#xt_freq = {'上火':217,'长斑':176,'腹痛':110,'腹胀':109,'高血脂':83,'肥胖':63,'高血压':62}
#wc.generate_from_frequencies(txt_freq)

image_colors = ImageColorGenerator(back_coloring)

#plt.imshow(wc)
#plt.axis("off")
#plt.figure()
#######
plt.imshow(wc.recolor(color_func=image_colors))
plt.axis("off")
plt.figure()

wc.to_file(path.join(d,"result.png"))
