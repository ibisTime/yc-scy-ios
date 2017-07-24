//
//  MsgCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MsgCell.h"

@interface MsgCell ()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *msgNameLbl;
@property (nonatomic,strong) UILabel *msgTimeLbl;
@property (nonatomic,strong) UILabel *msgContentLbl;

@property (nonatomic,strong) UIView *msgBgView;

@end

@implementation MsgCell

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
        //icon
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 32, 32)];
        self.iconImageView.image = [UIImage imageNamed:@"消息"];
        [self addSubview:self.iconImageView];
        
        //
        self.msgNameLbl = [UILabel labelWithFrame:CGRectMake( self.iconImageView.xx + 10, self.iconImageView.y, kScreenWidth - self.iconImageView.xx - 10 - 10 , 10)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:[UIFont secondFont]
                                        textColor:[UIColor zh_textColor]];
        [self addSubview:self.msgNameLbl];
        self.msgNameLbl.height = [[UIFont secondFont] lineHeight];
        
        //
        self.msgTimeLbl = [UILabel labelWithFrame:CGRectMake(self.msgNameLbl.x, self.msgNameLbl.yy + 5, self.msgNameLbl.width , 10)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:[UIFont thirdFont]
                                        textColor:[UIColor colorWithHexString:@"#999999"]];
        self.msgTimeLbl.height = [[UIFont thirdFont] lineHeight];
        [self addSubview:self.msgTimeLbl];
        
        //
        self.msgBgView = [[UIView alloc] initWithFrame:CGRectMake(self.msgNameLbl.x, self.msgTimeLbl.yy + 10, self.msgTimeLbl.width - 10, 100)];
        self.msgBgView.layer.cornerRadius = 5;
        self.msgBgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        self.msgBgView.layer.masksToBounds = YES;
        [self addSubview:self.msgBgView];
        
        //
        self.msgContentLbl = [UILabel labelWithFrame:CGRectMake(10, 10, self.msgBgView.width - 20, self.msgBgView.height - 20)
                                        textAligment:NSTextAlignmentLeft
                                     backgroundColor:[UIColor clearColor]
                                                font:[UIFont fontWithName:@"PingFangSC-Regular" size:12]
                                           textColor:[UIColor colorWithHexString:@"#999999"]];
        self.msgContentLbl.numberOfLines = 0;
        [self.msgBgView addSubview:self.msgContentLbl];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 15, 1)];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        
        
    }
    return self;
    
}

- (void)setMsg:(Msg *)msg {
    
    _msg = msg;
    
    self.msgNameLbl.text = _msg.smsTitle; //名称
    self.msgTimeLbl.text = [_msg.pushedDatetime convertToDetailDate];//更新时间
    self.msgContentLbl.text = _msg.smsContent; //消息内容
    self.msgBgView.height = _msg.contentHeight + 20;
    self.msgContentLbl.height = _msg.contentHeight;
    
}

@end
