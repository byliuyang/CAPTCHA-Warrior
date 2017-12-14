# -*- coding: utf-8 -*-
"""
Created on Wed Dec 13 16:53:11 2017

@author: Shaoju Wu
"""
# -*- coding: utf-8 -*-
# coding: utf-8

# In[1]:

import numpy as np
import scipy.io
import keras
from keras.layers import Input, Activation, Dense, Flatten,Dropout
from keras.layers.normalization import BatchNormalization
from keras.models import Model, Sequential
from keras import optimizers
from scipy.io import loadmat
from scipy.io import savemat
from keras.utils.np_utils import to_categorical
from keras.layers.advanced_activations import LeakyReLU, PReLU, ELU
import os
import glob
from skimage import io
import numpy as np
from keras.layers import Conv2D, MaxPooling2D
from keras.models import Model
from keras.preprocessing.image import ImageDataGenerator
from keras.utils import np_utils
import matplotlib.pyplot as plt
from scipy import misc
import h5py
from keras.models import load_model

def number_to_str_label(digit):
########### transform 4 integer labels to 4 characters
    CAPTCHA_map='0123456789abcdefghijklmnopqrstuvwxyz'
    length_num=len(digit)
    str_label=[]
    for num in range(0,length_num):
        label=digit[num]
        
        num_label=[]
        for i in range(0,4):
            for j in range(0,36):
                if(label[i]==j):
                    num_label.append(CAPTCHA_map[j])
        str_label.append(num_label) 
    return str_label   


########### load all the testing dataset and testing labels
DL=loadmat('DL_label_3000_test.mat')
DATA_SIZE=3000
digit_label=DL['digit_label']
str_label=DL['str_label']


########### path of the testing image
root_dir = 'images_test/'
imgs = []
labels = digit_label
for i in range(0, DATA_SIZE):
    img = misc.imread(root_dir+str(i)+'_'+str_label[i]+'.jpg', mode="L")
    img=np.reshape(img,(50,100,1))
    imgs.append(img)    
X = np.array(imgs, dtype='float32')
X=X/255.0


########### transform integer labels to one-hot labels
labels_1 = to_categorical(labels[:,0])
labels_2 = to_categorical(labels[:,1])
labels_3 = to_categorical(labels[:,2])
labels_4 = to_categorical(labels[:,3])


########### load the model and output the prediction results 
base_model=load_model('DL_model3_30000.h5')
digit_pre=np.zeros((DATA_SIZE,4))
pre_acc=np.zeros((DATA_SIZE,1))
[char1,char2,char3,char4]= base_model.predict(X)
digit_pre[:,0]=np.argmax(char1,axis=1)
digit_pre[:,1]=np.argmax(char2,axis=1)
digit_pre[:,2]=np.argmax(char3,axis=1)
digit_pre[:,3]=np.argmax(char4,axis=1)


########### ouput the prediction of four characters 
str_pre=number_to_str_label(digit_pre)
for i in range(0,DATA_SIZE):
    pre_acc[i]=1*np.array_equal(digit_label[i], digit_pre[i])    
test_acc=np.sum(pre_acc)/DATA_SIZE    


########### print out the test accuracy
evaluation = base_model.evaluate(X,{'c1':labels_1,'c2':labels_2,'c3':labels_3,'c4':labels_4}, batch_size=6)
print('test accuracy of first character:'+str(evaluation[5]*100)+'%')
print('test accuracy of second character: '+str(evaluation[6]*100)+'%')
print('test accuracy of third character: '+str(evaluation[7]*100)+'%')
print('test accuracy of forth character: '+str(evaluation[8]*100)+'%')
print('test loss:',evaluation[0])
print('overall test accuracy: ' +str(test_acc*100)+'%')