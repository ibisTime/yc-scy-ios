//
//  BackMoneyBillVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BackMoneyBillVC.h"
#import "TLPageDataHelper.h"
#import "BackMoneyTableView.h"
#import "BillModel.h"

@interface BackMoneyBillVC ()

@property (nonatomic, strong) BackMoneyTableView *tableView;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@end

@implementation BackMoneyBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"归账账单"];
    
}

- (void)setAccountNumber:(NSString *)accountNumber {
    
    _accountNumber = accountNumber;
    
    [self initTableView];
    
    [self requestBillList];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[BackMoneyTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)requestBillList {
    
    //--//
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    
    pageDataHelper.tableView = self.tableView;
    
    pageDataHelper.code = @"802027";
    pageDataHelper.parameters[@"key"] = @"repayAccount";
//    pageDataHelper.parameters[@"start"] = @"1";
//    pageDataHelper.parameters[@"limit"] = @"10";
//    pageDataHelper.parameters[@"accountNumber"] = _accountNumber;
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"companyCode"] = [AppConfig config].companyCode;
    pageDataHelper.parameters[@"systemCode"] = [AppConfig config].systemCode;
    
    //0 刚生成待回调，1 已回调待对账，2 对账通过, 3 对账不通过待调账,4 已调账,9,无需对账
    //pageDataHelper.parameters[@"status"] = [ZHUser user].token;
    [pageDataHelper modelClass:[BillModel class]];
    
    [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.tableView.bills = objs;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
