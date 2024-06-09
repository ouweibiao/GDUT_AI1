import numpy as np
import cv2 as cv

im1 = cv.imread('sift\\p1.png')
im2 = cv.imread('sift\\p2.png')

sift = cv.SIFT_create()
kp1, des1 = sift.detectAndCompute(im1, None)
kp2, des2 = sift.detectAndCompute(im2, None)

bf = cv.BFMatcher()
matches = bf.knnMatch(des1, des2, k=2)

ratio = 0.5
good_matches = []
for m, n in matches:
    if m.distance < ratio * n.distance:
        good_matches.append(m)

total_distance = 0
for match in good_matches:
    total_distance += match.distance

avg_distance = total_distance / len(good_matches) if good_matches else 0

print(f"平均欧式距离: {avg_distance:.2f}")

match_img = cv.drawMatches(im1, kp1, im2, kp2, good_matches, None, flags=2)
cv.imwrite('result\\matches.png', match_img)
