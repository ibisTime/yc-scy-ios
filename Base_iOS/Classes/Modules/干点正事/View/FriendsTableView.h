//
//  FriendsTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"

#import "FriendModel.h"

typedef void(^FriendListBlock)(NSInteger index);

@interface FriendsTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <FriendModel *>*friends;

@property (nonatomic, copy) FriendListBlock friendBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
