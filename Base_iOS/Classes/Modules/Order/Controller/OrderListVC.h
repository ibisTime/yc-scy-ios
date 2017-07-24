//
//  OrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,OrderStatus){
    
    OrderStatusAll = 0, //全部
    OrderStatusWillSend = 2, //待发货
    OrderStatusWillReceipt = 3 //待收货
    
};

@interface OrderListVC : BaseViewController

@property (nonatomic,assign) OrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
