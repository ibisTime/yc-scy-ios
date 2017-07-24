//
//  EatOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "EatOrderVC.h"
#import "CurrencyModel.h"
#import "OrderListVC.h"
#import "TLPickerTextField.h"
#import "TextView.h"

@interface EatOrderVC ()<UITextFieldDelegate>

@property (nonatomic, strong) TLTextField *realNameTF;  //姓名

@property (nonatomic, strong) TLTextField *mobileTF;    //手机号

@property (nonatomic, strong) TextView *addressTF;   //地址

@property (nonatomic, strong) TLTextField *goodNameTF;  //商品

@property (nonatomic, strong) TLPickerTextField *goodSpecsTF; //规格

@property (nonatomic, strong) TLTextField *goodNumTF;   //数量

@property (nonatomic, strong) UILabel *leftMoneyLabel;

@property (nonatomic, copy) NSArray <CurrencyModel *>*currencyRoom;

@property (nonatomic, copy) NSString *balance;          //余额

@property (nonatomic, strong) NSMutableArray *specs;    //规格名

@property (nonatomic, assign) NSInteger selectIndex;    //当前规格

@end

@implementation EatOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel labelWithTitle:@"下单"];
    
    [UIBarButtonItem addRightItemWithTitle:@"查看" frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(lookOrder:)];

    self.view.backgroundColor = kBackgroundColor;
}

#pragma mark - Setting

- (void)setAddress:(ZHReceivingAddress *)address {

    _address = address;
    
    [self initSubviews];
    
    [self getAccountInfo];
}

- (void)setGood:(GoodModel *)good {

    _good = good;
    
    self.specs = [NSMutableArray array];
    
    for (CDGoodsParameterModel *goodSpecs in _good.productSpecsList) {
        
        NSString *weight = @"";
        
        if (goodSpecs.weight) {
            
            weight = [NSString stringWithFormat:@" 重量: %@kg", goodSpecs.weight];
            
        }
        
        NSString *province = @"";
        
        if (goodSpecs.province) {
            
            province = [NSString stringWithFormat:@" 发货地: %@", goodSpecs.province];
        }
        
        NSString *specsStr = [NSString stringWithFormat:@"%@%@%@", goodSpecs.name, weight, province];
        
        [self.specs addObject:specsStr];
        
    }
    
    self.goodSpecsTF.tagNames = self.specs;
    
    
    self.goodSpecsTF.text = self.specs[0];
    
    self.selectIndex = 0;
    
    self.goodNameTF.text = _good.name;
    
    self.goodNumTF.text = @"1";

}

