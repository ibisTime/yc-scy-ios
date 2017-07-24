//
//  CDGoodsParameterModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface CDGoodsParameterModel : BaseModel

//已存在的为从服务器获取, 新增的为自己生成
@property (nonatomic, strong) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *price1;
@property (nonatomic, strong) NSNumber *price2;
@property (nonatomic, strong) NSNumber *price3;

@property (nonatomic, strong) NSNumber *originalPrice;

@property (nonatomic, strong) NSNumber *quantity;

@property (nonatomic, strong) NSString *province; //市
@property (nonatomic, strong) NSString *weight; //重量

- (NSDictionary *)toDictionry;

- (NSString *)getDetailText;
- (NSString *)getPrice;
+ (NSString *)randomCode;

@end
