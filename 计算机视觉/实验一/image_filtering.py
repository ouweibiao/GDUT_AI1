import numpy as np
import cv2
import math

# 平均平滑滤波器
averageKernel = np.array([[1/9, 1/9, 1/9],
                          [1/9, 1/9, 1/9],
                          [1/9, 1/9, 1/9]]).astype(np.float32)

# 高斯平滑滤波器
weightedAverageKernel = np.array([[1/16, 2/16, 1/16],
                                  [2/16, 4/16, 2/16],
                                  [1/16, 2/16, 1/16]]).astype(np.float32)

# 锐化滤波器
laplacianKernel = np.array([[0.0, -1.0, 0.0],
                            [-1.0, 5.0, -1.0],
                            [0.0, -1.0, 0.0]]).astype(np.float32)

def getGrayImg(img):
    return cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

def paddingWithZero(img):
    return np.pad(img, ((1, 1), (1, 1)), 'constant', constant_values=0)

def paddingWithNeighbor(img):
    return np.pad(img, ((1, 1), (1, 1)), 'edge')

def Filtering2D(img, filter):
    filtered_img = np.zeros((img.shape[0] - 2, img.shape[1] - 2), np.uint8)
    img = img.astype(np.float32)
    for i in range(0, filtered_img.shape[0]):
        for j in range(0, filtered_img.shape[1]):
            pixel = np.sum(img[i:i+3, j:j+3] * filter)
            filtered_img[i][j] = np.clip(pixel, 0.0, 255.0).astype(np.uint8)
    return filtered_img

def denoisewithOrderStatisticsFilter(img, method='median'):
    filtered_img = np.zeros((img.shape[0] - 2, img.shape[1] - 2), np.uint8)
    for i in range(0, filtered_img.shape[0]):
        for j in range(0, filtered_img.shape[1]):
            region = img[i:i+3, j:j+3]
            if method == 'median':
                pixel = np.median(region)
            elif method == 'mean':
                pixel = np.min(region)
            elif method == 'min':
                pixel = np.min(region)
            elif method == 'max':
                pixel = np.max(region)
            filtered_img[i][j] = pixel
    return filtered_img

def getPSNR(ori_img, en_img):
    MSE = np.mean((ori_img.astype(np.float32) - en_img.astype(np.float32)) ** 2)
    if MSE == 0:
        return float('inf')
    PSNR = 10 * math.log10(255**2 / MSE)
    return PSNR

if __name__ == '__main__':
    # 1. 对图像进行低通滤波平滑
    img = cv2.imread("test/1_smooth.jpg")
    img = getGrayImg(img)
    cv2.imshow('original image', img)
    img_padding = paddingWithNeighbor(img)
    filtered_img = Filtering2D(img_padding, weightedAverageKernel)
    cv2.imshow('filtered image', filtered_img)
    cv2.imwrite("1_enhanced.jpg", filtered_img)

    # 2. 对平滑后的图像进行高通滤波锐化并查看结果
    img = cv2.imread("test/3.jpg")
    img = getGrayImg(img)
    cv2.imshow('original image', img)
    img_padding = paddingWithNeighbor(img)
    filtered_img = Filtering2D(img_padding, laplacianKernel)
    cv2.imshow('sharpened image', filtered_img)
    cv2.imwrite("3_sharpened.jpg", filtered_img)

    # 3. 对含有椒盐噪声的图像使用不同的顺序统计滤波器去噪
    # 中值滤波
    img = cv2.imread("test/2.jpg", cv2.IMREAD_GRAYSCALE)
    cv2.imshow('original image', img)
    filtered_img = cv2.medianBlur(img, 3)
    cv2.imshow('denoised image with median filter', filtered_img)
    cv2.imwrite("2_denoised_median.jpg", filtered_img)

    # 最小值滤波
    img = cv2.imread("test/419.jpeg", cv2.IMREAD_GRAYSCALE)
    cv2.imshow('original image', img)
    img_padding = paddingWithZero(img)
    filtered_img = denoisewithOrderStatisticsFilter(img_padding, method='min')
    cv2.imshow('denoised image with minimum filter', filtered_img)
    cv2.imwrite("419_denoised_min.jpg", filtered_img)

    # 最大值滤波
    img = cv2.imread("test/421.jpeg", cv2.IMREAD_GRAYSCALE)
    cv2.imshow('original image', img)
    img_padding = paddingWithZero(img)
    filtered_img = denoisewithOrderStatisticsFilter(img_padding, method='max')
    cv2.imshow('denoised image with maximum filter', filtered_img)
    cv2.imwrite("421_denoised_max.jpg", filtered_img)

    cv2.waitKey(0)
    cv2.destroyAllWindows()
    print("PSNR:", getPSNR(img, filtered_img))
