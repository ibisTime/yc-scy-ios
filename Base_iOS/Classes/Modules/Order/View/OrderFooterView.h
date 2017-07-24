//
//  OrderFooterView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) OrderModel *order;

@end
