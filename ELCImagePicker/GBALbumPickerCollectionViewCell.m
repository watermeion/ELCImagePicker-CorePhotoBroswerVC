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

@implementation GBALbumPickerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    if (self) {
    }
}


- (IBAction)selectedBtnAction:(id)sender {

    //完成选择动作
    self.thisELCAsset.selected = !self.thisELCAsset.selected;

    
    if (self.thisELCAsset.selected) {
        self.thisELCAsset.index = [[ELCConsole mainConsole] numOfSelectedElements];
        [[ELCConsole mainConsole] addIndex:self.thisELCAsset.index];
        [self.selectedBtn setImage:[UIImage imageNamed:@"ic_check_state"] forState:UIControlStateNormal];
    }
    else
    {
        int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
        [[ELCConsole mainConsole] removeIndex:lastElement];
        [self.selectedBtn setImage:[UIImage imageNamed:@"ic_check"] forState:UIControlStateNormal];
    }
}
@end
