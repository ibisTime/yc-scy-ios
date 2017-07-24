//
//  MyFriendsVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MyFriendsVC.h"

#import "FriendsTableView.h"

#import "FriendModel.h"

#import "QRCodeVC.h"

#import "EatAgainOrderVC.h"

@interface MyFriendsVC ()

@property (nonatomic, strong)  FriendsTableView *tableView;

@property (nonatomic, strong) NSMutableArray <FriendModel *>*friends;

@end

@implementation MyFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel labelWithTitle:@"干点正事"];
    
    [UIBarButtonItem addRightItemWithTitle:@"好友" frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(goodFriend)];
    
    [self initTableView];
    
    [self requestFriends];

}

#pragma mark - Init;
- (void)initTableView {
    
    EatWeakSelf;
    
    self.tableView = [[FriendsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    
    self.tableView.friendBlock = ^(NSInteger index) {
        
        FriendModel *friend = weakSelf.friends[index];
        
        UserExt *userExt = friend.userExt;
        
        EatAgainOrderVC *againOrderVC = [EatAgainOrderVC new];
        
        againOrderVC.userId = userExt.userId;
        
        againOrderVC.mobile = userExt.mobile;
        
        [weakSelf.navigationController pushViewController:againOrderVC animated:YES];
        
    };
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无获客"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)requestFriends {
    
    EatWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    helper.code = @"805054";
    helper.kind = @"f1";
    helper.parameters[@"userReferee"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    //    helper.parameters[@"orderColumn"] = @"order_no";
    //    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[FriendModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.friends = objs;
        
        weakSelf.tableView.friends = objs;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.friends = objs;
            
            weakSelf.tableView.friends = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - Events
- (void)goodFriend {
    
    QRCodeVC *qrCodeVC = [QRCodeVC new];
    
    [self.navigationController pushViewController:qrCodeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
