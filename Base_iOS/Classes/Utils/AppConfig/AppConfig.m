//
//  AppConfig.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/5/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppConfig.h"

void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {
    
    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });
    
    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {
    
    _runEnv = runEnv;
    
//    self.companyCode = @"CD-JKEG000011";
//    self.systemCode = @"CD-JKEG000011";
//    
//    switch (_runEnv) {
//            
//        case RunEnvRelease: {
//            
//            self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
//            self.addr = @"http://116.62.114.86:8901"; //test
//            self.shareBaseUrl = @"http://m.caigo888.com/consume/detail.html";
//            
//        }break;
//            
//        case RunEnvDev: {
//            
//            self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
//            self.addr = @"http://121.43.101.148:8901";
//            self.shareBaseUrl = @"http://dev.hichengdai.com/consume/detail.html";
//            
//        }break;
//            
//        case RunEnvTest: {
//            
//            self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
//            self.addr = @"http://116.62.114.86:8901";
//            self.shareBaseUrl = @"http://m.test.caigo888.com/consume/detail.html";
//            
//        }break;
//            
//    }
    self.companyCode = @"CD-CYC000009";
    self.systemCode = @"CD-CYC000009";
    
    switch (_runEnv) {
            
        case RunEnvRelease: {
            
            self.qiniuDomain = @"http://oq4vi26fi.bkt.clouddn.com";
            self.addr = @"http://121.40.113.128:5301";
            
        }break;
            
        case RunEnvDev: {
            
            self.qiniuDomain = @"http://oq4vi26fi.bkt.clouddn.com";
            self.addr = @"http://121.43.101.148:9901";
            
        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://oq4vi26fi.bkt.clouddn.com";
            self.addr = @"http://118.178.124.16:3501";
            
        }break;
            
    }
    
}

- (NSString *)pushKey {
    
    return @"99ffbfdafbd8e791f3daa28a";
    
}

- (NSString *)getUrl {

    return [self.addr stringByAppendingString:@"/forward-service/api"];
}

- (NSString *)aliMapKey {
    
    //菜狗
    return @"2c7fa174818670dd2eca0861d453a727";
}


- (NSString *)wxKey {
    
    return @"wx9324d86fb16e8af0";
}

@end
