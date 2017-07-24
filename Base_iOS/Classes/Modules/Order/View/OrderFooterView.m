//
//  OrderFooterView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderFooterView.h"

@interface OrderFooterView ()

@property (nonatomic,strong) UIButton *statusBtn;

@property (nonatomic,strong) UILabel *priceLbl;

@end

@implementation OrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *btn = [UIButton zhBtnWithFrame:CGRectZero title:nil];
        [self addSubview:btn];
        self.statusBtn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
        //价格
        UILabel *priceLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:FONT(12)
                                          textColor:[UIColor zh_themeColor]];
        [self addSubview:priceLbl];
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btn.mas_left).offset(-13);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        self.priceLbl = priceLbl;
        
        
        //提醒
        //        UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
        //                                      textAligment:NSTextAlignmentLeft
        //                                   backgroundColor:[UIColor whiteColor]
        //                                              font:FONT(14)
        //                                         textColor:[UIColor zh_textColor2]];
        //        [self addSubview:hintLbl];
        //        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.equalTo(priceLbl.mas_left).offset(-7);
        //            make.centerY.equalTo(self.mas_centerY);
        //        }];
        //        hintLbl.text = @"全额：";
        
    }
    return self;
}

- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    //按钮状态
    [self.statusBtn setTitle:[_order getStatusName] forState:UIControlStateNormal];
    
}


@end
