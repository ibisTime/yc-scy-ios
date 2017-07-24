//
//  SearchUserApi.h
//  ZHBusiness
//
//  Created by 蔡卓越 on 2017/5/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BaseApi.h"

@interface SearchUserApi : BaseApi

- (void)searchUserWithMobile:(NSString *)mobile success:(void(^)(id responseObject))success failure:(void(^)())failure;

@end
