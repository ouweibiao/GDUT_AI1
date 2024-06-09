import cv2
import numpy as np
import math
import matplotlib.pyplot as plt

def getGrayImg(img):
    gray = np.zeros((img.shape[0], img.shape[1]), np.uint8)
    timg = img.astype(np.float32)
    for i in range(timg.shape[0]):
        for j in range(timg.shape[1]):
            # R*0.299 + G*0.587 + B*0.114
            gray_intensity = timg[i][j][0]*0.114 + timg[i][j][1]*0.587  + timg[i][j][2]*0.299
            gray[i][j] = np.round(gray_intensity).astype(np.uint8)
    return gray


def get_histogram(gray_img):
    # 利用hash table实现统计直方图
    # 注意统计范围较大，使用int32类型numpy array
    Pr = np.zeros(256, np.int32) # Hash Table
    for i in range(gray_img.shape[0]):
        for j in range(gray_img.shape[1]):
            # ###### 1. 这里编程实现直方图统计 ##########
            #
            #
            #
            # ############## 结束编程 #############
            pass

    # ###### 2. 归一化直方图，获得概率分布计 ##########
    #
    #
    #
    # ############## 结束编程 #############
    pass

    S =  np.zeros(256, np.float32)
    pre_sum = 0 # 提示1
    for i in range(256):
        # ###### 3. 获得累积概率分布 ##########
        #
        #
        #
        # ############## 结束编程 #############
        pass

    S = S * 255

    S = np.round(S).astype(np.uint8)
    Ps = np.zeros(256, np.float32)

    for i in range(256):
        # 提示线索
        Ps[S[i]] = Ps[S[i]] + Pr[S[i]]

    return S, Ps


def image_equalization(img, S):
    img_eq = np.zeros((img.shape[0], img.shape[1]), np.uint8)
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            # ###### 实现像素值的重映射 ##########
            #
            #
            #
            # ############## 结束编程 #############
            pass
    return img_eq


def getPSNR(ori_img, en_img):
    MAX = 255.0
    total = 0.0
    for i in range(ori_img.shape[0]):
        for j in range(ori_img.shape[1]):
            total = total + (ori_img[i][j] - en_img[i][j])**2
    MSE = total / (ori_img.shape[0] * ori_img.shape[1])
    PSNR = 10 * math.log(MAX * MAX / MSE, 10)
    return PSNR


if __name__ == '__main__':
    img = cv2.imread("test/Lena.jpg")
    gray = getGrayImg(img)
    S, Ps = get_histogram(gray)
    img_eq = image_equalization(gray, S)
    psnr = getPSNR(gray, img_eq)
    print(psnr)
    cv2.imwrite("LenaRGBLow1_enhanced.jpg", img_eq)
    # visualization
    plt.figure()
    plt.suptitle('Histo Eq. Result')
    plt.subplot(221)
    plt.imshow(gray, cmap='gray')
    plt.subplot(222)
    plt.imshow(img_eq, cmap='gray')
    plt.subplot(223)
    p1 = gray.reshape(gray.shape[0]*gray.shape[1], )
    plt.hist(p1, 256)
    plt.subplot(224)
    p2 = img_eq.reshape(img_eq.shape[0]*img_eq.shape[1], )
    plt.hist(p2, 256)
    plt.show()
