//
//  OrderDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface OrderDetailVC : BaseViewController

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic,copy) void(^paySuccess)();

@property (nonatomic,copy) void(^cancleSuccess)();

@property (nonatomic,copy) void(^confirmReceiveSuccess)();

@end
