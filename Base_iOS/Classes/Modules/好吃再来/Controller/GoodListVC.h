//
//  GoodListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodModel.h"

typedef void(^SelectGoodBlock)(GoodModel *good);

@interface GoodListVC : BaseViewController

@property (nonatomic, copy) SelectGoodBlock selectBlock;

@end
