//
//  GoodListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodListVC.h"

#import "GoodListTableView.h"

@interface GoodListVC ()

@property (nonatomic, strong)  GoodListTableView *tableView;

@property (nonatomic, strong) NSMutableArray <GoodModel*>*goods;

@end

@implementation GoodListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"商品列表"];
    
    [self initTableView];

    [self requestGoods];

}

#pragma mark - Init;
- (void)initTableView {
    
    EatWeakSelf;
    
    self.tableView = [[GoodListTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    
    self.tableView.goodBlock = ^(NSInteger index) {
        
        if (weakSelf.selectBlock) {
            
            weakSelf.selectBlock(weakSelf.goods[index]);

            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    };
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无产品"];

    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)requestGoods {
    
    EatWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    helper.code = @"808025";
    helper.kind = @"";

    helper.parameters[@"status"] = @"3";
    
    helper.parameters[@"category"] = @"normal";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[GoodModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.goods = objs;
        
        weakSelf.tableView.goods = objs;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            
            weakSelf.tableView.goods = objs;
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
