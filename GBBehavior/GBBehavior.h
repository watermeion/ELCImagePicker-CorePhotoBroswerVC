//
//  GBBehavior.h
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/7/29.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Foundation;
/**
 *  IOS 行为类基类，主要实现动态绑定关联对象
 */
@interface GBBehavior : UIControl

//绑定本对象的关联主人对象，解决
@property (weak, nonatomic) IBOutlet id owner;

/**
 *  将本身对象绑定到目标对象
 *
 *  @param object 目标对象
 */
- (void)gb_bindLifeTimeToObject:(id)object;

/**
 *  通过运行时，将对象与关联对象解绑
 *
 *  @param object 目标对象
 */
- (void)gb_releaseLifeTimeToObject:(id)object;

@end
