#ELCImagePicker+CorePhotoBroswer  

[TOC]

## 一、 简介
    本项目是由watermeion[http://watermeion.github.io]集成的IOS图片选择组件,项目中用到了：
     1. https://github.com/nsdictionary/CorePhotoBroswerVC
     2. https://github.com/B-Sides/ELCImagePickerController
     
     Note:
     1. 修改ELCImagePickerController中Picker实现，利用collectionView 实现照片选择 
     2. 适配不同尺寸的机型
     


## 二、 具体用法

     见https://github.com/B-Sides/ELCImagePickerController 用法
     

```// Create the image picker```

```ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];```

```elcPicker.maximumImagesCount = 4; //Set the maximum number of images to select, defaults to 4```
```elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage```
```elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information```
```elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images ```
```elcPicker.imagePickerDelegate = self;```

//Present modally
[self presentViewController:elcPicker animated:YES completion:nil];

// Release if not using ARC
[elcPicker release];





