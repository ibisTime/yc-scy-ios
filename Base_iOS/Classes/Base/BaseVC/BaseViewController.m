//
//  BaseViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

#import "NavigationController.h"

#import "TabbarViewController.h"

//#import "LoginViewController.h"

#define kAnimationType 1


@interface BaseViewController () <MBProgressHUDDelegate, UIGestureRecognizerDelegate>


@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) NSTimer       *overTimer;
@property (nonatomic, assign) NSInteger      downCount;


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewEdgeInset];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kAppCustomMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    
    TabbarViewController *tabbar = (TabbarViewController*)self.tabBarController;
    if (tabbar) {
       // [tabbar removeOriginTabbarButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@类内存大爆炸",[self class]);
}

#pragma mark - Setting
- (void)setTitleStr:(NSString *)titleStr {
    
    _titleStr = titleStr;
    
    self.navigationItem.titleView = [UILabel labelWithTitle:titleStr];
}

#pragma mark - Private

// 如果tableview在视图最底层 默认会偏移电池栏的高度
- (void)setViewEdgeInset {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (BOOL)isRootViewController {
    return (self == self.navigationController.viewControllers.firstObject);
}

#pragma mark - Public
- (void)returnButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showIndicatorOnWindow {
    
    if (_progressHUD == nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
        
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"加载中...";
        [_progressHUD show:YES];
        
        _downCount = 10;
        _overTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(overTimer:) userInfo:nil repeats:YES];
    }
}

- (void)showIndicatorOnWindowWithMessage:(NSString *)message {
     
    if (_progressHUD == nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
        _progressHUD.color = kBlackColor;
        //[UIColor colorWithRed:200/255.0 green:218/255.0 blue:91/255.0 alpha:1];
        _progressHUD.delegate = self;
        _progressHUD.labelText = message;
        [_progressHUD show:YES];
    }
    
}

- (void)showTextOnly:(NSString *)text {
    
    if (_progressHUD) {
        return;
    }
    
//    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _progressHUD.mode = MBProgressHUDModeText;
    
    //_progressHUD.mode = MBProgressHUDModeCustomView;
    //_progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_unselected_icon"]];
    
    _progressHUD.animationType = MBProgressHUDAnimationZoom;
    
    _progressHUD.delegate = self;
    _progressHUD.labelText = text;
    _progressHUD.margin = 10.f;
    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.color = kBlackColor;
    //[UIColor colorWithRed:200/255.0 green:218/255.0 blue:91/255.0 alpha:1];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_progressHUD hide:YES];
        
        _progressHUD = nil;
    });

}

- (void)showErrorMsg:(NSString *)text {
    
    NSString *error_msg = PASS_NULL_TO_NIL(text);
    if (!error_msg) {
        error_msg = @"网络不太好";
    }
    
    [self performSelector:@selector(showTextOnly:) withObject:error_msg afterDelay:1.5];
}

- (void)hideIndicatorOnWindow {
    
    [_overTimer invalidate];
    _overTimer = nil;
    [_progressHUD hide:YES];
}

- (void)overTimer:(NSTimer *)timer {
    _downCount--;
    if (_downCount == 0) {
        [self hideIndicatorOnWindow];
    }
}

- (void)showReLoginAlert {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录已失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showReLoginVC];
    }];
    
    [alertCtrl addAction:submitAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)showReLoginVC {

    
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)dismissReLoginVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isLogin {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 判断是都是根控制器， 是的话就不pop
    if ([self isRootViewController]) {
        return NO;
    } else {
        return YES;
    }
}

// 允许手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

// 优化pop时, 禁用其他手势,如：scrollView滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
