//
//  BackMoneyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BackMoneyVC.h"
#import "TLPwdRelatedVC.h"
#import <WebKit/WebKit.h>

@interface BackMoneyVC ()<UITextFieldDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UILabel *accountLbl;      //归账账号

@property (nonatomic, strong) TLTextField *amountTf;    //归账信用分

@property (nonatomic, strong) TLTextField *payPwdTf;

@property (nonatomic, strong) UILabel *inAmountLbl;     //待归账信用分

@property (nonatomic, strong) UILabel *outAmountLbl;    //归账金额

@property (nonatomic, strong) UIButton *backMoneyBtn;   //归账按钮

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSString *rate;             //比例

@property (nonatomic, copy) NSString *repayAccount;     //归账账号

@property (nonatomic, copy) NSString *repayRemark;      //备注

@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation BackMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"归账"];
    
    self.view.backgroundColor = kBackgroundColor;
    
    //获取归账比例
    [self requestBackRate];
    
    //获取归账账号
    [self requestAccount];
    
}

#pragma mark - Init
- (void)initSubviews {

    CGFloat leftMargin = 15;
    
    self.accountLbl = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:14.0];
    
    self.accountLbl.backgroundColor = kClearColor;
    
    self.accountLbl.numberOfLines = 0;
    
    [self.accountLbl labelWithTextString:_repayAccount lineSpace:5];

//    CGSize size = [_repayRemark calculateStringSize:CGSizeMake(kScreenWidth - 2*15, MAXFLOAT) font:self.accountLbl.font];

//    self.accountLbl.text = self.repayAccount;
    
    self.accountLbl.frame = CGRectMake(15, 5, kScreenWidth - 2*15, 90);
    
    [self.view addSubview:self.accountLbl];
    
    //待归账金额
    self.inAmountLbl = [UILabel labelWithText:[NSString stringWithFormat:@"待归账信用分: %@", [self.balance convertToRealMoney]] textColor:kTextColor2 textFont:14.0];
    
    self.inAmountLbl.backgroundColor = kClearColor;
    self.inAmountLbl.frame = CGRectMake(leftMargin, self.accountLbl.yy, kScreenWidth - 2*leftMargin, 40);
    
    [self.view addSubview:self.inAmountLbl];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.inAmountLbl.yy, kScreenWidth, 120)];
    
    [self.view addSubview:self.bgView];
    
    //归账金额
    TLTextField *amountTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) leftTitle:@"归账信用分" titleWidth:100 placeholder:@"请输入归账信用分"];
    
    [amountTf addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    amountTf.textColor = [UIColor zh_themeColor];
    amountTf.keyboardType = UIKeyboardTypeDecimalPad;

    amountTf.delegate = self;
    [self.bgView addSubview:amountTf];
    self.amountTf = amountTf;
    
    //归账金额
    self.outAmountLbl = [UILabel labelWithText:@"归账金额:" textColor:kTextColor2 textFont:14.0];
    
    self.outAmountLbl.backgroundColor = kClearColor;
    self.outAmountLbl.frame = CGRectMake(leftMargin, amountTf.yy, kScreenWidth - 2*leftMargin, 40);
    
    [self.bgView addSubview:self.outAmountLbl];
    
    //支付密码
    self.payPwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.amountTf.yy + 40, kScreenWidth, 40) leftTitle:@"支付密码" titleWidth:100 placeholder:@"请输入支付密码"];
    
    self.payPwdTf.secureTextEntry = YES;
    self.payPwdTf.isSecurity = YES;
    self.payPwdTf.returnKeyType = UIReturnKeyDone;
    self.payPwdTf.delegate = self;

    [self.bgView addSubview:self.payPwdTf];
    
    //归账
    UIButton *backMoneyBtn = [UIButton buttonWithTitle:@"归账" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
    
    backMoneyBtn.frame = CGRectMake(leftMargin, self.bgView.yy + 25, kScreenWidth - 2*leftMargin, 45);
    
    [backMoneyBtn addTarget:self action:@selector(backMoney) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backMoneyBtn];
    
    self.backMoneyBtn = backMoneyBtn;
    
    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, backMoneyBtn.yy + 10, kScreenWidth - 30, 20) title:@"您还未设置支付密码,前往设置->" backgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:setPwdBtn];
    [setPwdBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[TLUser user].tradepwdFlag isEqualToString:@"1"]) {
        setPwdBtn.hidden = YES;
    }
}

#pragma mark - Setting
- (void)setRepayAccount:(NSString *)repayAccount {

    _repayAccount = repayAccount;
    
    [self initSubviews];

//    [self.view layoutIfNeeded];

}

- (void)setRepayRemark:(NSString *)repayRemark {

    _repayRemark = repayRemark;
    
    //注意事项
//
    CGFloat height = ([_repayRemark componentsSeparatedByString:@"\n"].count+1)*25;
    
    UILabel *promptLbl = [UILabel labelWithText:@"" textColor:[UIColor zh_themeColor] textFont:13.0];
    
    [promptLbl labelWithTextString:_repayRemark lineSpace:10];
    
    promptLbl.backgroundColor = kClearColor;
    
    promptLbl.numberOfLines = 0;
    
    promptLbl.frame = CGRectMake(15, self.backMoneyBtn.yy + 40, kScreenWidth - 2*15, height);
    
    [self.view addSubview:promptLbl];
//
}

#pragma mark - Data

- (void)requestBackRate {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802027";
    
    http.parameters[@"key"] = @"GUIZAHNG_RATE";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.rate = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestAccount {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    
    http.parameters[@"ckey"] = @"repayAccount";

    [http postWithSuccess:^(id responseObject) {
        
        self.repayAccount = responseObject[@"data"][@"note"];
        
        //获取备注
        [self requestRemark];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestRemark {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    
    http.parameters[@"ckey"] = @"repayRemark";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.repayRemark = responseObject[@"data"][@"note"];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Events
- (void)backMoney {
    
    if(![self.amountTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入归账金额"];
        return;
        
    }
    
    //
    if ([self.amountTf.text greaterThan:self.balance]) {
        
        [TLAlert alertWithInfo:@"归账金额大于待归账金额"];
        return;
    }
    
    if (![self.payPwdTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入支付密码"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802433";
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"remark"] = @"用户申请";
    http.parameters[@"cbAmount"] = [NSString stringWithFormat:@"%@", [self.amountTf.text convertToSysMoney]];   //@"-100";
    
    http.parameters[@"tradePwd"] = self.payPwdTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"归账成功,我们将会对您的申请进行审核"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)textDidChange:(UITextField *)sender {

    CGFloat money = [sender.text doubleValue]*[self.rate doubleValue];
    
    self.outAmountLbl.text = [NSString stringWithFormat:@"归账金额: %.2lf", money];
}

#pragma mark- 设置交易密码
- (void)setTrade:(UIButton *)btn {
    
    TLPwdRelatedVC *tradeVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeSetTrade];
    tradeVC.success = ^() {
        
        btn.hidden = YES;
        
    };
    
    [self.navigationController pushViewController:tradeVC animated:YES];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.payPwdTf) {
        
        [self.payPwdTf resignFirstResponder];
    }
    
    return YES;
}

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
