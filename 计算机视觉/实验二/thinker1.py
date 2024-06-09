import os
import sys
import cv2 as cv

# 设置当前工作目录
os.chdir('D:\\WeChat Files\\wxid_f44hm2h9kdox22\\FileStorage\\File\\2024-05\\实验二')

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
    imgs.append(img)

stitcher = cv.Stitcher.create(cv.Stitcher_PANORAMA)
_result, pano = stitcher.stitch(imgs)
if _result == cv.Stitcher_OK:
    cv.imwrite('result1\\pano.png', pano)
    print("拼接完成并成功保存为 'pano.png'")
else:
    print("拼接失败：需要更多的图像或图像内容不足")



