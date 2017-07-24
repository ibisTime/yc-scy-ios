//
//  GoodModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "CDGoodsParameterModel.h"

@interface GoodModel : BaseModel

@property (nonatomic,copy) NSString *advPic; //封面图片
@property (nonatomic, strong) NSNumber *boughtCount;
@property (nonatomic,copy) NSString *slogan;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *costPrice;
@property (nonatomic,copy) NSString *location;

@property (nonatomic, copy) NSString *isTasted; //已试吃

@property (nonatomic,copy) NSString *desc;
//@property (nonatomic,copy) NSString *description;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,strong) NSNumber *quantity;

@property (nonatomic, copy) NSString *tasteTime;
// 0 已提交 1.审批通过 2.审批不通过 3.已上架 4.已下架
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;

//由pic1 转化成的 数组,eg: http://wwwa.dfdsf.dcom
@property (nonatomic,copy) NSArray *pics;
@property (nonatomic, copy) NSArray <CDGoodsParameterModel*> *productSpecsList;
//

@end
