//
//  GBImagePickerBehavior.m
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/7/29.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "GBImagePickerBehavior.h"
#import "ELCImagePickerController.h"
#import "UIActionSheet+BlocksKit.h"


@interface GBImagePickerBehavior () <UINavigationControllerDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>


@end




@implementation GBImagePickerBehavior
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)pickImageAction:(id)sender
{
    [self pickImageFromButton:sender];
}


//实现的button Touch 方法
- (void)pickImageFromButton:(UIButton *)sender{
    //弹出UIAction让用户选择是拍照 还是从相册中选取
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];


    //判断设备支持的图片来源：如果设备支持Camera  或者 自定义设置的 SourceType 支持camera 则actionsheet 显示“拍照”
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && (self.sourceType == GBImagePickerBehaviourSourceTypeBoth || self.sourceType == GBImagePickerBehaviourSourceTypeCamera)) {
        [actionSheet bk_addButtonWithTitle:NSLocalizedString(@"拍照", nil) handler:^{
            NSLog(@"touch 'choose from album'");
            [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
    }

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && (self.sourceType == GBImagePickerBehaviourSourceTypeBoth || self.sourceType == GBImagePickerBehaviourSourceTypeLibrary)) {

        [actionSheet bk_addButtonWithTitle:NSLocalizedString(@"从相册中选择", nil) handler:^{
            NSLog(@"touch 'take Photo'");
            [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
    }
    [actionSheet bk_setCancelButtonWithTitle:NSLocalizedString(@"取消", nil) handler:nil];
    [actionSheet showFromRect:sender.frame inView:sender.superview animated:YES];
}

- (void)showPickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImagePickerController *controller = [UIImagePickerController new];
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
        controller.sourceType = sourceType;
        controller.delegate = self;

        //  AssertTrueOrReturn([self.owner isKindOfClass:UIViewController.class]);
        [self.owner presentViewController:controller animated:YES completion:nil];

    }else if(sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        
        // Create the image picker
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];

        elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        //  elcPicker.onOrder = YES;å //For multiple image selection, display and return selected order of images
        elcPicker.imagePickerDelegate = self;

         //  AssertTrueOrReturn([self.owner isKindOfClass:UIViewController.class]);
        //Present modally
        [self.owner presentViewController:elcPicker animated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(limitNumSelectionforThisImagePicker)]) {
                NSUInteger limitNum = [self.delegate limitNumSelectionforThisImagePicker];
                    elcPicker.maximumImagesCount = limitNum;
            }
            else {
                elcPicker.maximumImagesCount = self.limitPhotoNum?:1; //Set the maximum number of images to select, defaults to 4
            }
        }];
    }
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.targetImageView.image = image;

    NSArray *selectedImageArray = [self imagePickerConvertImagesFromTakePhoto:info];


    //根据Info的照片信息，选择好的图片
    [self.delegate imagePickerBehaviorSelectedImages:selectedImageArray];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {

    [picker dismissViewControllerAnimated:YES completion:^{
     //选择之后做什么

        
    }];
    NSLog(@"%@",info);


    NSArray *selectedImageArray = [self imagePickerConvertImagesFromResultsInfoDictionary:info];


//根据Info的照片信息，选择好的图片
    [self.delegate imagePickerBehaviorSelectedImages:selectedImageArray];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{

    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (NSArray *)imagePickerConvertImagesFromTakePhoto:(NSDictionary *) info{
    if (info == nil ) {
        return nil;
    }
    NSMutableArray *resultsImageAttay = [NSMutableArray new];
    id imageObject = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (imageObject !=nil && [imageObject isKindOfClass:[UIImage class]]) {
        [resultsImageAttay addObject:imageObject];
    }
    return [resultsImageAttay copy];
}



/**
 *  从Info 字典中解析出所要的ImageArray;
 *
 *  @param info ImagePickerController 返回的 Info 字典
 *
 *  @return 所选择的ImageArray
 */
- (NSArray *)imagePickerConvertImagesFromResultsInfoDictionary: (NSDictionary *) info
{
    if (info == nil ) {
        return nil;
    }
    NSMutableArray *resultsImageAttay = [NSMutableArray new];
     //从中解析出UImage
    for (NSDictionary *dict in info) {
        id imageObject = [dict objectForKey:@"UIImagePickerControllerOriginalImage"];
        if (imageObject !=nil && [imageObject isKindOfClass:[UIImage class]]) {
            [resultsImageAttay addObject:imageObject];
        }
    }
    return [resultsImageAttay copy];
}


@end
