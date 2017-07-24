//
//  SelectScrollView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;

- (void)setTitlePropertyWithTitleColor:(UIColor *)titleColor titleFont:(CGFloat )titleFont selectColor:(UIColor *)selectColor;

- (void)setLinePropertyWithLineColor:(UIColor *)lineColor lineSize:(CGSize)lineSize;

@end
