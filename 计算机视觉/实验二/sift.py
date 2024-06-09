import os
import sys
import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt

# 设置当前工作目录
os.chdir(r'D:\WeChat Files\wxid_f44hm2h9kdox22\FileStorage\File\2024-05\实验二')

# 图像所在文件夹相对路径
imgPath = 'sift\\'
imgList = os.listdir(imgPath)
imgs = []

for imgName in imgList:
    pathImg = os.path.join(imgPath, imgName)
    img = cv.imread(pathImg)
    if img is None:
        print("图片不能读取：" + imgName)

        sys.exit(-1)
    else:
        print("图片读取成功")
    imgs.append(img)

stitcher = cv.Stitcher.create(cv.Stitcher_PANORAMA)
_result, pano = stitcher.stitch(imgs)
if _result == cv.Stitcher_OK:
    cv.imwrite('result1\\p12.png', pano)
    print("拼接完成并成功保存为 'p12.png'")
elif _result == cv.Stitcher_ERR_NEED_MORE_IMGS:
    print("拼接失败：需要更多的图像")
elif _result == cv.Stitcher_ERR_HOMOGRAPHY_EST_FAIL:
    print("拼接失败：无法估计图像之间的单应性矩阵")
elif _result == cv.Stitcher_ERR_CAMERA_PARAMS_ADJUST_FAIL:
    print("拼接失败：无法调整相机参数")
else:
    print("拼接失败：未知原因")





# -------------- 2. 高斯差分 -----------------

im1 = cv.imread('sift\\p1.jpg', cv.IMREAD_GRAYSCALE)
if im1 is None:
    print("无法读取图像 'sift\\p1.jpg'")
    sys.exit(-1)

im1 = im1.astype(np.double)
sz = 7
sig = 3

# 对im1执行高斯模糊
im_gs = cv.GaussianBlur(im1, (sz, sz), sig)

# 高斯差分
im3 = im1 - im_gs

# 将im3的灰度值归一化至[0,255]
im3 = cv.normalize(im3, None, 0, 255, cv.NORM_MINMAX)
im3 = im3.astype(np.uint8)

# 保存结果
cv.imwrite('result1\\s1-g.png', im1.astype(np.uint8))  # 将双精度图像转回8位整数
cv.imwrite('result1\\s1-gs.png', im_gs.astype(np.uint8))
cv.imwrite('result1\\s1-cf.png', im3)

print("高斯差分处理完成并成功保存结果")

# --------------- 3. SIFT特征点 ---------------
sift = cv.SIFT_create()
im1 = cv.imread('sift\\p1.jpg')
im2 = cv.imread('sift\\p2.jpg')

if im1 is None or im2 is None:
    print("无法读取图像 'sift\\p1.jpg' 或 'sift\\p2.jpg'")
    sys.exit(-1)

# 获取各个图像的特征点及SIFT特征向量
# 返回值kp包含SIFT特征的方向、位置、大小等信息
# des的shape为 (sift_num, 128)，sift_num表示图像检测到的SIFT特征数量
(kp1, des1) = sift.detectAndCompute(im1, None)
(kp2, des2) = sift.detectAndCompute(im2, None)

# 绘制特征点，并显示为红色圆圈
sift_1 = cv.drawKeypoints(im1, kp1, None, color=(255, 0, 255))
sift_2 = cv.drawKeypoints(im2, kp2, None, color=(255, 0, 255))

cv.imwrite('result1\\sift_1.jpg', sift_1)
cv.imwrite('result1\\sift_2.jpg', sift_2)

# -------------- 4. 特征点匹配 -----------------
# 特征点匹配
# K近邻算法求取在空间中距离最近的K个数据点，并将这些数据点归为一类
bf = cv.BFMatcher()
matches1 = bf.knnMatch(des1, des2, k=2)

# 调整ratio
# ratio=0.4：对于准确度要求高的匹配；
# ratio=0.6：对于匹配点数目要求比较多的匹配；
# ratio=0.5：一般情况下。
ratio1 = 0.5
good1 = []

for m1, n1 in matches1:
    # 如果最接近和次接近的比值大于一个既定的值，那么我们保留这个最接近的值，认为它和其匹配的点为good_match
    if m1.distance < ratio1 * n1.distance:
        good1.append([m1])

match_result1 = cv.drawMatchesKnn(im1, kp1, im2, kp2, good1, None, flags=2)
cv.imwrite("result1\\sift_1-2.png", match_result1)

print("特征点检测和匹配完成，并成功保存结果")




















































#
