//
//  OrderDetailModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "GoodModel.h"

@interface OrderDetailModel : BaseModel

@property (nonatomic, copy, readonly) NSString *productName;

@property (nonatomic, copy) NSString *productSpecsName;

@property (nonatomic, copy, readonly) NSString *advPic;

@property (nonatomic,strong) NSNumber *quantity; //数量

@property (nonatomic, strong) GoodModel *product;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *orderCode;

@property (nonatomic,strong) NSNumber *price1;
@property (nonatomic,strong) NSNumber *price2;
@property (nonatomic,strong) NSNumber *price3;

@property (nonatomic,copy) NSString *productCode;

@end
