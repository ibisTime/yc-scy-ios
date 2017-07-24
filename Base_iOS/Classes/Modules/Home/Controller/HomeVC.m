//
//  HomeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"

#import "MJRefresh.h"
#import "UIButton+WebCache.h"

#import "CurrencyModel.h"

#import "FuncView.h"

#import "MsgVC.h"
#import "SettingVC.h"
#import "EatListVC.h"
#import "EatAgainOrderVC.h"
#import "CreditVC.h"
#import "MyFriendsVC.h"
//#import "AllBillVC.h"
#import "AccountVC.h"
#import "BillVC.h"
#import "HTMLStrVC.h"

@interface HomeVC ()

@property (nonatomic,strong) UIScrollView *bgScrollView;
//昵称
@property (nonatomic,strong) UILabel *nameLbl;
//头像
@property (nonatomic,strong) UIButton *photoBtn;
//
@property (nonatomic,strong) UILabel *capitalLbl;

//@property (nonatomic,strong) UILabel *nickNameLbl;
@property (nonatomic, strong) UIButton *levelBtn;

//公告
@property (nonatomic,strong) UILabel *sysMsgLbl;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic,strong) FuncView *kefuFuncView;

@property (nonatomic, copy) NSArray <CurrencyModel *>*currencyRoom;

@property (nonatomic, copy) NSString *accountNumber;

@end

@implementation HomeVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self getAccountInfo:^{
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"";

    [self initScrollView];
    
    [self initSubviews];
    
    [self addNotification];
    
    [self userInfoChange];

    [self getSysMsg];
    
    [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(getSysMsg) userInfo:nil repeats:YES];
}

#pragma mark - Init
- (void)initScrollView {

    self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshState)];

}

- (void)initSubviews {

    EatWeakSelf;
    
    //头部
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*520/750.0)];
    headerImageView.backgroundColor = [UIColor orangeColor];
    headerImageView.userInteractionEnabled = YES;
    
    headerImageView.image = [UIImage imageNamed:@"首页背景"];
    
    [self.bgScrollView addSubview:headerImageView];
    
    //二维码
//    UIButton *qrCodeBtn = [[UIButton alloc] init];
//    [headerImageView addSubview:qrCodeBtn];
//    [qrCodeBtn setBackgroundImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
//    [qrCodeBtn addTarget:self action:@selector(receiverMoney) forControlEvents:UIControlEventTouchUpInside];
//    [qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameLbl.mas_top).offset(2);
//        make.right.equalTo(headerImageView.mas_right).offset(-25);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(40);
//    }];
    
    //昵称
    UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, kWidth(30), kScreenWidth, 25)
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont systemFontOfSize:kWidth(20)]
                                     textColor:[UIColor whiteColor]];
    nameLbl.text = @"姚橙试吃员";
    
    [headerImageView addSubview:nameLbl];
    nameLbl.height = [[UIFont systemFontOfSize:kWidth(20)] lineHeight];
    self.nameLbl = nameLbl;
    
    //头像
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, nameLbl.yy + kWidth(30), kWidth(80), kWidth(80))];
    photoBtn.centerX = kScreenWidth/2.0;
    photoBtn.layer.cornerRadius = photoBtn.height / 2.0;
    photoBtn.layer.borderWidth = 2;
    photoBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    photoBtn.layer.masksToBounds = YES;
    photoBtn.contentMode = UIViewContentModeScaleAspectFill;

    [headerImageView addSubview:photoBtn];
    [photoBtn addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    self.photoBtn = photoBtn;
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"头像占位图"] forState:UIControlStateNormal];
    
    
//    //资金说明
//    UILabel *capitalExplainLbl = [UILabel labelWithFrame:CGRectMake(0, photoBtn.yy + kWidth(12), kScreenWidth, 20)
//                                            textAligment:NSTextAlignmentCenter
//                                         backgroundColor:[UIColor clearColor]
//                                                    font:[UIFont systemFontOfSize:kWidth(13)]
//                                               textColor:[UIColor whiteColor]];
//    [headerImageView addSubview:capitalExplainLbl];
//    capitalExplainLbl.height = [[UIFont systemFontOfSize:kWidth(13)] lineHeight];
//    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//    attach.image = [UIImage imageNamed:@"总资产"];
//    attach.bounds = CGRectMake(0, -2.5, kWidth(12), kWidth(12));
//    NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:attach];
//    
//    NSMutableAttributedString *newAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
//    [newAttrStr appendAttributedString: [[NSAttributedString alloc] initWithString:@" 当前总资产 (元)" attributes:@{
//                                                                                                              NSForegroundColorAttributeName : [UIColor whiteColor],
//                                                                                                              NSFontAttributeName : [UIFont systemFontOfSize:kWidth(13)]
//                                                                                                              
//                                                                                                              }]];
//    capitalExplainLbl.attributedText = newAttrStr;

    //具体资金数目
    UILabel *capitalLbl =  [UILabel labelWithFrame:CGRectMake(0, photoBtn.yy + kWidth(17), kScreenWidth, 40)
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:[UIColor clearColor]
                                              font:[UIFont systemFontOfSize:kWidth(35)]
                                         textColor:[UIColor whiteColor]];
    [headerImageView addSubview:capitalLbl];
    capitalLbl.height = [[UIFont systemFontOfSize:kWidth(35)] lineHeight];
    
    self.capitalLbl = capitalLbl;
    
    //个人流水账按钮
    UIButton *billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [billBtn addTarget:self action:@selector(lookAllBill) forControlEvents:UIControlEventTouchUpInside];
    [headerImageView addSubview:billBtn];
    [billBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(capitalLbl.mas_top).mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(150);
        
    }];
    
    //昵称
