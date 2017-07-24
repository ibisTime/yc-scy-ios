//
//  OrderGoodsCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderGoodsCell.h"

@interface OrderGoodsCell ()

@property (nonatomic,strong) UIImageView *coverImageV;
@property (nonatomic,strong) UILabel *nameLbl;

@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic,strong) UILabel *numLbl; //数目

@end

@implementation OrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageV.clipsToBounds = YES;
        self.coverImageV.layer.masksToBounds  = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        [self addSubview:self.coverImageV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageV.xx + 13, 15, kScreenWidth - self.coverImageV.xx - 13 - 13, 10) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        self.nameLbl.height = [[UIFont secondFont] lineHeight];
        
        //规格
        self.numLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 8, self.nameLbl.width, [FONT(11) lineHeight])
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(11)
                                    textColor:[UIColor zh_textColor2]];
        [self addSubview:self.numLbl];
        
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.numLbl.yy + 10, self.nameLbl.width, [FONT(13) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_themeColor]];
        [self addSubview:self.priceLbl];
        
        //评价的按钮
        CGFloat w = 50;
        UIButton *pjBtn = [UIButton zhBtnWithFrame:CGRectMake(kScreenWidth - 10 - w, self.priceLbl.yy + 5, w, 25) title:@"评价"];
        //        [self addSubview:pjBtn];
        [pjBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        
    }
    return self;
}

- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    GoodModel *product = _order.product;
    
    NSString *urlStr = product.advPic;
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = product.name;
    
    //
    self.priceLbl.text = [_order.payAmount2 convertToRealMoney];
    
    //
    self.numLbl.text = [NSString stringWithFormat:@"%@ x %@",_order.productSpecsName ,[_order.quantity stringValue]];
    
    //
}

+ (CGFloat)rowHeight {
    
    return 96;
}

@end
