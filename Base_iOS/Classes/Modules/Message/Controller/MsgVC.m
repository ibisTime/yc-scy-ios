//
//  MsgVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MsgVC.h"

#import "TLPageDataHelper.h"
#import "Msg.h"

#import "MsgCell.h"

@interface MsgVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <Msg *> *msgs;

@property (nonatomic,strong) TLTableView *msgTV;

@end

@implementation MsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
}

#pragma mark - Init

- (void)initTableView {

    self.navigationItem.titleView = [UILabel labelWithTitle:@"系统消息"];
    TLTableView *msgTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)
                                                       delegate:self
                                                     dataSource:self];
    msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:msgTableView];
    self.msgTV = msgTableView;
    
    msgTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无消息"];
    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"804040";
    pageDataHelper.tableView = msgTableView;
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"channelType"] = @"4";
    
    pageDataHelper.parameters[@"pushType"] = @"41";
    pageDataHelper.parameters[@"toKind"] = @"4";
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    pageDataHelper.parameters[@"start"] = @"1";
    pageDataHelper.parameters[@"limit"] = @"10";
    pageDataHelper.parameters[@"status"] = @"1";
    pageDataHelper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    
    //0 未读 1 已读 2未读被删 3 已读被删
    //    pageDataHelper.parameters[@"status"] = @"0";
    //    pageDataHelper.parameters[@"dateStart"] = @""; //开始时间
    [pageDataHelper modelClass:[Msg class]];
    
    [msgTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            self.msgs = objs;
            [weakSelf.msgTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [msgTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            self.msgs = objs;
            [weakSelf.msgTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }];
    
    [msgTableView endRefreshingWithNoMoreData_tl];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.msgTV beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *msgCellId = @"msgCellId";
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:msgCellId];
    
    if (!cell) {
        cell = [[MsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgCellId];
    }
    
    cell.msg = self.msgs[indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.msgs[indexPath.row].contentHeight + 20 + 15 + 73;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