//    UILabel *nickNameLbl =  [UILabel labelWithFrame:CGRectMake(0, photoBtn.yy + kWidth(12), kScreenWidth, 40)
//                                      textAligment:NSTextAlignmentCenter
//                                   backgroundColor:[UIColor clearColor]
//                                              font:[UIFont systemFontOfSize:kWidth(35)]
//                                         textColor:[UIColor whiteColor]];
//    [headerImageView addSubview:nickNameLbl];
//    nickNameLbl.height = [[UIFont systemFontOfSize:kWidth(35)] lineHeight];
//    self.nickNameLbl = nickNameLbl;
    
//    CGFloat billTopMargin = (headerImageView.height - self.capitalLbl.yy - kWidth(40))/2;
    
    //用户等级
    UIButton *levelBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor whiteColor] backgroundColor:kClearColor titleFont:14.0];
    
    levelBtn.titleLabel.numberOfLines = 0;
    
    [levelBtn addTarget:self action:@selector(lookLevel) forControlEvents:UIControlEventTouchUpInside];
    [headerImageView addSubview:levelBtn];
    [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(kWidth(28));
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(40);
        
    }];
    
    self.levelBtn = levelBtn;
    
    //消息背景视图
    UIView *msgView = [[UIView alloc] init];
    
    msgView.backgroundColor = [UIColor whiteColor];
    
    [self.bgScrollView addSubview:msgView];
    
    //消息图标
    UIImageView *msgImage = [[UIImageView alloc] init];
    
    msgImage.image = [UIImage imageNamed:@"公告"];
    [msgView addSubview:msgImage];
    
    UILabel *sysMsgLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(15)
                                       textColor:kTextColor];
    sysMsgLbl.text = @"店铺消息";
    [msgView addSubview:sysMsgLbl];
    msgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapMsg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMsg)];
    [msgView addGestureRecognizer:tapMsg];
    
    self.sysMsgLbl = sysMsgLbl;
    
    //箭头
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [msgView addSubview:arrowImageView];
    arrowImageView.image = [UIImage imageNamed:@"bbcx_更多"];
    self.arrowImageView = arrowImageView;
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [msgView addSubview:lineView];
    
    //
    [msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headerImageView.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    //
    [msgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        
    }];
    
    //
    [sysMsgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(msgImage.mas_left).offset(30);
        make.centerY.equalTo(msgView.mas_centerY);
        make.height.mas_greaterThanOrEqualTo(40);
        make.right.equalTo(arrowImageView.mas_left).offset(-5);
        
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerImageView.mas_right).offset(-15);
        make.centerY.equalTo(msgView.mas_centerY);
    }];
    
    //
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
    
    sysMsgLbl.text = @"系统消息";
    
    //尾部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, headerImageView.yy + 45, kScreenWidth, kScreenHeight - headerImageView.height)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:footerView];
    
    //
    NSArray *funcImages = @[@"我要试吃",@"我的信用",@"好吃再来",@"干点正事"];
    NSArray *funcNames = @[@"我要试吃",@"我的信用",@"好吃再来",@"干点正事"];
    
    CGFloat funcW = 80;
    CGFloat funcH = funcW + 5 + 25;
    
    CGFloat leftMargin = (kScreenWidth - 2*funcW)/4.0;
    CGFloat topMargin = kWidth(37);
    
    for (NSInteger i = 0; i < funcImages.count; i ++) {
        
        CGFloat x = leftMargin + (funcW + 2*leftMargin)*(i%2);
        CGFloat y = topMargin + (topMargin + funcH)*(i/2);
        
        FuncView *funcView = [[FuncView alloc] initWithFrame:CGRectMake(x, y, funcW, funcH) funcName:funcNames[i] funcImage:funcImages[i]];
        funcView.index = i;
        funcView.selected = ^(NSInteger index){
            
            [weakSelf funcAction:index];
        };
        
        if (0 == i) {
            self.kefuFuncView = funcView;
        }
        
        [footerView addSubview:funcView];
        
    }
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:kUserInfoChange object:nil];
    
}

