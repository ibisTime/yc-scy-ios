//
//  AccountTf.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AccountTf.h"

@implementation AccountTf

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, frame.size.height)];
        
        _leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
        _leftIconView.contentMode = UIViewContentModeCenter;
        _leftIconView.centerY = leftBgView.height/2.0;
        _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
        //_leftIconView.backgroundColor = [UIColor orangeColor];
        [leftBgView addSubview:_leftIconView];
        
        self.leftView = leftBgView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
        
        //白色边界线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.7, 18)];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.centerY = frame.size.height/2.0;
        lineView.centerX = leftBgView.width;
        
        [leftBgView addSubview:lineView];
        self.tintColor = [UIColor redColor];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;
    
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = [placeHolder copy];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_placeHolder attributes:@{
                                                                                                          NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                          }];
    self.attributedPlaceholder = attrStr;
    
}



- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)newRect:(CGRect)oldRect {
    
    CGRect newRect = oldRect;
    newRect.origin.x = newRect.origin.x + 64;
    return newRect;
}

@end
