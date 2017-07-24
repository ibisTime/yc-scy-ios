//
//  GoodModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"productSpecsList" : [CDGoodsParameterModel class]};
    
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj  convertImageUrl]];
            
        }];
        
        _pics = newImgs;
        
    }
    
    return _pics;
    
}

- (CGFloat)detailHeight {
    
    CGSize size  =  [self.desc calculateStringSize:CGSizeMake(kScreenWidth - 30, 1000) font:FONT(13)];
    
    return size.height + 25;
}


- (NSString *)coverMoney:(NSNumber *)priceNum {
    
    NSInteger pr = [priceNum integerValue];
    CGFloat newPr = pr/1000.0;
    return [NSString stringWithFormat:@"%.1f",newPr];
    
}


//神奇
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
    
}
@end
