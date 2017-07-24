//
//  AccountVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AccountVC.h"

#import "BackMoneyVC.h"
#import "BackMoneyBillVC.h"
#import "BillVC.h"

#import "CurrencyModel.h"

@interface AccountVC ()

@property (nonatomic, strong) NSNumber *inAmount;

@property (nonatomic, copy) NSArray <CurrencyModel *>*currencyRoom;

@property (nonatomic, strong) CurrencyModel *currencyModel;

@property (nonatomic, strong) UILabel *moneyLbl;

@property (nonatomic, strong) TLTextField *inAmountTf;

@property (nonatomic, strong) TLTextField *outAmountTf;

@end

@implementation AccountVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self requestBalanceInfo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我要归账"];

    self.view.backgroundColor = kBackgroundColor;
    
    [self initSubviews];

}

#pragma mark - Init

- (void)initSubviews {

    //头
    UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    headerBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerBtn];
    [headerBtn addTarget:self action:@selector(lookBill) forControlEvents:UIControlEventTouchUpInside];
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(15)
                                     textColor:[UIColor zh_textColor]];
    hintLbl.text = @"信用分：";
    [headerBtn addSubview:hintLbl];
    
    //
    UILabel *moneyLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(30)
                                      textColor:[UIColor zh_themeColor]];
    [headerBtn addSubview:moneyLbl];
    self.moneyLbl = moneyLbl;

    //
    UIImageView *moreRightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bbcx_更多"]];
    //    moreRightArrow.backgroundColor = [UIColor orangeColor];
    [headerBtn addSubview:moreRightArrow];
    moreRightArrow.clipsToBounds = YES;
    moreRightArrow.contentMode = UIViewContentModeScaleAspectFill;
    
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBtn.mas_left).offset(15);
        make.centerY.equalTo(headerBtn.mas_centerY);
    }];
    
    [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintLbl.mas_right).offset(15);
        make.right.lessThanOrEqualTo(moreRightArrow.mas_left);
        make.centerY.equalTo(headerBtn.mas_centerY);
    }];
    
    [moreRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(headerBtn.mas_centerY);
        make.right.equalTo(headerBtn.mas_right).offset(-20);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(18);
    }];
    
    //已归账总额
    TLTextField *outAmountTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, headerBtn.yy + 10, kScreenWidth, 45) leftTitle:@"已归账总额" titleWidth:100 placeholder:@""];
    outAmountTf.textColor = [UIColor zh_themeColor];
    outAmountTf.enabled = NO;
    self.outAmountTf = outAmountTf;
    
    [self.view addSubview:outAmountTf];
    
    TLTextField *inAmountTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, outAmountTf.yy + 1, kScreenWidth, 45) leftTitle:@"待归账总额" titleWidth:100 placeholder:@"" ];
    inAmountTf.textColor = [UIColor zh_themeColor];
    inAmountTf.enabled = NO;
    [self.view addSubview:inAmountTf];
    
    self.inAmountTf = inAmountTf;
    
    //
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(15, inAmountTf.yy + 35, kScreenWidth - 30, 45) title:@"我要归账"];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(backMoney) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Events

- (void)backMoney {
    
    BackMoneyVC *backMoneyVC = [[BackMoneyVC alloc] init];
    backMoneyVC.balance = self.inAmount;
    backMoneyVC.accountNumber = self.currencyModel.accountNumber;
    
    [self.navigationController pushViewController:backMoneyVC animated:YES];
    
}

- (void)lookBill {
    
//    BackMoneyBillVC *billVC = [[BackMoneyBillVC alloc] init];
//
//    billVC.accountNumber = self.currencyModel.accountNumber;
//    
//    [self.navigationController pushViewController:billVC animated:YES];
    BillVC *billVC = [[BillVC alloc] init];
    
    [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.currency isEqualToString:kXYF]) {
            billVC.accountNumber = obj.accountNumber;
            *stop = YES;
        }
    }];
    
    
    [self.navigationController pushViewController:billVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestBalanceInfo {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        self.currencyRoom = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //---//
        [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([obj.currency isEqualToString:kXYF]) {
                
                self.inAmount = @([obj.inAmount longLongValue] - [obj.outAmount longLongValue]);
            
                self.moneyLbl.text = [obj.amount convertToRealMoney];
                
                self.outAmountTf.text = [obj.outAmount convertToRealMoney];
                
                //待归账金额
                self.inAmountTf.text = [@([obj.inAmount longLongValue] - [obj.outAmount longLongValue]) convertToRealMoney];
                
                
                

            }
            
        }];
        
    } failure:^(NSError *error) {
        
        //        [TLAlert alertWithHUDText:@"获取账户信息失败"];
        
    }];
    
}

@end
