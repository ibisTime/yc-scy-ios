//
//  EatListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "EatListVC.h"

#import "EatListTableView.h"
#import "ZHAddressChooseView.h"
#import "ZHReceivingAddress.h"

#import "ZHAddressChooseVC.h"
#import "ZHAddAddressVC.h"
#import "EatOrderVC.h"
#import "CommentVC.h"

#import "GoodModel.h"

@interface EatListVC ()<RefreshDelegate>

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong)  EatListTableView *tableView;

@property (nonatomic,strong) ZHReceivingAddress *currentAddress;

@property (nonatomic,strong) ZHAddressChooseView *chooseView;

@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;

@property (nonatomic, strong) NSMutableArray <GoodModel*>*goods;

@end

@implementation EatListVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //根据有无地址创建UI
    [self getAddress];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我要试吃"];
    
    [self initTableView];

}

#pragma mark - Init

- (ZHAddressChooseView *)chooseView {
    
    if (!_chooseView) {
        
        __weak typeof(self) weakself = self;
        //头部有个底 可以添加，有地址时的ui和无地址时的ui
        _chooseView = [[ZHAddressChooseView alloc] initWithFrame:self.headerView.bounds];
        
        _chooseView.chooseAddress = ^(){
            
            [weakself chooseAddress];
        };
    }
    return _chooseView;
    
}

- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 75)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
    
}

//#pragma mark- 有收获地址时的头部UI
- (void)setHaveAddressUI {
    
    if (self.headerView.subviews.count > 0) {
        
        [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    }
    [self.headerView addSubview:self.chooseView];
    
    self.tableView.tableHeaderView = self.headerView;

}

- (void)setNoAddressUI {
    
    UIView *addressView = self.headerView;
    self.tableView.tableHeaderView = addressView;
    
    //btn
    UIButton *addBtn = [UIButton buttonWithTitle:@"+ 添加收货地址" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:14.0 cornerRadius:5];
    
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
        make.centerY.mas_equalTo(0);
        
    }];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 2)];
    [_headerView addSubview:line];
    line.y = _headerView.height - 2;
    line.image = [UIImage imageNamed:@"address_line"];
    
}

- (void)initTableView {

    EatWeakSelf;
    
    self.tableView = [[EatListTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    
    self.tableView.eatBlock = ^(EatStatusType statusType, NSInteger index) {
      
        if (statusType == EatStatusTypeEat) {
            
            EatOrderVC *orderVC = [EatOrderVC new];
            
            orderVC.address = weakSelf.currentAddress;
            
            orderVC.good = weakSelf.goods[index];
            
            [weakSelf.navigationController pushViewController:orderVC animated:YES];
            
        } else if (statusType == EatStatusTypeComment) {
        
//            CommentVC *commentVC = [CommentVC new];
//            
//            [weakSelf.navigationController pushViewController:commentVC animated:YES];
        }
    };
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无产品" topMargin:0];

    
    [self.view addSubview:self.tableView];
}

#pragma mark - Events
//前往地址
- (void)chooseAddress {
    
    EatWeakSelf;
    
//    ZHAddressChooseVC *chooseVC = [[ZHAddressChooseVC alloc] init];
//    //    chooseVC.addressRoom = self.addressRoom;
//    chooseVC.selectedAddrCode = self.currentAddress.code;
//    
//    chooseVC.chooseAddress = ^(ZHReceivingAddress *addr){
//        
//        weakSelf.currentAddress = addr;
//        [weakSelf setHeaderAddress:addr];
//        
//    };
//    
//    [self.navigationController pushViewController:chooseVC animated:YES];
    
    
    ZHAddAddressVC *editAddVC = [[ZHAddAddressVC alloc] init];
    
    editAddVC.addressType = AddressTypeEdit;
    
    editAddVC.address = self.currentAddress;
    
    editAddVC.editSuccess = ^(ZHReceivingAddress *addr){
        
        weakSelf.currentAddress = addr;
        [weakSelf setHeaderAddress:addr];
        
    };
    
    [weakSelf.navigationController pushViewController:editAddVC animated:YES];
    
}

// 原来无地址，现在添加地址
- (void)addAddress {
    
    EatWeakSelf;
    
    ZHAddAddressVC *address = [[ZHAddAddressVC alloc] init];
    
    address.addressType = AddressTypeAdd;
    
    address.addAddress = ^(ZHReceivingAddress *address){
        
        //原来无地址, 现在又地址
        weakSelf.currentAddress = address;
        [weakSelf setHeaderAddress:address];
        [weakSelf.addressRoom addObject:address];
        
    };
    [self.navigationController pushViewController:address animated:YES];
    
}

#pragma mark - Data
- (void)getAddress {
    
    //查询是否有收货地址
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805165";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    //    http.parameters[@"isDefault"] = @"0"; //是否为默认收货地址
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *adderssRoom = responseObject[@"data"];
        
        if (adderssRoom.count > 0 ) { //有收获地址
            
            self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];
            //给一个默认地址
            self.currentAddress = self.addressRoom[0];
            self.currentAddress.isSelected = YES;
            
            [self setHeaderAddress:self.currentAddress];
            
            
        } else { //没有收货地址，展示没有的UI
            
            self.addressRoom = [NSMutableArray array];
            
            [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            [self setNoAddressUI];
            
        }
        
        [self requestGoods];

        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requestGoods {
    
    EatWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    helper.code = @"808029";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
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

- (void)setHeaderAddress:(ZHReceivingAddress *)address {
    
    [self setHaveAddressUI];
    
    self.chooseView.nameLbl.text = [NSString stringWithFormat:@"收货人：%@",address.addressee];
    self.chooseView.mobileLbl.text = [NSString stringWithFormat:@"%@",address.mobile];
    self.chooseView.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",address.province,address.city, address.district, address.detailAddress];
    
    CGSize size = [self.chooseView.addressLbl.text calculateStringSize:CGSizeMake(kScreenWidth - 50 - 15, MAXFLOAT) font:Font(15.0)];
    
    self.chooseView.height = 50 + size.height;
    
    [self.chooseView.addressLbl labelWithTextString:self.chooseView.addressLbl.text lineSpace:5];
    
    self.headerView.height = self.chooseView.height;
    
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
