//
//  GBALbumPickerCollectionViewController.h
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/8/1.
//  Copyright (c) 2015年 netease. All rights reserved.
//
/**
 *  修改ELCALbumPickController 的ELCAssetTablePicker  为 GBALubumPickerCollectionViewController 
 *  利用collection  实现
 *
 */
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"

@interface GBALbumPickerCollectionViewController : UICollectionViewController <ELCAssetPickerFilterDelegate>

@property (nonatomic, weak) id <ELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, assign) BOOL immediateReturn;
@property (nonatomic, assign) BOOL singleSelection;
// optional, can be used to filter the assets displayed
@property(nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

- (int)totalSelectedAssets;
- (void)preparePhotos;

- (void)doneAction:(id)sender;


@end
