//
//  FriendListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FriendListCell.h"

@interface FriendListCell ()

@property (nonatomic,strong) UIImageView *coverImageV;

@property (nonatomic,strong) UILabel *nameLbl;

@property (nonatomic,strong) UILabel *timeLbl;


@end

@implementation FriendListCell

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
        
        CGFloat iconW = 60;
        
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, iconW, iconW)];
        self.coverImageV.layer.masksToBounds = YES;
        self.coverImageV.layer.cornerRadius = iconW/2.0;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.coverImageV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectMake( self.coverImageV.xx + 13, 20, kScreenWidth - self.coverImageV.xx - 13, 10) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        self.nameLbl.height = [[UIFont secondFont] lineHeight];
        
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 15, self.nameLbl.width, [FONT(11) lineHeight])
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(13)
                                       textColor:[UIColor zh_textColor2]];
        [self addSubview:self.timeLbl];
        
        self.statusBtn = [UIButton buttonWithTitle:@"给TA来一单" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
        
        [self addSubview:self.statusBtn];
        [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
            
        }];
        
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

+ (CGFloat)rowHeight {
    
    return 96;
}

- (void)setFriendModel:(FriendModel *)friendModel {

    _friendModel = friendModel;
//
    UserExt *userExt = _friendModel.userExt;
    
    NSString *urlStr = [userExt.photo convertImageUrl];
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:urlStr]
                        placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    self.nameLbl.text = userExt.mobile;
    self.timeLbl.text = [_friendModel.createDatetime convertDate];
    
}

@end
