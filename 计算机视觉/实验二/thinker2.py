import numpy as np
import cv2 as cv

def generate_gaussian_pyramid(img, num_octaves, sigma=1.6, k=np.sqrt(2)):
    gaussian_pyramid = []
    for octave in range(num_octaves):
        gaussian_octave = []
        for level in range(6):
            if octave == 0 and level == 0:
                gaussian_img = img
            elif level == 0:
                gaussian_img = cv.pyrDown(gaussian_pyramid[octave-1][-3])
            else:
                gaussian_img = cv.GaussianBlur(gaussian_octave[level-1], (0, 0), sigma * (k ** (level - 1)))
            gaussian_octave.append(gaussian_img)
        gaussian_pyramid.append(gaussian_octave)
    return gaussian_pyramid

def generate_dog_pyramid(gaussian_pyramid):
    dog_pyramid = []
    for gaussian_octave in gaussian_pyramid:
        dog_octave = []
        for i in range(1, len(gaussian_octave)):
            dog_img = cv.subtract(gaussian_octave[i], gaussian_octave[i-1])
            dog_octave.append(dog_img)
        dog_pyramid.append(dog_octave)
    return dog_pyramid

def find_extrema(dog_pyramid, num_octaves):
    keypoints = []
    for o in range(num_octaves):
        for i in range(1, len(dog_pyramid[o]) - 1):
            for x in range(1, dog_pyramid[o][i].shape[0] - 1):
                for y in range(1, dog_pyramid[o][i].shape[1] - 1):
                    patch = [dog_pyramid[o][i-1][x-1:x+2, y-1:y+2],  # Accessing elements separately
                             dog_pyramid[o][i][x-1:x+2, y-1:y+2],
                             dog_pyramid[o][i+1][x-1:x+2, y-1:y+2]]
                    if np.amax(patch) == dog_pyramid[o][i][x, y] or np.amin(patch) == dog_pyramid[o][i][x, y]:
                        keypoints.append((o, i, x, y))
    return keypoints


img = cv.imread('sift\\p1.png', cv.IMREAD_GRAYSCALE)
num_octaves = 5
gaussian_pyramid = generate_gaussian_pyramid(img, num_octaves)
dog_pyramid = generate_dog_pyramid(gaussian_pyramid)

for octave in range(num_octaves):
    cv.imwrite(f'result\\gaussian_octave_{octave+1}_level_1.png', gaussian_pyramid[octave][0])
    cv.imwrite(f'result\\dog_octave_{octave+1}_level_1.png', dog_pyramid[octave][0])

img_color = cv.imread('sift\\p1.png')
extrema = find_extrema(dog_pyramid, num_octaves)
colors = [(0, 0, 255), (0, 255, 0), (255, 0, 0), (255, 0, 255), (0, 255, 255)]

for (o, i, x, y) in extrema:
    color = colors[o % len(colors)]  # Adjust color selection
    cv.circle(img_color, (y, x), 2, color, -1)  # Correct order of (x, y)

cv.imwrite('result\\keypoints.png', img_color)
