//
//  GBALbumPickerCollectionViewCell.h
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/8/1.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAsset.h"
@interface GBALbumPickerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gbImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
- (IBAction)selectedBtnAction:(id)sender;


@property (nonatomic, strong) ELCAsset *thisELCAsset;
@end
