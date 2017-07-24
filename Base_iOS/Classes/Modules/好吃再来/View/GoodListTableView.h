//
//  GoodListTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "GoodModel.h"

typedef void(^GoodListBlock)(NSInteger index);

@interface GoodListTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic, copy) GoodListBlock goodBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