#pragma mark - Events

- (void)clickSetting {
    
    SettingVC *settingVC = [SettingVC new];
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

- (void)funcAction:(NSInteger)index {
    
    switch (index) {
        case 0: {
            
            //我的试吃
            EatListVC *eatListVC = [EatListVC new];
            
            [self.navigationController pushViewController:eatListVC animated:YES];
            
        }  break;
            
        case 1: {
            
            //我的信用
            CreditVC *creditVC = [CreditVC new];
            
            creditVC.currencyRoom = self.currencyRoom;
            
            [self.navigationController pushViewController:creditVC animated:YES];
            
        }
            break;
            
        case 2:{
            
            EatAgainOrderVC *againOrderVC = [EatAgainOrderVC new];
            
            [self.navigationController pushViewController:againOrderVC animated:YES];
            
        }
            break;
            
        case 3: {
            
            //干点正事
            MyFriendsVC *friendsVC = [MyFriendsVC new];
            
            [self.navigationController pushViewController:friendsVC animated:YES];
            
        }
            break;
            
    }
    
}


- (void)lookMsg {
    
    MsgVC *msgVC = [[MsgVC alloc] init];
    
    [self.navigationController pushViewController:msgVC animated:YES];
    
}

- (void)lookLevel {

    HTMLStrVC *htmlVC = [HTMLStrVC new];
    
    htmlVC.type = HTMLTypeMedalRule;
    
//    htmlVC.ckey = [NSString stringWithFormat:@"medal%@", [TLUser user].level];
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}

#pragma mark-- 查看账单
- (void)lookAllBill {
    
//    AllBillVC *vc = [[AllBillVC alloc] init];
//
//    vc.accountNumber = self.accountNumber;
//    
//    [self.navigationController pushViewController:vc animated:YES];
//    BillVC *billVC = [[BillVC alloc] init];
//    
//    [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if ([obj.currency isEqualToString:kXYF]) {
//            billVC.accountNumber = obj.accountNumber;
//            *stop = YES;
//        }
//    }];
    
    
//    [self.navigationController pushViewController:billVC animated:YES];
    
    AccountVC *accountVC = [AccountVC new];
    
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)refreshState {
    
    //1.用户信息
    //2.店铺信息
    //3.账户信息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.bgScrollView.mj_header endRefreshing];
        
    });
    
    //获取账户信息
    [self getAccountInfo:^{
        
    }];
    
    [self userInfoChange]; //用户信息变更
    
}

#pragma mark - Data
- (void)getAccountInfo:(void(^)())success {
    
    //查询账户信息
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.showView = self.bgScrollView.mj_header.isRefreshing ? nil : self.view;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        //存储账户信息到db
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"] forKey:ACCOUNT_INFO_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.currencyRoom = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //---//
        [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if( [obj.currency isEqualToString:kXYF]) {
                
                self.capitalLbl.text = [obj.amount convertToRealMoney];
                self.accountNumber = obj.accountNumber;
            }
            
        }];
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        //        [TLAlert alertWithHUDText:@"获取账户信息失败"];
        
    }];
    
}

- (void)userInfoChange {
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [[TLUser user] saveUserInfo:responseObject[@"data"]];
        [[TLUser user] setUserInfoWithDict:responseObject[@"data"]];
        
        if ([TLUser user].userExt.photo) {
            
            [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].userExt.photo convertImageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像占位图"]];
        }
        
        [self.levelBtn setTitle:[[TLUser user] userLevel] forState:UIControlStateNormal];
        
//        self.nickNameLbl.text = [TLUser user].nickname;
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)getSysMsg {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"804040";
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"channelType"] = @"4";
    
    http.parameters[@"pushType"] = @"41";
    http.parameters[@"toKind"] = @"4";
    //    1 立即发 2 定时发
    //    http.parameters[@"smsType"] = @"1";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
    http.parameters[@"status"] = @"1";
    
    http.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *msgs = responseObject[@"data"][@"list"];
        
        if (msgs && msgs.count > 0) {
            
            self.sysMsgLbl.text = msgs[0][@"smsTitle"];
            
        } else {
            
            self.sysMsgLbl.text = @"系统消息";
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
