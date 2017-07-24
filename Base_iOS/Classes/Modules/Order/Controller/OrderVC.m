//
//  OrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderVC.h"
#import "OrderListVC.h"
#import "ZHSegmentView.h"

@interface OrderVC ()<ZHSegmentViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *switchScrollV;

@property (nonatomic,strong) OrderListVC *allVC;
@property (nonatomic,strong) OrderListVC *willReceiptVC;
@property (nonatomic,strong) OrderListVC *willSendVC;

@property (nonatomic,strong) NSMutableArray *isAdd;

@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"商品订单"];
    
    ZHSegmentView *segmentView =  [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 45)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
    segmentView.tagNames = @[@"全部",@"待发货",@"待收货"];
    self.isAdd = [@[@1, @0, @0] mutableCopy];
    
    //
    UIScrollView *switchScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentView.yy + 0.5, kScreenWidth, kScreenHeight - 64 - segmentView.yy)];
    switchScrollV.pagingEnabled = YES;
    switchScrollV.contentSize = CGSizeMake(kScreenWidth * 3, switchScrollV.height);
    [self.view addSubview:switchScrollV];
    self.switchScrollV = switchScrollV;
    switchScrollV.scrollEnabled = NO;
    
    //
    [self addChildViewController:self.allVC];
    
}

- (OrderListVC *)willSendVC {
    
    if (!_willSendVC) {
        
        _willSendVC = [[OrderListVC alloc] init];
        _willSendVC.status = OrderStatusWillSend;
        _willSendVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.switchScrollV.height);
        
        [self.switchScrollV addSubview:_willSendVC.view];
    }
    return _willSendVC;
    
}
- (OrderListVC *)allVC {
    
    if (!_allVC) {
        _allVC = [[OrderListVC alloc] init];
        
        _allVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.switchScrollV.height);
        _allVC.status = OrderStatusAll;
        [self.switchScrollV addSubview:_allVC.view];
        
    }
    return _allVC;
}

- (OrderListVC *)willReceiptVC {
    
    if (!_willReceiptVC) {
        _willReceiptVC = [[OrderListVC alloc] init];
        
        _willReceiptVC.status = OrderStatusWillReceipt;
        _willReceiptVC.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.switchScrollV.height);
    }
    return _willReceiptVC;
    
    
}

- (BOOL)segmentSwitch:(NSInteger)idx {
    
    [self.switchScrollV setContentOffset:CGPointMake(idx*kScreenWidth, 0) animated:YES];
    if (idx == 0) {
        
    } else if(idx == 1) {
        
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.willSendVC];
            [self.switchScrollV addSubview:_willSendVC.view];
            
        } else {
            
            self.isAdd[idx] = @1;
        }
        
    } else if (idx == 2){
        
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.willReceiptVC];
            [self.switchScrollV addSubview:_willReceiptVC.view];
            
            
        } else {
            
            self.isAdd[idx] = @1;
        }
        
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