#pragma mark - Init
- (void)initSubviews {

    EatWeakSelf;
    
    TLTextField *realNameTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) leftTitle:@"收件人" titleWidth:90 placeholder:@"请输入收件人"];
    
    realNameTf.text = self.address.addressee;
    realNameTf.textColor = kTextColor;

    [self.view addSubview:realNameTf];
    self.realNameTF = realNameTf;
    
    TLTextField *mobileTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, realNameTf.yy + 1, kScreenWidth, 40) leftTitle:@"手机号" titleWidth:90 placeholder:@"请输入手机号"];
    
    mobileTf.text = self.address.mobile;
    mobileTf.textColor = kTextColor;

    [self.view addSubview:mobileTf];
    
    self.mobileTF = mobileTf;
    
    //地址
    
    NSString *address = self.address ? [NSString stringWithFormat:@"%@%@%@%@", self.address.province, self.address.city, self.address.district, self.address.detailAddress]: @"";
    
    CGSize size = [address calculateStringSize:CGSizeMake(kScreenWidth - 100 - 30, MAXFLOAT) font:Font(15.0)];
    
    TextView *addressTf = [[TextView alloc] initWithFrame:CGRectMake(0, mobileTf.yy + 1, kScreenWidth, size.height + 25) leftTitle:@"收件地址" titleWidth:90 placeholder:@"请输入收货地址"];
    
    addressTf.content = address;
    //    addressTf.textColor = kTextColor;
    
    [self.view addSubview:addressTf];
    self.addressTF = addressTf;
    
    self.goodNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, addressTf.yy + 1, kScreenWidth, 40) leftTitle:@"商品" titleWidth:90 placeholder:@""];
    
    self.goodNameTF.enabled = NO;
    self.goodNameTF.textColor = kTextColor;

    [self.view addSubview:self.goodNameTF];
    
    //规格
    self.goodSpecsTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, self.goodNameTF.yy + 1, kScreenWidth, 40) leftTitle:@"规格" titleWidth:90 placeholder:@"请选择规格"];
    
    self.goodSpecsTF.delegate = self;
    self.goodSpecsTF.textColor = kTextColor;
    
    self.goodSpecsTF.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.selectIndex = index;
        
        weakSelf.goodSpecsTF.text = weakSelf.specs[index];
        
        
    };

    [self.view addSubview:self.goodSpecsTF];
    
    self.goodNumTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.goodSpecsTF.yy + 1, kScreenWidth, 40) leftTitle:@"数量" titleWidth:90 placeholder:@""];
    
    self.goodNumTF.text = @"1";
    self.goodNumTF.textColor = kTextColor;

    self.goodNumTF.enabled = NO;
    
    [self.view addSubview:self.goodNumTF];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.goodNumTF.yy + 40, kScreenWidth, 40)];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    
    UILabel *moneyLabel = [UILabel labelWithText:@"本次使用信用分：1" textColor:kTextColor textFont:15.0];
    
    moneyLabel.frame = CGRectMake(15, 0, kScreenWidth, 40);
    
    [bgView addSubview:moneyLabel];
    
    self.leftMoneyLabel = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    self.leftMoneyLabel.backgroundColor = kClearColor;
    
    self.leftMoneyLabel.frame = CGRectMake(15, bgView.yy, kScreenWidth, 45);
    
    [self.view addSubview:self.leftMoneyLabel];
    
    //确定
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(15, self.leftMoneyLabel.yy + 25, kScreenWidth - 30, 45);
    
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
}

#pragma mark - Events

- (void)confirm:(UIButton *)sender {

    if (![self.mobileTF.text isPhoneNum]) {
        [TLAlert alertWithInfo:@"请输入正确的手机号码"];
        return;
    }
    
    if (![self.realNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入收件人"];
    }
    
    if (![self.addressTF.textView.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入收件地址"];
        return;
    }

    if ([self.balance doubleValue] < 1) {
        
        [TLAlert alertWithInfo:@"信用分不足"];
        return;
    }
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"是否要支付该订单?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"808060";
        http.parameters[@"receiver"] = self.realNameTF.text;
        http.parameters[@"reMobile"] = self.mobileTF.text;
        http.parameters[@"reAddress"] = self.addressTF.textView.text;
        http.parameters[@"applyUser"] = [TLUser user].userId;
        if (_good.productSpecsList.count > 0) {
            
            CDGoodsParameterModel *specs = _good.productSpecsList[0];
            
            http.parameters[@"productSpecsCode"] = specs.code;
        }
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"下单成功"];
            
            //        [self.navigationController popViewControllerAnimated:YES];
            OrderListVC *orderListVC = [OrderListVC new];
            
            orderListVC.status = OrderStatusAll;
            
            [self.navigationController pushViewController:orderListVC animated:YES];
            
        } failure:^(NSError *error) {
            
            
        }];

        
    }]];

    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}

- (void)lookOrder:(UIButton *)sender {
    
    //    OrderVC *orderVC = [OrderVC new];
    //
    //    [self.navigationController pushViewController:orderVC animated:YES];
    OrderListVC *orderListVC = [OrderListVC new];
    
    orderListVC.status = OrderStatusAll;
    
    [self.navigationController pushViewController:orderListVC animated:YES];
    
}

#pragma mark - Data
- (void)getAccountInfo {

    //查询账户信息
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        self.currencyRoom = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //---//
        [self.currencyRoom enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if( [obj.currency isEqualToString:kXYF]) {
                
                self.balance = [obj.amount convertToRealMoney];
                
                self.leftMoneyLabel.text = [NSString stringWithFormat:@"可用信用：%@", [obj.amount convertToRealMoney]];
//                self.accountNumber = obj.accountNumber;
            }
            
        }];
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
