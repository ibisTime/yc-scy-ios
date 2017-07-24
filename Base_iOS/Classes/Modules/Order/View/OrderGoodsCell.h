//
//  OrderGoodsCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodModel.h"
#import "OrderModel.h"
#import "OrderDetailModel.h"

typedef NS_ENUM(NSInteger, MoneyType) {
    
    MoneyTypeRMB = 0,   //人民币
    MoneyTypeJF,    //积分
};

@interface OrderGoodsCell : UITableViewCell

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic,copy) void(^comment)(NSString *code);

//币种
@property (nonatomic, assign) MoneyType moneyType;

+ (CGFloat)rowHeight;

@end
