//
//  UpdateModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface UpdateModel : BaseModel

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *downloadUrl;

@property (nonatomic, copy) NSString *forceUpdate;

@end
