---
title: Keras Model类中的常用方法
date: 2019-09-17 16:48:28
tags: deep learning
categories: deep learning
---

近一个月来，我都在阅读Keras之父著作的《Python深度学习》一书。书中最常使用的便是Keras的Model类。

通过查阅官方文档和Model类源码，本文将Keras Model类中的常用方法进行了梳理和总结。

<!--more-->

### compile

用于配置训练模型。

### fit

以给定数量的轮次（数据集上的迭代）训练模型。

**返回**

一个 `History` 对象。其 `History.history` 属性是连续 epoch 训练损失和评估值，以及验证集损失和评估值的记录（如果适用）。

### evaluate

```python
evaluate(self,
         x=None,
         y=None,
         batch_size=None,
         verbose=1,
         sample_weight=None,
         steps=None,
         callbacks=None,
         max_queue_size=10,
         workers=1,
         use_multiprocessing=False)
```

在测试模式下返回模型的误差值和评估标准值。

计算是分批进行的。

### summary

```python
# 继承自Network类
summary(self, line_length=None, positions=None, print_fn=None)
```

打印网络的总结信息。

```
line_length: Total length of printed lines
    (e.g. set this to adapt the display to different
    terminal window sizes).
positions: Relative or absolute positions of log elements
    in each line. If not provided,
    defaults to `[.33, .55, .67, 1.]`.
print_fn: Print function to use.
    It will be called on each line of the summary.
    You can set it to a custom function
    in order to capture the string summary.
    It defaults to `print` (prints to stdout).
```

### predict

为输入样本生成输出预测。

计算是分批进行的

### predict_classes

```python
# 子类Sequential中的方法
predict_classes(self, x, batch_size=32, verbose=0)
```

为输入样本生成**类别**预测。

计算是分批进行的

**参数**

* **x**: 输入数据，Numpy 数组 （或者 Numpy 数组的列表，如果模型有多个输出）。

* **batch_size**: 批量大小。如未指定，默认为 32。
* **verbose**: 日志显示模式，0 或 1。

### save

函数原型：

```python
# 继承自Network类
save(self, filepath, overwrite=True, include_optimizer=True)
```

将模型保存到一个HDF5文件中。

示例：

```python
from keras.models import load_model

...
model.save('my_model.h5')  # creates a HDF5 file 'my_model.h5'
del model  # deletes the existing model

# returns a compiled model
# identical to the previous one
model = load_model('my_model.h5')
```

### save_weights

函数原型：

```python
# 继承自Network类
save_weights(self, filepath, overwrite=True)
```

将各层的权重存储到HDF5文件中。

```
filepath: String, path to the file to save the weights to.
overwrite: Whether to silently overwrite any existing file at the
    target location, or provide the user with a manual prompt.
```

### load_weights

函数原型：

```python
# 继承自Network类
load_weights(self, filepath, by_name=False, skip_mismatch=False, reshape=False)
```

###  get_layer

```python
# 继承自Network类
get_layer(self, name=None, index=None)
```

根据名称（唯一）或索引值查找网络层。

如果同时提供了 `name` 和 `index`，则 `index` 将优先。索引值来自于水平图遍历的顺序（自下而上）。

> Keras Model类中文文档 https://keras.io/zh/models/model/#model
>
>  Model类源码 https://github.com/keras-team/keras/blob/master/keras/engine/training.py