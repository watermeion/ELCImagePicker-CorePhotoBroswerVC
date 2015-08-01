//
//  GBALbumPickerCollectionViewCell.m
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/8/1.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "GBALbumPickerCollectionViewCell.h"
#import "ELCAsset.h"
#import "ELCConsole.h"
#import "ELCOverlayImageView.h"

@interface GBALbumPickerCollectionViewCell ()


//@property (nonatomic, strong) NSArray *rowAssets;
//@property (nonatomic, strong) NSMutableArray *imageViewArray;
//@property (nonatomic, strong) NSMutableArray *overlayViewArray;


@property (nonatomic, assign) BOOL isSelected;



@end

@implementation GBALbumPickerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    if (self) {
        self.isSelected = NO;
        //        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        //        [self addGestureRecognizer:tapRecognizer];

        //        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:1];
        //        self.imageViewArray = mutableArray;
        //
        //        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        //        self.overlayViewArray = overlayArray;
    }
}


//- (void)setAssets:(NSArray *)assets
//{
//    self.rowAssets = assets;
//    for (UIImageView *view in _imageViewArray) {
//        [view removeFromSuperview];
//    }
//    for (ELCOverlayImageView *view in _overlayViewArray) {
//        [view removeFromSuperview];
//    }
//    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
//    UIImage *overlayImage = nil;
//    for (int i = 0; i < [_rowAssets count]; ++i) {
//
//        ELCAsset *asset = [_rowAssets objectAtIndex:i];
//
//        if (i < [_imageViewArray count]) {
//            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
//            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
//        } else {
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
//            [_imageViewArray addObject:imageView];
//        }
//
//        if (i < [_overlayViewArray count]) {
//            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
//            overlayView.hidden = asset.selected ? NO : YES;
//            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
//        } else {
//            if (overlayImage == nil) {
//                overlayImage = [UIImage imageNamed:@"mask.png"];
//            }
//            ELCOverlayImageView *overlayView = [[ELCOverlayImageView alloc] initWithImage:overlayImage];
//            [_overlayViewArray addObject:overlayView];
//            overlayView.hidden = asset.selected ? NO : YES;
//            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
//        }
//    }
//}

- (IBAction)selectedBtnAction:(id)sender {
    //修改Button UI

    if (!self.isSelected) {
        [self.selectedBtn setImage:[UIImage imageNamed:@"ic_check_state"] forState:UIControlStateNormal];
        self.isSelected = YES;
    }else {
        [self.selectedBtn setImage:[UIImage imageNamed:@"ic_check"] forState:UIControlStateNormal];
        self.isSelected = NO;
    }
    
    //完成选择动作
    self.thisELCAsset.selected = !self.thisELCAsset.selected;
    if (self.thisELCAsset.selected) {
        self.thisELCAsset.index = [[ELCConsole mainConsole] numOfSelectedElements];
        [[ELCConsole mainConsole] addIndex:self.thisELCAsset.index];
    }
    else
    {
        int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
        [[ELCConsole mainConsole] removeIndex:lastElement];
    }
}
@end
