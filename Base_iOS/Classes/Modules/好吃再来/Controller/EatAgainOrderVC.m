//
//  EatAgainOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "EatAgainOrderVC.h"

#import "ZHReceivingAddress.h"
#import "GoodModel.h"
#import "CurrencyModel.h"
#import "CDGoodsParameterModel.h"

#import "GoodListVC.h"
#import "OrderVC.h"
#import "OrderListVC.h"

#import "TLPickerTextField.h"
#import "TextView.h"

@interface EatAgainOrderVC ()<UITextFieldDelegate>

@property (nonatomic, strong) ZHReceivingAddress *address;

@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;

@property (nonatomic, strong) GoodModel *good;

@property (nonatomic, strong) TLTextField *realNameTF;  //姓名

@property (nonatomic, strong) TLTextField *mobileTF;    //手机号

@property (nonatomic, strong) TextView *addressTF;   //地址

@property (nonatomic, strong) TLTextField *goodNameTF;  //商品

@property (nonatomic, strong) TLPickerTextField *goodSpecsTF; //规格

@property (nonatomic, strong) TLTextField *goodNumTF;   //数量

@property (nonatomic, strong) TLTextField *moneyTF;     //消费总额

@property (nonatomic, strong) UILabel *leftMoneyLabel;

@property (nonatomic, copy) NSArray <CurrencyModel *>*currencyRoom;

@property (nonatomic, assign) CGFloat totalAmount;      //商品总额

@property (nonatomic, assign) NSInteger selectIndex;    //当前规格

@property (nonatomic, strong) NSMutableArray *specs;    //规格名

@property (nonatomic, strong) NSNumber *balance;        //可用余额

@end

@implementation EatAgainOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"下单"];

    [UIBarButtonItem addRightItemWithTitle:@"查看" frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(lookOrder:)];
    
    self.view.backgroundColor = kBackgroundColor;

    [self getAddress];
}

#pragma mark - Init
- (void)initSubviews {
    
    EatWeakSelf;
    
    //收件人
    TLTextField *realNameTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"收件人" titleWidth:90 placeholder:@"请输入收件人"];
    
    realNameTf.text = self.address.addressee;
    realNameTf.textColor = kTextColor;
    
    [self.view addSubview:realNameTf];
    self.realNameTF = realNameTf;
    
    //手机号
    TLTextField *mobileTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, realNameTf.yy + 1, kScreenWidth, 45) leftTitle:@"手机号" titleWidth:90 placeholder:@"请输入手机号"];
    
    mobileTf.text = self.mobile ? self.mobile: self.address.mobile;
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
    
    //商品
    self.goodNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, addressTf.yy + 1, kScreenWidth, 45) leftTitle:@"商品" titleWidth:90 placeholder:@"请选择商品"];
    
    self.goodNameTF.enabled = NO;
    self.goodNameTF.textColor = kTextColor;

    [self.view addSubview:self.goodNameTF];
    
    //商品按钮
    UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    goodBtn.frame = CGRectMake(105, addressTf.yy + 1, kScreenWidth - 105, 45);
    [goodBtn addTarget:self action:@selector(selectGood:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goodBtn];
    
    //规格
    self.goodSpecsTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, self.goodNameTF.yy + 1, kScreenWidth, 45) leftTitle:@"规格" titleWidth:90 placeholder:@"请选择规格"];
    
    self.goodSpecsTF.delegate = self;
    self.goodSpecsTF.textColor = kTextColor;
    
    self.goodSpecsTF.didSelectBlock = ^(NSInteger index) {
    
        weakSelf.selectIndex = index;
        
        weakSelf.goodSpecsTF.text = weakSelf.specs[index];

        weakSelf.goodNumTF.enabled = YES;
        
        [weakSelf calculatTotalPrice];

    };
    
    [self.view addSubview:self.goodSpecsTF];

    //数量
    self.goodNumTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.goodSpecsTF.yy + 1, kScreenWidth, 45) leftTitle:@"数量" titleWidth:90 placeholder:@"请输入数量"];
    
    self.goodNumTF.keyboardType = UIKeyboardTypeNumberPad;
    self.goodNumTF.textColor = kTextColor;
    
    [self.goodNumTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.goodNumTF addTarget:self action:@selector(textWillChange:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self.view addSubview:self.goodNumTF];
    
    //商品价格
    self.moneyTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.goodNumTF.yy + 30, kScreenWidth, 45) leftTitle:@"本次使用信用分：" titleWidth:145 placeholder:@""];
    
    self.moneyTF.textColor = [UIColor zh_themeColor];
    
    self.moneyTF.enabled = NO;
    
    [self.view addSubview:self.moneyTF];
    
    //可用金额
    self.leftMoneyLabel = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    self.leftMoneyLabel.backgroundColor = kClearColor;
    
    self.leftMoneyLabel.frame = CGRectMake(15, self.moneyTF.yy, kScreenWidth, 45);
    
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
    
    if (self.goodNameTF.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请选择商品"];
        return;
    }
    
    if (self.goodSpecsTF.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请选择规格"];
        return;
    }
    
    if (self.goodNumTF.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请输入商品数"];
        return;
    }
    
    if ([self.goodNumTF.text integerValue] <= 0) {
        
        [TLAlert alertWithInfo:@"商品数必须大于0"];
        return;
    }
    
    if ([self.moneyTF.text greaterThan:self.balance]) {
        
        [TLAlert alertWithInfo:@"信用分不足"];
        return;
    }
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"是否要支付该订单?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"808061";
        http.parameters[@"receiver"] = self.realNameTF.text;
        http.parameters[@"reMobile"] = self.mobileTF.text;
        http.parameters[@"reAddress"] = self.addressTF.textView.text;
        http.parameters[@"applyUser"] = [TLUser user].userId;
        http.parameters[@"quantity"] = self.goodNumTF.text;
        
        if (_good.productSpecsList.count > 0) {
            
            CDGoodsParameterModel *specs = _good.productSpecsList[self.selectIndex];
            
            http.parameters[@"productSpecsCode"] = specs.code;
        }
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"下单成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //            [self.navigationController popViewControllerAnimated:YES];
                OrderListVC *orderListVC = [OrderListVC new];
                
                orderListVC.status = OrderStatusAll;
                
                [self.navigationController pushViewController:orderListVC animated:YES];
                
            });
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }]];
    
    
    [self presentViewController:alertCtrl animated:YES completion:nil];

}

