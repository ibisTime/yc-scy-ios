//
//  QRCodeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "QRCodeVC.h"
#import "SGQRCodeTool.h"

@interface QRCodeVC ()

@property (nonatomic, strong) UIImageView *qrCodeImageView;

@end

@implementation QRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"获客"];

    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *qrCodeImageView = [[UIImageView alloc] init];
    [self.view addSubview:qrCodeImageView];
    
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-40);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(280);
    }];
    
    self.qrCodeImageView = qrCodeImageView;
    
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(20)
                                     textColor:[UIColor zh_themeColor]];
    [self.view addSubview:hintLbl];
    hintLbl.text = @"微信扫一扫，更多优惠等你来";
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrCodeImageView.mas_bottom).offset(30);
        make.width.equalTo(self.view.mas_width);
    }];
    [self getUrl];
}

- (void)getUrl {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"807717";
    http.parameters[@"ckey"] = @"domainUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *url = responseObject[@"data"][@"note"];

        NSString *shareStr = [NSString stringWithFormat:@"%@?userRefereeKind=taster&userReferee=%@", url, [TLUser user].mobile];
//
        UIImage *image = [SGQRCodeTool SG_generateWithDefaultQRCodeData: shareStr
                                                         imageViewWidth:kScreenWidth];
        
        self.qrCodeImageView.image = image;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
