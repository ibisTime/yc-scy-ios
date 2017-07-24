//
//  CreditVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CreditVC.h"

#import "BillVC.h"
#import "AccountVC.h"

#import "SearchUserApi.h"

#define XIN_YONG_FEN_TITLE @"信用分代发"

@interface CreditVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *hintArrow;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UILabel *typeNameLbl;
@property (nonatomic, strong) UILabel *amountLbl;


@property (nonatomic, strong) TLTextField *mobileTf;
@property (nonatomic, strong) TLTextField *moneyTf;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation CreditVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self data];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel labelWithTitle:@"代销代发"];
    
    self.view.backgroundColor = kBackgroundColor;
    
    [UIBarButtonItem addRightItemWithTitle:@"归账" frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(backMoney)];
    
    [self setUpUI];
}

#pragma mark - Init
- (void)setUpUI {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage imageNamed:@"代销代发背景"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    bgImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookAccountFlow)];
    [bgImageView addGestureRecognizer:tap];
    
    
    //    hintLbl
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(18)
                                     textColor:[UIColor whiteColor]];
    [bgImageView addSubview:hintLbl];
    hintLbl.text = @"信用分";
    self.typeNameLbl = hintLbl;
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(bgImageView.mas_centerY);
        
    }];
    
    //
    self.amountLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentCenter
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(35)
                                   textColor:[UIColor whiteColor]];
    
    [bgImageView addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(hintLbl.mas_right).equalTo(@30);
//        make.centerX.equalTo(bgImageView.mas_centerX);
        make.centerY.equalTo(bgImageView.mas_centerY);
        
    }];
    
    //右箭头
    UIImageView *moreRightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
    [bgImageView addSubview:moreRightArrow];
    [moreRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bgImageView);
        make.left.equalTo(bgImageView.mas_right).offset(-20);
        
    }];
    
    
    //手机号 额度
    TLTextField *mobileTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, bgImageView.yy, kScreenWidth, 45) leftTitle:@"会员手机号" titleWidth:100 placeholder:@"发放手机号"];
    [self.view addSubview:mobileTf];
    mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTf = mobileTf;
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, mobileTf.yy, kScreenWidth, 0.5)];
    
    firstLine.backgroundColor = kLineColor;
    [self.view addSubview:firstLine];
    
    //
    TLTextField *moneyNumTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, mobileTf.yy + 1, kScreenWidth, 45) leftTitle:@"代发额度" titleWidth:100 placeholder:@"请输入额度"];
    moneyNumTf.delegate = self;
    
    [self.view addSubview:moneyNumTf];
    self.moneyTf = moneyNumTf;
    moneyNumTf.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, moneyNumTf.yy, kScreenWidth, 0.5)];
    
    secondLine.backgroundColor = kLineColor;
    [self.view addSubview:secondLine];
    
    //
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(15, moneyNumTf.yy + 35, kScreenWidth - 30, 45) title:@"确认发放"];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
}


- (UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title {
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:frame];
    [leftBtn setTitle:title forState:UIControlStateNormal];
    leftBtn.titleLabel.font = FONT(15);
    [leftBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateSelected];
    
    return leftBtn;
}

#pragma mark - Events

- (void)confirm {
    
    if (![self.mobileTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入手机号"];
        return;
    }
    
    if (self.mobileTf.text.length != 11) {
        
        [TLAlert alertWithInfo:@"请输入11位手机号码"];
        return;
    }
    
    if (![self.moneyTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入代发数量"];
        
        return;
    }
    
    if ([self.moneyTf.text doubleValue] <= 0) {
        
        [TLAlert alertWithInfo:@"请输入大于0的额度"];
        return;
    }
    
    [self requestGrantApi];
    
}

- (void)lookAccountFlow {
    
    BillVC *billVC = [[BillVC alloc] init];
    
    [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.currency isEqualToString:kXYF]) {
            billVC.accountNumber = obj.accountNumber;
            *stop = YES;
        }
    }];
    
    
    [self.navigationController pushViewController:billVC animated:YES];
    
    
}

- (void)backMoney {
    
    AccountVC *accountVC = [AccountVC new];
    
    [self.navigationController pushViewController:accountVC animated:YES];
}

#pragma mark - Data

- (void)data {
    
    [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.currency isEqualToString:kXYF]) {
            
            self.amountLbl.text = [obj.amount convertToRealMoney];
            *stop = YES;
        }
    }];
    
    
}

- (void)requestGrantApi {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802412";
    http.parameters[@"fromUserId"] = [TLUser user].userId;
    http.parameters[@"amount"] = [self.moneyTf.text convertToSysMoney];
    //    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"mobile"] = self.mobileTf.text;
    //XYF 信用分
    http.parameters[@"fromCurrency"] = kXYF;
    http.parameters[@"toCurrency"] = kXYF;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"发放成功"];
        [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:kXYF]) {
                
                obj.amount = @([obj.amount longLongValue] - [[self.moneyTf.text convertToSysMoney] longLongValue]);
                self.amountLbl.text = [obj.amount convertToRealMoney];
                
                *stop = YES;
            }
            
        }];
        
        self.mobileTf.text = nil;
        self.moneyTf.text = nil;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        //        BXLog(@"single = %c",single);
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            [TLAlert alertWithInfo:@"您的输入格式不正确"];
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            //            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    //                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    //                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [TLAlert alertWithInfo:@"小数点后最多有两位小数"];
                    
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
