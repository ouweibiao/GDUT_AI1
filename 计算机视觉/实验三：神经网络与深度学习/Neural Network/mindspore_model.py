#!/usr/bin/env python
# coding: utf-8

# [![在OpenI运行](https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/website-images/r1.10/resource/_static/logo_openi.png)](https://openi.pcl.ac.cn/MindSpore/docs/src/branch/r1.10/tutorials/source_zh_cn/beginner/model.ipynb?card=2&image=MindSpore1.8.1)&emsp;[![下载Notebook](https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/website-images/r1.10/resource/_static/logo_notebook.png)](https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/notebook/r1.10/tutorials/zh_cn/beginner/mindspore_model.ipynb)&emsp;[![下载样例代码](https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/website-images/r1.10/resource/_static/logo_download_code.png)](https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/notebook/r1.10/tutorials/zh_cn/beginner/mindspore_model.py)&emsp;[![查看源文件](https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/website-images/r1.10/resource/_static/logo_source.png)](https://gitee.com/mindspore/docs/blob/r1.10/tutorials/source_zh_cn/beginner/model.ipynb)
# 
# [基本介绍](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/introduction.html) || [快速入门](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/quick_start.html) || [张量 Tensor](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/tensor.html) || [数据集 Dataset](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/dataset.html) || [数据变换 Transforms](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/transforms.html) || **网络构建** || [函数式自动微分](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/autograd.html) || [模型训练](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/train.html) || [保存与加载](https://www.mindspore.cn/tutorials/zh-CN/r1.10/beginner/save_load.html)

# # 网络构建

# 神经网络模型是由神经网络层和Tensor操作构成的，`mindspore.nn`提供了常见神经网络层的实现，在MindSpore中，`Cell`类是构建所有网络的基类，也是网络的基本单元。一个神经网络模型表示为一个`Cell`，它由不同的子`Cell`构成。使用这样的嵌套结构，可以简单地使用面向对象编程的思维，对神经网络结构进行构建和管理。
# 
# 下面我们将构建一个用于Mnist数据集分类的神经网络模型。

# In[1]:


import mindspore
from mindspore import nn, ops


# ## 定义模型类
# 
# 当我们定义神经网络时，可以继承`nn.Cell`类，在`__init__`方法中进行子Cell的实例化和状态管理，在`construct`方法中实现Tensor操作。
# 
# > `construct`意为神经网络（计算图）构建，相关内容详见[计算图](https://www.mindspore.cn/tutorials/zh-CN/r1.10/advanced/compute_graph.html)。

# In[2]:


class Network(nn.Cell):
    def __init__(self):
        super().__init__()
        self.flatten = nn.Flatten()
        self.dense_relu_sequential = nn.SequentialCell(
            nn.Dense(28*28, 512),
            nn.ReLU(),
            nn.Dense(512, 512),
            nn.ReLU(),
            nn.Dense(512, 10)
        )
    
    def construct(self, x):
        x = self.flatten(x)
        logits = self.dense_relu_sequential(x)
        return logits


# 构建完成后，实例化`Network`对象，并查看其结构。


model = Network()
print(model)
print('模型架构如上')


# 我们构造一个输入数据，直接调用模型，可以获得一个10维的Tensor输出，其包含每个类别的原始预测值。
# 
# > `model.construct()`方法不可直接调用。


X = ops.ones((1, 28, 28), mindspore.float32)
logits = model(X)
print(logits)
print('构造输入数据并调用模型')


# 在此基础上，我们通过一个`nn.Softmax`层实例来获得预测概率。


pred_probab = nn.Softmax(axis=1)(logits)
y_pred = pred_probab.argmax(1)
print(f"Predicted class: {y_pred}")
print('使用Softmax层获得预测概率')


# ## 模型层
# 
# 本节中我们分解上节构造的神经网络模型中的每一层。首先我们构造一个shape为(3, 28, 28)的随机数据（3个28x28的图像），依次通过每一个神经网络层来观察其效果。



input_image = ops.ones((3, 28, 28), mindspore.float32)
print(input_image.shape)



# ### nn.Flatten
# 
# 实例化`nn.Flatten`层，将28x28的2D张量转换为784大小的连续数组。



flatten = nn.Flatten()
flat_image = flatten(input_image)
print(flat_image.shape)


# ### nn.Dense
# 
# `nn.Dense`为全连接层，其使用权重和偏差对输入进行线性变换。

# In[8]:


layer1 = nn.Dense(in_channels=28*28, out_channels=20)
hidden1 = layer1(flat_image)
print(hidden1.shape)
print('dense')


# ### nn.ReLU
# 
# `nn.ReLU`层给网络中加入非线性的激活函数，帮助神经网络学习各种复杂的特征。


print(f"Before ReLU: {hidden1}\n\n")
hidden1 = nn.ReLU()(hidden1)
print(f"After ReLU: {hidden1}")


# ### nn.SequentialCell
# 
# `nn.SequentialCell`是一个有序的Cell容器。输入Tensor将按照定义的顺序通过所有Cell。我们可以使用`SequentialCell`来快速组合构造一个神经网络模型。



seq_modules = nn.SequentialCell(
    flatten,
    layer1,
    nn.ReLU(),
    nn.Dense(20, 10)
)

logits = seq_modules(input_image)
print(logits.shape)
print('seq在这')


# ### nn.Softmax
# 
# 最后使用`nn.Softmax`将神经网络最后一个全连接层返回的logits的值缩放为\[0, 1\]，表示每个类别的预测概率。`axis`指定的维度数值和为1。



softmax = nn.Softmax(axis=1)
pred_probab = softmax(logits)
print(pred_probab)
print("softmax")


# ## 模型参数
# 
# 网络内部神经网络层具有权重参数和偏置参数（如`nn.Dense`），这些参数会在训练过程中不断进行优化，可通过 `model.parameters_and_names()` 来获取参数名及对应的参数详情。



print(f"Model structure: {model}\n\n")

for name, param in model.parameters_and_names():
    print(f"Layer: {name}\nSize: {param.shape}\nValues : {param[:2]} \n")


# 更多内置神经网络层详见[mindspore.nn API](https://www.mindspore.cn/docs/zh-CN/r1.10/api_python/mindspore.nn.html)。





