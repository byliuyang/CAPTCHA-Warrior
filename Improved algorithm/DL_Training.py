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

########### load all the testing dataset and testing labels
DL=loadmat('DL_label_30000.mat')
DATA_SIZE=30000
digit_label=DL['digit_label']
str_label=DL['str_label']
root_dir = 'images30000/'
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


########### Using adam to optimize the loss
adam = optimizers.Adam(lr=0.0001, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.002)


########### Define the CNN model
input_tensor = Input((50, 100,1))
x = input_tensor
for i in range(1,4):
    x = Conv2D(32*i, (3, 3),init='uniform',activation='relu')(x)
    x = Dropout(0.5)(x)
    x = MaxPooling2D((2, 2))(x)
x = Flatten()(x)
x = Dropout(0.25)(x)
x = [Dense(36, activation='softmax', name='c%d'%(i+1))(x) for i in range(4)]
model = Model(input=input_tensor, output=x)
model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])


########### Plot the learning curve             
history=model.fit(X,{'c1':labels_1,'c2':labels_2,'c3':labels_3,'c4':labels_4} ,epochs=100, batch_size=64, validation_split=0.10)
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')


########### Save the model
DL_history_30000=history.history
savemat('DL_history_30000',DL_history_30000)
plt.show()
model.save('DL_model3_30000.h5')