- (void)selectGood:(UIButton *)sender {

    EatWeakSelf;
    
    GoodListVC *goodListVC = [GoodListVC new];
    
    goodListVC.selectBlock = ^(GoodModel *good) {
        
        weakSelf.good = good;
        
        weakSelf.specs = [NSMutableArray array];
        
        for (CDGoodsParameterModel *goodSpecs in good.productSpecsList) {
            
            NSString *weight = @"";
            
            if (goodSpecs.weight) {
                
                weight = [NSString stringWithFormat:@"重量: %@kg", goodSpecs.weight];
                
            }
            
            NSString *province = @"";
            
            if (goodSpecs.province) {
                
                province = [NSString stringWithFormat:@"发货地: %@", goodSpecs.province];
            }
            
            NSString *specsStr = [NSString stringWithFormat:@"%@ %@ %@", goodSpecs.name, weight, province];
            
            [self.specs addObject:specsStr];
        }
        
        weakSelf.goodSpecsTF.tagNames = weakSelf.specs;
        
        weakSelf.goodSpecsTF.text = weakSelf.specs[0];
        
        weakSelf.selectIndex = 0;
        
        weakSelf.goodNameTF.text = good.name;

        weakSelf.goodNumTF.text = @"1";
        
        [weakSelf calculatTotalPrice];
        
    };
    
    [self.navigationController pushViewController:goodListVC animated:YES];
}

- (void)textWillChange:(UITextField *)sender {

    if (self.goodNameTF.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请先选择商品"];
        sender.enabled = NO;
        return;
    }
    
    if (self.goodSpecsTF.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请先选择规格"];
        
        sender.enabled = NO;
        return;
    }
}

- (void)textDidChange:(UITextField *)sender {
    
    [self calculatTotalPrice];
}

- (void)calculatTotalPrice {

    CDGoodsParameterModel *specs = self.good.productSpecsList[self.selectIndex];
    
    CGFloat price = [specs.price2 doubleValue];
    
    self.totalAmount = [self.goodNumTF.text integerValue]*1.0*price;
    
    self.moneyTF.text = [[NSNumber numberWithDouble:self.totalAmount] convertToSimpleRealMoney];
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

- (void)getAddress {
    
    //查询是否有收货地址
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805165";
    
    http.parameters[@"userId"] = self.userId ? self.userId: [TLUser user].userId;
    
    http.parameters[@"token"] = [TLUser user].token;
    //    http.parameters[@"isDefault"] = @"0"; //是否为默认收货地址
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *adderssRoom = responseObject[@"data"];
        
        if (adderssRoom.count > 0) { //有收件地址
            
            self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];
            //给一个默认地址
            self.address = self.addressRoom[0];
            self.address.isSelected = YES;
            
        }
        
        [self initSubviews];
        
        [self getAccountInfo];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

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
                
                self.balance = obj.amount;
                
                self.leftMoneyLabel.text = [NSString stringWithFormat:@"可用信用：%@", [obj.amount convertToRealMoney]];
                //                self.accountNumber = obj.accountNumber;
            }
            
        }];
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if ([textField isKindOfClass:[TLPickerTextField class]]) {
        
        if (self.goodNameTF.text.length == 0) {
            
            [TLAlert alertWithInfo:@"请先选择商品"];
            
            return NO;
            
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
