//
//  GBBehavior.m
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/7/29.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "GBBehavior.h"
#import "objc/runtime.h"


@implementation GBBehavior

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



- (void)setOwner:(id)owner
{
    if (_owner != owner) {
        //解绑原来的对象
        [self gb_releaseLifeTimeToObject:_owner];
        //赋值
        _owner = owner;
        [self gb_bindLifeTimeToObject:_owner];
    }
}

- (void)gb_bindLifeTimeToObject:(id)object{
    //绑定对象
    objc_setAssociatedObject(object, (__bridge void*)self, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)gb_releaseLifeTimeToObject:(id)object{
    //将绑定设为nil 解除绑定
    objc_setAssociatedObject(object, (__bridge void*)self, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
