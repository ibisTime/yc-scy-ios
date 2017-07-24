//
//  OrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"productOrderList" : [OrderDetailModel class]};
    
}


- (NSString *)getStatusName {
    
    
    //1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
    
    NSDictionary *dict = @{
                           @"1" : @"待支付",
                           @"2" : @"待发货",
                           @"3" : @"待收货",
                           @"4" : @"已收货",
                           @"91" : @"已取消",
                           @"92" : @"商户取消",
                           @"93" : @"快递异常"
                           };
    
    return dict[self.status];
    
}

@end
