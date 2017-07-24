//
//  OrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderModel.h"
#import "OrderGoodsCell.h"
#import "OrderFooterView.h"
#import "OrderDetailVC.h"

@interface OrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *shoppingListTableV;
@property (nonatomic,strong) NSMutableArray <OrderModel *>*orderGroups;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation OrderListVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.shoppingListTableV beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"订单列表"];

    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(back)];
    
    self.isFirst = YES;
    
    [self initTableView];
}

- (void)initTableView {

    TLTableView *tableView = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 100;
    
    self.shoppingListTableV = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无订单"];
    
    //--//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808068";
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"applyUser"] = [TLUser user].userId;
    //    helper.parameters[@"type"] = @"1";
    //    helper.parameters[@"statusList"] = @[@"2", @"3", @"4", @"91", @"92", @"93"];
    
    helper.isDeliverCompanyCode = NO;
    
    //    if(self.status == OrderStatusWillSend) {
    //
    //        helper.parameters[@"status"] = @"2";
    //
    //    } else if(self.status == OrderStatusWillReceipt)  {
    //
    //        helper.parameters[@"status"] = @"3";
    //
    //    } else {//全部
    //
    //
    //    }
    
    //    1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
    
    //    if (self.statusCode) {
    //        helper.parameters[@"status"] = self.statusCode;
    //    }
    
    
    helper.tableView = self.shoppingListTableV;
    [helper modelClass:[OrderModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.shoppingListTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.shoppingListTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoppingListTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.shoppingListTableV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoppingListTableV endRefreshingWithNoMoreData_tl];
}

- (void)qx
{
    
    //取消订单
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808052";
    http.parameters[@"code"] = @"";
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (UIView *)headerViewWithOrderNum:(NSString *)num date:(NSString *)date {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    
    headerV.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    v.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:v];
    
    UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];
    [headerV addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV.mas_left).offset(15);
        make.top.equalTo(headerV.mas_top).offset(10);
        make.bottom.equalTo(headerV.mas_bottom);
    }];
    lbl1.text = num;
    
    //
    UILabel *lbl2 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];;
    [headerV addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl1.mas_right).offset(-15);
        make.top.equalTo(lbl1.mas_top);
        make.bottom.equalTo(headerV.mas_bottom);
        make.right.equalTo(headerV.mas_right).offset(-15);
    }];
    lbl2.text = [date convertDate];
    
    //
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerV.height - 0.7, kScreenWidth, 0.7)];
    line.backgroundColor = [UIColor zh_lineColor];
    [headerV addSubview:line];
    
    return headerV;
    
}

#pragma mark - Events

- (void)back {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- datasourece

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderGroups.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"OrderGoodsCell";
    OrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[OrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        
    }
    
    cell.order = self.orderGroups[indexPath.section];
    
    return cell;
    
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EatWeakSelf;
    
    OrderDetailVC *vc = [[OrderDetailVC alloc] init];
    vc.order = self.orderGroups[indexPath.section];
    
    //未支付订单，支付成功
    vc.paySuccess = ^(){
        
        [weakSelf.shoppingListTableV beginRefreshing];
    };
    
    vc.cancleSuccess = ^(){
        
        [weakSelf.shoppingListTableV beginRefreshing];
    };
    
    vc.confirmReceiveSuccess = ^(){
        
        [weakSelf.shoppingListTableV beginRefreshing];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderModel *model = self.orderGroups[section];
    return [self headerViewWithOrderNum:model.code date:model.applyDatetime];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString * footerId = @"OrderFooterViewId";
    OrderFooterView *footerView = [[OrderFooterView alloc] initWithReuseIdentifier:footerId];
    footerView.order = self.orderGroups[section];
    return footerView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 98;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
