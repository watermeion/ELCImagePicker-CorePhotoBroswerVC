//
//  GBALbumPickerCollectionViewController.m
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/8/1.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "GBALbumPickerCollectionViewController.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"
#import "ELCConsole.h"
#import "PhotoBroswerVC.h"
#import "GBALbumPickerCollectionViewCell.h"

@interface GBALbumPickerCollectionViewController ()

@end

@implementation GBALbumPickerCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;

    if (self.immediateReturn) {

    } else {
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStylePlain  target:self action:@selector(doneAction:)];
        [self.navigationItem setRightBarButtonItem:doneButtonItem];
        [self.navigationItem setTitle:NSLocalizedString(@"加载中...", nil)];

    }

    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];

    // Register for notifications when the photo library has changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparePhotos) name:ALAssetsLibraryChangedNotification object:nil];

    // Register cell classes
//    [self.collectionView registerClass:[GBALbumPickerCollectionViewCell class] forCellWithReuseIdentifier:@"GBALbumPickerCollectionViewCell"];

      [self.collectionView registerNib:[UINib nibWithNibName:@"GBALbumPickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GBALbumPickerCollectionViewCell"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ELCConsole mainConsole] removeAllIndex];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)preparePhotos
{
    @autoreleasepool {

        [self.elcAssets removeAllObjects];
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {

            if (result == nil) {
                return;
            }

            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [elcAsset setParent:self];

            BOOL isAssetFiltered = NO;
            if (self.assetPickerFilterDelegate &&
                [self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)])
            {
                isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:(ELCAsset*)elcAsset];
            }

            if (!isAssetFiltered) {
                [self.elcAssets addObject:elcAsset];
            }

        }];

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            // scroll to bottom 滚动到最后
            long section = [self numberOfSectionsInCollectionView:self.collectionView] - 1;
            long row = [self collectionView:self.collectionView numberOfItemsInSection:section] - 1;
            if (section >= 0 && row >= 0) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                     inSection:section];
//                [self.collectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];

            }

            [self.navigationItem setTitle:self.singleSelection ? NSLocalizedString(@"选择照片", nil) : NSLocalizedString(@"选择照片", nil)];
        });
    }
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset
{
    NSUInteger selectionCount = 0;
    for (ELCAsset *elcAsset in self.elcAssets) {
        if (elcAsset.selected) selectionCount++;
    }
    BOOL shouldSelect = YES;
    if ([self.parent respondsToSelector:@selector(shouldSelectAsset:previousCount:)]) {
        shouldSelect = [self.parent shouldSelectAsset:asset previousCount:selectionCount];
    }
    return shouldSelect;
}

- (void)doneAction:(id)sender
{
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];

    for (ELCAsset *elcAsset in self.elcAssets) {
        if ([elcAsset selected]) {
            [selectedAssetsImages addObject:elcAsset];
        }
    }
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }
    [self.parent selectedAssets:selectedAssetsImages];
}


- (void)assetSelected:(ELCAsset *)asset
{
    if (self.singleSelection) {

        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset
{
    if (self.immediateReturn){
        return NO;
    }
    return YES;
}

- (void)assetDeselected:(ELCAsset *)asset
{
    if (self.singleSelection) {
        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }

    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset.asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }

    int numOfSelectedElements = [[ELCConsole mainConsole] numOfSelectedElements];
    if (asset.index < numOfSelectedElements - 1) {
        NSMutableArray *arrayOfCellsToReload = [[NSMutableArray alloc] initWithCapacity:1];

        for (int i = 0; i < [self.elcAssets count]; i++) {
            ELCAsset *assetInArray = [self.elcAssets objectAtIndex:i];
            if (assetInArray.selected && (assetInArray.index > asset.index)) {
                assetInArray.index -= 1;

//                int row = i / self.columns;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                BOOL indexExistsInArray = NO;
                for (NSIndexPath *indexInArray in arrayOfCellsToReload) {
                    if (indexInArray.row == indexPath.row) {
                        indexExistsInArray = YES;
                        break;
                    }
                }
                if (!indexExistsInArray) {
                    [arrayOfCellsToReload addObject:indexPath];
                }
            }
        }
        [self.collectionView reloadItemsAtIndexPaths:arrayOfCellsToReload];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.elcAssets count];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = ([UIScreen mainScreen].bounds.size.width /4 - 4);
    float height = width;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GBALbumPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBALbumPickerCollectionViewCell" forIndexPath:indexPath];
    
    // Configure the cell
     ELCAsset *asset = [self.elcAssets objectAtIndex:indexPath.row];
    cell.gbImageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
    cell.thisELCAsset = asset;

    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBALbumPickerCollectionViewCell *cell =(GBALbumPickerCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

    UIImage *image = [UIImage imageWithCGImage:[cell.thisELCAsset.asset defaultRepresentation].fullScreenImage];

    [self broswerThisImage:image fromCellImageView:cell.gbImageView];
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (int)totalSelectedAssets
{
    int count = 0;

    for (ELCAsset *asset in self.elcAssets) {
        if (asset.selected) {
            count++;
        }
    }

    return count;
}



#pragma mark - PhotoBroswerVC Method

-(void)broswerThisImage:(UIImage *) image fromCellImageView:(UIImageView *)imageView{
[PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:0 photoModelBlock:^NSArray *{
    NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:1];

        PhotoModel *pbModel=[[PhotoModel alloc] init];
        pbModel.mid = 1;
        pbModel.title = @"";
        pbModel.desc = @"";
        pbModel.image = image;

        //源frame
        UIImageView *imageV = imageView;
        pbModel.sourceImageView = imageV;
        [modelsM addObject:pbModel];
      return modelsM;
}];
}



@end
