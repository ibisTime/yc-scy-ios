//
//  SettingCell.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"

@interface SettingCell : UITableViewCell

@property (nonatomic, strong) SettingModel *settingModel;

@property (nonatomic, strong) UILabel *rightLabel;

@end
