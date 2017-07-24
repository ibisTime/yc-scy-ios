//
//  GoodListCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@class GoodListCell;

@protocol GoodListCellDelegate <NSObject>

- (void)didSelectActionWithIndex:(NSInteger)index;

@end

@interface GoodListCell : UITableViewCell

@property (nonatomic,strong) GoodModel *good;

@property (nonatomic, weak) id <GoodListCellDelegate>delegate;

@property (nonatomic, strong) UIButton *statusBtn;

@end

