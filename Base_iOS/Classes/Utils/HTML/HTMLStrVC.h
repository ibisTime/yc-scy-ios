//
//  HTMLStrVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, HTMLType) {
    HTMLTypeAboutUs = 0,    //关于我们
    HTMLTypeMedalRule,    //金牌规则
    
};

@interface HTMLStrVC : TLBaseVC

@property (nonatomic, assign) HTMLType type;

//@property (nonatomic, copy) NSString *ckey;

@end
