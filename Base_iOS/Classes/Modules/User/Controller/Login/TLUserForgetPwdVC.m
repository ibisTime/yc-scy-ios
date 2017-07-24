//
//  TLUserForgetPwdVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLUserForgetPwdVC.h"
#import "CaptchaView.h"

@interface TLUserForgetPwdVC ()

@property (nonatomic,strong) AccountTf *phoneTf;
@property (nonatomic,strong) AccountTf *pwdTf;
@property (nonatomic,strong) AccountTf *rePwdTf;
@property (nonatomic, strong) CaptchaView *captchaView;

@end

@implementation TLUserForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"找回密码"];
    
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {

    self.view.backgroundColor = kWhiteColor;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    UIView *bgView = [[UIView alloc] init];
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(4*h+3*middleMargin);
        make.width.mas_equalTo(w + margin);
        
    }];
    
    //账号
    AccountTf *phoneTf = [[AccountTf alloc] initWithFrame:CGRectMake(margin, 0, w, h)];
    phoneTf.placeHolder = @"请输入手机号";
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机"];
    [bgView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + middleMargin, w, h)];
    [bgView addSubview:captchaView];
    captchaView.captchaTf.placeHolder = @"请输入验证码";
    captchaView.captchaTf.leftIconView.image = [UIImage imageNamed:@"验证码"];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.captchaView = captchaView;
    
    //密码
    AccountTf *pwdTf = [[AccountTf alloc] initWithFrame:CGRectMake(margin, captchaView.yy + middleMargin, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.placeHolder = @"请输入密码";
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    [bgView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //re密码
    AccountTf *rePwdTf = [[AccountTf alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + middleMargin, w, h)];
    rePwdTf.secureTextEntry = YES;
    rePwdTf.placeHolder = @"重新输入";
    [bgView addSubview:rePwdTf];
    rePwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    self.rePwdTf = rePwdTf;
    
    //
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(h);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(45);
        
    }];
}

#pragma mark - Events

- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)changePwd {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    if (![self.pwdTf.text isEqualToString:self.rePwdTf.text]) {
        
        [TLAlert alertWithInfo:@"输入的密码不一致"];
        return;
        
    }
    
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"loginPwdStrength"] = @"2";
    http.parameters[@"newLoginPwd"] = self.pwdTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"找回成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
