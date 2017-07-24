//
//  FriendListCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface FriendListCell : UITableViewCell

@property (nonatomic,strong) FriendModel *friendModel;

@property (nonatomic, strong) UIButton *statusBtn;

@end
