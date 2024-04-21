#
# Part IV. Pull Request (PR)
#

#
# 在这一部分，我们提交 PR。
#
# 0. 你应该以 root 用户登录宿主系统，如：
#    ssh root@192.168.56.102 # instead of your own IP address
# 1. 将作业以 PR 的形式提交。
#

whoami # root

cd # /root

cat > ~/tf/part-4.txt << "EOF"
        __        __   _
        \ \      / /__| | ___ ___  _ __ ___   ___
         \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \
          \ V  V /  __/ | (_| (_) | | | | | |  __/
           \_/\_/ \___|_|\___\___/|_| |_| |_|\___|

                           _
                          | |_ ___
                          | __/ _ \
                          | || (_) |
                           \__\___/

             ____            _       ___ __     __
            |  _ \ __ _ _ __| |_    |_ _|\ \   / /
            | |_) / _` | '__| __|    | |  \ \ / /
            |  __/ (_| | |  | |_     | |   \ V /
            |_|   \__,_|_|   \__|   |___|   \_/

EOF

cat ~/tf/part-4.txt 1>&2

#
# 请按照视频的指导提交 PR，此处仅列出一些关键步骤以供参考。
#

# 假设您的 git 账号已经正确配置：
##git config --global user.name "your-user-name"
##git config --global user.email "your-email-address-on-gitee"
# 注意要配置成签署 CLA 的用户名和邮箱。

# 我们以 https://gitee.com/glibc/lanzhou_university_2021 仓库为例，
# 假设 https://gitee.com/openeuler-practice-courses/lfs-course
# 已经被 fork 到一个名为 glibc 的账号下。
git clone https://gitee.com/glibc/lanzhou_university_2021.git
cd lanzhou_university_2021/

git status
#On branch master
#Your branch is up to date with 'origin/master'.

git git checkout -b 101010-zhaoxiaohu
#Switched to a new branch '101010-zhaoxiaohu'

git status
#On branch 101010-zhaoxiaohu
#nothing to commit, working tree clean

mkdir 101010-zhaoxiaohu
cd 101010-zhaoxiaohu

touch README.md
vim README.md # Edit it, for instance.

git add ../101010-zhaoxiaohu/

git commit -s -a

git push --set-upstream origin 101010-zhaoxiaohu # The first push

vim README.md # Update it again, for instance.

git commit -s -a

git push origin 101010-zhaoxiaohu # The second, third... push

git log # Review

# 然后在您自己的 gitee 页面提交 PR。
# 在本例中，注意需提交新建的 101010-zhaoxiaohu 分支。



