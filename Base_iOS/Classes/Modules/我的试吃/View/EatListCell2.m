//
//  EatListCell2.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/22.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "EatListCell2.h"

@interface EatListCell2 ()

@property (nonatomic,strong) UIImageView *coverImageV;

@property (nonatomic,strong) UILabel *nameLbl;

@property (nonatomic,strong) UILabel *sloganLbl;

@property (nonatomic, strong) UIButton *statusBtn;

@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation EatListCell2

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
        
    }
    return self;
}

+ (CGFloat)rowHeight {
    
    return 96;
}

- (void)initSubviews {
    
    CGFloat imgW = 80;
    
    CGFloat leftMargin = 15;
    
    CGFloat btnW = 60;
    
    CGFloat width = kScreenWidth - leftMargin - imgW - leftMargin - leftMargin - btnW - leftMargin;
    
    self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, 15, 80, 65)];
    self.coverImageV.layer.masksToBounds  = YES;
    self.coverImageV.layer.cornerRadius = 2;
    self.coverImageV.layer.borderWidth = 0.5;
    self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.coverImageV];
    
    //名称
    self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageV.xx + 13, 20, width, 10) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont thirdFont] textColor:[UIColor zh_textColor]];
    
    self.nameLbl.numberOfLines = 0;
    [self addSubview:self.nameLbl];
    self.nameLbl.height = [[UIFont secondFont] lineHeight];
    
    
    //广告语
    self.sloganLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 20, width, [FONT(11) lineHeight])
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(11)
                                   textColor:[UIColor zh_textColor2]];
    self.sloganLbl.numberOfLines = 0;
    
    [self addSubview:self.sloganLbl];
    
    self.statusBtn = [UIButton buttonWithTitle:@"已试吃" titleColor:kTextColor backgroundColor:kWhiteColor titleFont:13.0 cornerRadius:5];
    
    [self addSubview:self.statusBtn];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(-15);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(60);
        make.height.mas_lessThanOrEqualTo(20);
        
    }];
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kPaleGreyColor;
    
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(btnW);
        make.right.mas_equalTo(-leftMargin);
        
    }];
    
    //时间
    self.timeLbl = [UILabel labelWithFrame:CGRectMake(kScreenWidth - 15 - 65, 48 + 10, 65, [FONT(11) lineHeight])
                                textAligment:NSTextAlignmentRight
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(11)
                                   textColor:[UIColor zh_textColor2]];
    self.timeLbl.numberOfLines = 0;
    
    [self addSubview:self.timeLbl];
    
    
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor zh_lineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)setGood:(GoodModel *)good {
    
    _good = good;
    
    [self initSubviews];
    
    CGFloat imgW = 80;
    
    CGFloat leftMargin = 15;
    
    CGFloat btnW = 60;
    
    CGFloat width = kScreenWidth - leftMargin - imgW - leftMargin - leftMargin - btnW - leftMargin;
    
    NSString *urlStr = [good.advPic convertImageUrl];
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:urlStr]
                        placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    
    CGSize nameSize = [_good.name calculateStringSize:CGSizeMake(width, MAXFLOAT) font:self.nameLbl.font];
    
    [self.nameLbl labelWithTextString:_good.name lineSpace:5];
    
    self.nameLbl.height = nameSize.height + 5;
    
    CGSize sloganSize = [_good.slogan calculateStringSize:CGSizeMake(width, MAXFLOAT) font:self.sloganLbl.font];
    
    [self.sloganLbl labelWithTextString:_good.slogan lineSpace:5];
    
    self.sloganLbl.height = sloganSize.height + 5;
    
    self.timeLbl.text = [NSString stringWithFormat:@"%@", [_good.tasteTime convertDateWithFormat:@"yyyy-M-d"]];
    
}

@end
