//
//  EatListCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

typedef NS_ENUM(NSInteger, EatStatusType) {
    
    EatStatusTypeEat = 0,   //试吃
    EatStatusTypeComment,   //评价
};

@class EatListCell;

@protocol EatListCellDelegate <NSObject>

- (void)didSelectActionWithType:(EatStatusType)type index:(NSInteger)index;

@end

@interface EatListCell : UITableViewCell

@property (nonatomic, assign) EatStatusType statusType;

@property (nonatomic,strong) GoodModel *good;

@property (nonatomic, weak) id <EatListCellDelegate>delegate;

@property (nonatomic, strong) UIButton *statusBtn;

@end
