//
//  CDGoodsParameterModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CDGoodsParameterModel.h"

@implementation CDGoodsParameterModel

+ (NSString *)randomCode {
    
    return [NSString stringWithFormat:@"%f%u",[[NSDate date] timeIntervalSince1970],arc4random()%1000
            ];
    
}

- (NSString *)getPrice {
    
    return [TLCurrencyHelper totalPriceWithRMB:self.price1];
}

- (NSString *)getDetailText {
    
    return [NSString stringWithFormat:@"%@",self.name];
    
}

- (NSDictionary *)toDictionry {
    
    NSDictionary *dict = @{
                           
                           @"code" : self.code,
                           @"name" : self.name,
                           @"price1" : self.price1,
                           @"price2" : self.price2,
                           @"price3" : self.price3,
                           @"quantity" : self.quantity,
                           @"province" : self.province,
                           @"weight" : self.weight,
                           
                           
                           };
    
    return dict;
    
}

@end
