//
//  Msg.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "Msg.h"

@implementation Msg

- (CGFloat)contentHeight {
    
    //    - 57 - 20 - 20
    CGSize size = [self.smsContent calculateStringSize:CGSizeMake(kScreenWidth - 77 - 20, MAXFLOAT) font:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    
    return size.height + 10;
    
}

@end
