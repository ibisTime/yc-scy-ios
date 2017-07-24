//
//  BaseViewController.h
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *titleStr;

- (void)showIndicatorOnWindow;

- (void)showIndicatorOnWindowWithMessage:(NSString *)message;

- (void)showTextOnly:(NSString *)text;

- (void)showErrorMsg:(NSString*)text;

- (void)hideIndicatorOnWindow;

- (void)showReLoginAlert;

- (void)showReLoginVC;

- (BOOL)isLogin;

- (void)dismissReLoginVC;


@end
