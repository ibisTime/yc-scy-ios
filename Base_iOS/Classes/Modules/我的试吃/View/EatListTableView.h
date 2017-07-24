//
//  EatListTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "GoodModel.h"
#import "EatListCell.h"

typedef void(^EatListBlock)(EatStatusType statusType, NSInteger index);

@interface EatListTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic, copy) EatListBlock eatBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
