# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 15:46:03 2017

@author: sunhp
"""

from os import path
from scipy.misc import imread
import matplotlib.pyplot as plt
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator

#d = path.dirname(__file__)

#backgroud = imread("alice_color.png")

wc = WordCloud(background_color="white", 
max_words=2000, 
#max_font_size=40, 
width=800,
height=600,
ranks_only=True,
random_state=42)

txt_freq = {'上火':217,'长斑':176,'腹痛':110,'腹胀':109,'高血脂':83,'肥胖':63,'高血压':62,'口腔溃疡':58,'牙周炎':50,'心脏病':40,'食欲不振':33,'类风湿性关节炎':25,'皮肤干燥':23,'胃溃疡':20,'低血糖':17,'焦虑症':16,'抑郁症':9,'肾结石':8,'痛风':8,'中风':8,'便秘':7,'腹泻':7,'低血压':6,'肠易激综合征':5,'肺癌':5,'胆结石':4,'肝硬化':4,'宫颈癌':4,'乳腺癌':4,'心肌炎':4,'脂肪肝':4,'糖尿病':3,'高血糖':2,'慢性胃炎':2,'皮肤过敏':2,'肾移植后':2,'痰多':2,'哮喘':2,'腰肌劳损':2,'自闭症':2,'痤疮':1,'打隔':1,'肚子咕噜':1,'肤色不均':1,'肝囊肿':1,'感觉有点冷，就拉肚子':1,'干燥症':1,'肛门口湿':1,'骨质增生':1,'关节炎':1,'急性肠胃炎':1,'甲亢':1,'精神问题':1,'颈动脉及下肢动脉斑块':1,'咳嗽':1,'口渴':1,'内痔':1,'尿酸高':1,'皮肤油脂分泌旺盛':1,'贫血':1,'腔隙性脑梗':1,'肾病初期':1,'胃病':1,'腺癌':1,'心包积液':1,'心律不齐':1,'心率缓':1,'心脏预激综合征':1,'牙龈出血':1,'牙龈肿痛':1,'腰间盘突出':1,'抑郁':1,'有食欲但进食少':1,'孕期':1,'早上起来腹痛要大便':1,'胀气':1,'嘴周长痘':1}

wc.generate_from_frequencies(txt_freq)

plt.imshow(wc)
plt.axis("off")

plt.figure()

wc.to_file("C:\\Users\\sunhp\\Desktop\\a.png")