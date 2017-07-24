//
//  FriendModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
@class UserExt;

@interface FriendModel : BaseModel

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *userReferee;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *userRefereeName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *loginPwdStrength;

@property (nonatomic, strong) UserExt *userExt;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *openId;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *companyCode;

@end

@interface UserExt : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *userReferee;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *systemCode;

@end

