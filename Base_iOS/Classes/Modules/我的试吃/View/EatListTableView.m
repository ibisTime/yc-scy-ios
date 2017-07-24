//
//  EatListTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "EatListTableView.h"
#import "EatListCell2.h"

@interface EatListTableView ()<UITableViewDelegate, UITableViewDataSource, EatListCellDelegate>

@end

@implementation EatListTableView

static NSString *identifierCell = @"EatListCell";

static NSString *identifierCell2 = @"EatListCell2";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[EatListCell class] forCellReuseIdentifier:identifierCell];
        
        [self registerClass:[EatListCell2 class] forCellReuseIdentifier:identifierCell2];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GoodModel *good = self.goods[indexPath.row];
    
    if (![good.isTasted isEqualToString:@"0"]) {
        
        EatListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
        
        cell.good = good;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    EatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.good = good;
    
    cell.statusBtn.tag = 5000 + indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

#pragma mark - HealthCircleCellDelegate

- (void)didSelectActionWithType:(EatStatusType)type index:(NSInteger)index {
    
    switch (type) {
        case EatStatusTypeEat:
        {
            if (_eatBlock) {
                
                _eatBlock(type, index);
            }
            
        }
            break;
            
        case EatStatusTypeComment:
            
        {
            if (_eatBlock) {
                
                _eatBlock(type, index);
            }
            
        }
            break;
            
        default:
            break;
    }
}

@end
