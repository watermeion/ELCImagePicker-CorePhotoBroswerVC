//
//  GBImagePickerBehavior.h
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/7/29.
//  Copyright (c) 2015年 netease. All rights reserved.
//


/**
 *  建立一个照片选择器类
 */
@import Foundation;
#import "GBBehavior.h"


@protocol GBImagePickerBehaviorDataTargetDelegate <NSObject>

/**
 *  用于从ImagePickerBehavior 传递结果给delegate
 *
 *  @param imageArray 
 */
- (void)imagePickerBehaviorSelectedImages:(NSArray *) imageArray;


@optional
/**
 *  用于delegate 控制每次选择照片的数量
 *
 *  @return 本次照片选择的数量
 */
- (NSUInteger)limitNumSelectionforThisImagePicker;

@end



//! obviously NS_OPTIONS would be better, but it's harder to expose that in XIB
typedef  NS_ENUM(NSUInteger, GBImagePickerBehaviourSourceType){
    GBImagePickerBehaviourSourceTypeBoth = 0,
    GBImagePickerBehaviourSourceTypeCamera = 1,
    GBImagePickerBehaviourSourceTypeLibrary = 2,
};


//! Generates UIControlEventValueChanged when image is selected
@interface GBImagePickerBehavior : GBBehavior 

//! source type to use IBInspectable 表示可以在Interface Builder 中计算
@property(nonatomic, assign) IBInspectable NSInteger sourceType;


@property (nonatomic, weak) IBOutlet id<GBImagePickerBehaviorDataTargetDelegate>  delegate;

//! image view to assign selected image to
@property(nonatomic, weak) IBOutlet UIImageView *targetImageView;

//- (IBAction)pickImageFromButton:(UIButton *)sender;

- (IBAction)pickImageAction:(id) sender;

//添加控制可选择显示照片数量的属性
@property (nonatomic, assign) IBInspectable NSUInteger limitPhotoNum;



@end
