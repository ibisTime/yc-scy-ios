//
//  OrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "OrderDetailModel.h"
#import "GoodModel.h"

@interface OrderModel : BaseModel

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *receiver; //收货人
@property (nonatomic,copy) NSString *reMobile; //电话
@property (nonatomic,copy) NSString *reAddress; //地址

@property (nonatomic,copy) NSString *type; //类型
@property (nonatomic,copy) NSString *applyNote; //商家嘱托

//物品数组 <ZHOrderDetailModel *>
@property (nonatomic,copy) NSArray <OrderDetailModel *> *productOrderList;

@property (nonatomic, strong) GoodModel *product;

//1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
@property (nonatomic,copy) NSString *status; //状态

@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间

@property (nonatomic,copy) NSString *logisticsCode; //快递编号
@property (nonatomic,copy) NSString *logisticsCompany; //快递公司

@property (nonatomic, strong) NSNumber *quantity;


//规格价格，和规格名称
@property (nonatomic, copy) NSString *productSpecsName;
@property (nonatomic, strong) NSNumber *price1;
@property (nonatomic, strong) NSNumber *price2;
@property (nonatomic, strong) NSNumber *price3;

@property (nonatomic, strong) NSNumber *amount1;
@property (nonatomic, strong) NSNumber *amount2;
@property (nonatomic, strong) NSNumber *amount3;

@property (nonatomic, strong) NSNumber *payAmount1;
@property (nonatomic, strong) NSNumber *payAmount2;
@property (nonatomic, strong) NSNumber *payAmount3;

- (NSString *)getStatusName;

@end
