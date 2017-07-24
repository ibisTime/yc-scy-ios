//
//  CurrencyModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

FOUNDATION_EXTERN NSString *const kCNY;//人民币

FOUNDATION_EXTERN NSString *const kXYF;//信用分

@interface CurrencyModel : BaseModel

@property (nonatomic,copy) NSString *accountNumber;

@property (nonatomic,strong) NSNumber *amount; //可用余额
@property (nonatomic, strong) NSNumber *outAmount;
@property (nonatomic, strong) NSNumber *inAmount;//待归账总额

@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,strong) NSNumber *frozenAmount; //冻结金额
@property (nonatomic,copy) NSString *md5;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;

@end
