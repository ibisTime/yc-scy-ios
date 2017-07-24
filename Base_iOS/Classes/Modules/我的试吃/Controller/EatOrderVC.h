//
//  EatOrderVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHReceivingAddress.h"
#import "GoodModel.h"

@interface EatOrderVC : BaseViewController

@property (nonatomic, strong) ZHReceivingAddress *address;

@property (nonatomic, strong) GoodModel *good;

@end
