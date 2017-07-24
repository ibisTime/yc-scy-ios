//
//  FuncView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLMsgBadgeView.h"

@interface FuncView : UIView

@property (nonatomic,assign) NSInteger msgCount;
@property (nonatomic,strong) void(^selected)(NSInteger index);
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) TLMsgBadgeView *msgBadgeView;

- (instancetype)initWithFrame:(CGRect)frame funcName:(NSString *)funcName funcImage:(NSString *)imgName;

@end
