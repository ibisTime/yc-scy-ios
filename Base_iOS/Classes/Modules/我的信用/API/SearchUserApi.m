//
//  SearchUserApi.m
//  ZHBusiness
//
//  Created by 蔡卓越 on 2017/5/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SearchUserApi.h"
#import "AppConfig.h"

@implementation SearchUserApi

- (void)searchUserWithMobile:(NSString *)mobile success:(void (^)(id responseObject))success failure:(void (^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"805054";
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"mobile"] = mobile;
    http.parameters[@"systemCode"] = [AppConfig config].systemCode;
    
    http.parameters[@"companyCode"] = [AppConfig config].companyCode;
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
    
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure();
        }
    }];

}

@end
