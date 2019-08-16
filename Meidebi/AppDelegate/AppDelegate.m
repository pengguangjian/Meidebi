//
//  AppDelegate.m
//  mdb
//
//  Created by 杜非 on 14/11/28.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarControllerConfig.h"
#import "ProductInfoViewController.h"
#import "HTTPManager.h"

//shareSDK分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "Marked.h"
#import "Photocle.h"
#import "Photoscle.h"
#import <Qiniu/QiniuSDK.h>
#import "FMDBHelper.h"

#import "GuideViewController.h"
//#import "UMessage.h"
#import <UMPush/UMessage.h>
#import "Reachability.h"
#import <AlibcTradeSDK/AlibcTradeSDK/AlibcTradeSDK.h>
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#import <AdSupport/AdSupport.h>
#import "TalkingData.h"

#import "LaunchAdView.h"
#import "NSDate+compare.h"
#import "RemarkHomeDatacontroller.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

//#import <Bugly/Bugly.h>
//
//#define BUGLY_APP_ID @"e22c6dd473"

#import <AlipaySDK/AlipaySDK.h>

#import "ProductInfoSubjectsView.h"

#import "MDBPGGWebViewController.h"


#import "OriginalDetailViewController.h"


#import "VolumeContentViewController.h"

#import "CommentRewardsViewController.h"

#import "ActivityDetailViewController.h"

#import "OrderDetaileViewController.h"

#import "QuanWangYHDetailViewController.h"

#import "FindeCouponResultViewController.h"


#import "SearchMainViewController.h"

#import "ShopMainTableViewController.h"


#import "MyInformMessageDataController.h"

#import "PushYuanChuangViewController.h"

//#import "PlusButtonSubclass.h"
static NSString * const kStatusBarTappedNotification = @"statusBarTappedNotification";
static NSString * const kInspectPasteboardNotification = @"inspectPasteboardNotification";
static NSString * const kAliFeedbackAppKey = @"23342874";
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    Reachability *_inernetRech;
    
    NSDictionary *dicuploadalder;
    
    NSString *stralterfromtype;
    
}
@property (nonatomic, strong) TabBarControllerConfig *tabBarControllerConfig;
@property (nonatomic, strong) GuideViewController *guideVc;
@property (nonatomic, strong) QNUploadManager *qnUpManager;
@property (nonatomic, strong) NSMutableArray *mutPhotos;
@end

@implementation AppDelegate{
    Marked    *_marked;
    NSArray *_mutphotoCles;
    BOOL    _isloadShare;
    NSString *_uuidSTr;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    _isloadShare=YES;
    _inernetRech=[Reachability reachabilityForInternetConnection];
    [_inernetRech startNotifier];
    
    [self setup];
    [self loadLaunchView];
    [self setupAssessmentGuideView];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSaidan:) name:kShaidanUpshareImageManagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wairningOnload) name:kNetworkWairningOnloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadRemarkImages:) name:kRemarkUploadImagesNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString* message = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
    NSString *linkerId=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromid"]];
    if (!linkerId || [linkerId isEqualToString:@""]) {
        return YES;
    }
    if([message length])
    {
        NSString *fromtype=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromtype"]];
        [self skipProductInfoVcWithID:linkerId andfromtype:fromtype];
    }
    
    [WXApi registerApp:@"wx482499aac0e8d8f7"];
    
    // um 分析
    //    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:kUmengAppKey channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    
    // um 推送
//    [UMessage startWithAppkey:kUmengAppKey launchOptions:launchOptions httpsenable:YES];
//    [UMessage registerForRemoteNotifications];
    ////
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
        } else {
            //点击不允许
        }
    }];
    
    // taobao
    [[AlibcTradeSDK sharedInstance] setEnv:AlibcEnvironmentRelease];
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
    } failure:^(NSError *error) {
        // NSLog(@"Init failed: %@", error.description);
    }];
    // 设置全局的app标识，在电商模块里等同于isv_code
    [[AlibcTradeSDK sharedInstance] setISVCode:@"com.meidebi.iPhone"];
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
    // 开发阶段打开日志开关，方便排查错误信息
    // [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    // talkingData
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:kTalkingDataAppKey withChannelId:@"app store"];
    
    
    
    ///京东
    [[KeplerApiManager sharedKPService]asyncInitSdk:jd_app_key secretKey:jd_app_secret sucessCallback:^(){
    }failedCallback:^(NSError *error){
    }];
    
    
    
    [self loadHTTPCookies];
    [self AuthshareSDKSetting];
    
    [self VersonUpdate];
    
    
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            

            
            //iOS10必须加下面这段代码。
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate=self;
            UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
            [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    //点击允许
                } else {
                    //点击不允许
                }
            }];
            
            // taobao
            [[AlibcTradeSDK sharedInstance] setEnv:AlibcEnvironmentRelease];
            // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
            [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
            } failure:^(NSError *error) {
                // NSLog(@"Init failed: %@", error.description);
            }];
            // 设置全局的app标识，在电商模块里等同于isv_code
            [[AlibcTradeSDK sharedInstance] setISVCode:@"com.meidebi.iPhone"];
            // 设置全局配置，是否强制使用h5
            [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
            // 开发阶段打开日志开关，方便排查错误信息
            // [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
            // talkingData
            [TalkingData setExceptionReportEnabled:YES];
            [TalkingData sessionStarted:kTalkingDataAppKey withChannelId:@"app store"];
            
            
            
            ///京东
            [[KeplerApiManager sharedKPService]asyncInitSdk:jd_app_key secretKey:jd_app_secret sucessCallback:^(){
            }failedCallback:^(NSError *error){
            }];
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                //        [self uploadManager];
                [self loadHTTPCookies];
                [self AuthshareSDKSetting];

            });
            [self VersonUpdate];
            
        });
    });
    */
    

//    [self setupBugly];

//    ////测试推送跳转
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self skipProductInfoVcWithID:@"18953" andfromtype:@"8"];
//    });
    
    
   [[UITabBar appearance] setTranslucent:NO];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    return YES;
}

//通知回调
-(void)endFullScreen{
    NSLog(@"退出全屏");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //    self.viewController.navigationController.navigationBar.frame = CGRectMake(0, -44, kMainScreenW, 44);//矫正导航栏移位
#pragma clang diagnostic pop
}


- (void)loadLaunchView{
    if ([MDB_UserDefault adInfo]) {
        NSDictionary *dic=[[MDB_UserDefault adInfo] JSONValue];
        [self showAdviewWithADInfo:dic];
    }
    [HTTPManager sendGETRequestUrlToService:URL_adurl1
                    withParametersDictionry:nil
                                       view:nil
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 if (responceObjct) {
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dic=[str JSONValue];
                                     
                                     if ([[dic objectForKey:@"status"] integerValue] == 1) {
                                         if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                                             if (![[MDB_UserDefault adInfo] isEqualToString:str]) {
                                                 if([[NSString nullToString:dic[@"data"][@"imgurl"]] isEqualToString:@""])
                                                 {
                                                    [MDB_UserDefault setAdInfo:nil];
                                                 }
                                                 else
                                                 {
                                                     [MDB_UserDefault setAdInfo:str];
                                                     // 更新广告内容
                                                     [LaunchAdView updateAdvertisingImage:[NSString nullToString:dic[@"data"][@"imgurl"]]];
                                                 }
                                                 
                                             }
                                         }else{
                                             [MDB_UserDefault setAdInfo:nil];
                                         }
                                    }
                                    else
                                    {
                                        if(dic.count==3)
                                        {
                                            [MDB_UserDefault setAdInfo:nil];
                                        }
                                        else
                                        {
                                            
                                        }
                                        
                                    }
                                 }
                             }];
    

}

- (void)showAdviewWithADInfo:(NSDictionary *)infoDict{
    LaunchAdView *adView = [[LaunchAdView alloc] initWithWindow:self.window];
    adView.vc = [self.tabBarControllerConfig.tabBarController selectedViewController];
    adView.imgUrl = [NSString nullToString:infoDict[@"data"][@"imgurl"]];
    adView.clickBlock = ^(LaunchAdTouchType clickType){
        switch (clickType) {
            case LaunchAdTouchTypeAD:{
                if ([[NSString nullToString:infoDict[@"data"][@"link"]] isEqualToString:@""] && [[NSString nullToString:infoDict[@"data"][@"id"]] isEqualToString:@""]) return;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"adPush" object:@{
                                                                                              @"link":[NSString nullToString:infoDict[@"data"][@"link"]],
                                                                                              @"id":[NSString nullToString:infoDict[@"data"][@"linkId"]],
                                                                                              @"linkType":[NSString nullToString:infoDict[@"data"][@"linkType"]]
                                                                                              }];
            }
                break;
            case LaunchAdTouchTypeSkip:
                break;
            default:
                break;
        }
    };

}
/*
#pragma mark - bugly
- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
    //#if DEBUG
    config.debugMode = YES;
    //#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}
*/
/**
 *    @brief TEST method for BuglyLog
 */
/*
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}
*/
#pragma mark - umeng

-  (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *deviceStr = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
//    NSLog(@"deviceToken:%@",deviceStr);
    if(deviceStr.length>0)
    {
        [MDB_UserDefault setUmengDeviceToken:deviceStr];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"setHttpTokensss"] intValue] !=1)
        {
            [self setHttpToken];
        }
    }
    
    
//    NSString *deviceStr=[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""];
//    [MDB_UserDefault setUmengDeviceToken:deviceStr];
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"setHttpTokensss"] intValue] !=1)
//    {
//        [self setHttpToken];
//    }
    
    
    
}


-(void)setHttpToken
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"setHttpTokensss"];
    NSDictionary *prama;
    if ([MDB_UserDefault getIsLogin]) {
        prama=@{@"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }else{
        if ([MDB_UserDefault getUmengDeviceToken]) {
            prama=@{@"umengtoken":[MDB_UserDefault getUmengDeviceToken]};
        }
    }
    [HTTPManager sendRequestUrlToService:URL_getumengconfig withParametersDictionry:prama view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[[dicAll objectForKey:@"status"] intValue]) {
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"setHttpTokensss"];
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"setHttpTokensss"];
        }
        
    }];
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
    NSString* message = @"";
    id alert = [userInfo valueForKeyPath:@"aps.alert"];
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)alert;
        message = [[NSString nullToString:dict[@"title"]] stringByAppendingString:[NSString nullToString:dict[@"body"]]];
    }else if ([alert isKindOfClass:[NSString class]]){
        message = (NSString *)alert;
    }
    
    NSString *linkerId=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromid"]];
    if (!linkerId || [linkerId isEqualToString:@""]) {
        return;
    }
    if([message length])
    {
        NSString *fromtype=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromtype"]];
        stralterfromtype = fromtype;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"没得比提醒你"
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"取消"
                                              otherButtonTitles: @"查看"
                              ,nil];
        [alert setTag:[linkerId intValue]];
        
        [alert show];
    }
    
}

#pragma alertview delegate --------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *linkerID=[NSString stringWithFormat:@"%@",@(alertView.tag)];
    if (buttonIndex==1) {   //用户点击了查看
        [self skipProductInfoVcWithID:linkerID andfromtype:stralterfromtype];
        
    }
}

- (void)skipProductInfoVcWithID:(NSString *)productid andfromtype:(NSString *)fromtype{

    ///
    if ([[NSString nullToString:fromtype] isEqualToString:@"1"]) {
        
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:productid];
        [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:productInfoVc animated:YES];
        
        
    }else if ([[NSString nullToString:fromtype] isEqualToString:@"2"]){
        OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:productid];
        [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:vc animated:YES];

        
    }else if ([[NSString nullToString:fromtype] isEqualToString:@"3"]){
        
        VolumeContentViewController *voluVc = [[VolumeContentViewController alloc] init];
        voluVc.juancleid = productid.integerValue;
        
//        vvc.present_type = model.changetype.intValue;////？？？？
//        vvc.type = waresTypeMaterial;
//        vvc.haveto = @"address";
        
        
        [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:voluVc animated:YES];
        
    }else if ([[NSString nullToString:fromtype] isEqualToString:@"4"]){
        
        CommentRewardsViewController *commentRewardVc = [[CommentRewardsViewController alloc] init];
        commentRewardVc.activityId = productid;
        [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:commentRewardVc animated:YES];
        
    }else if ([[NSString nullToString:fromtype] isEqualToString:@"5"]){
        
        ActivityDetailViewController *activityVc = [[ActivityDetailViewController alloc] init];
        activityVc.activityId = productid;
        [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:activityVc animated:YES];
        
    }else if ([[NSString nullToString:fromtype] isEqualToString:@"7"]){
        OrderDetaileViewController *activityVc = [[OrderDetaileViewController alloc] init];
        activityVc.strid = productid;
        [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:activityVc animated:YES];
    }
    else if ([[NSString nullToString:fromtype] isEqualToString:@"8"]){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tabbarselectother" object:@"2"];
        [[self.tabBarControllerConfig.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
        
    }
    else if ([[NSString nullToString:fromtype] isEqualToString:@"9"]){
        MyInformMessageDataController *datacontrol = [[MyInformMessageDataController alloc] init];
        NSDictionary *dicpush = @{@"id":productid,@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
        [datacontrol requestMyInformYuanChuangKaPianInView:self.window dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            if(state)
            {
                if(datacontrol.dicmessage != nil)
                {
                    NSArray *arrbaoliaourl = [datacontrol.dicmessage objectForKey:@"linkUrl"];
                    PushYuanChuangViewController *pvc = [[PushYuanChuangViewController alloc] init];
                    pvc.arrbaoliaourl = arrbaoliaourl;
                    UINavigationController *nvc = [self.tabBarControllerConfig.tabBarController selectedViewController];
                    [nvc pushViewController:pvc animated:YES];
                }
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.window];
            }
        }];
        
    }
    
    
    
    ////
//
//
//    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
//    productInfoVc.productId = productid;
//    [[[self.cyl_tabBarController cyl_popSelectTabBarChildViewControllerAtIndex:_tabBarControllerConfig.tabBarController.selectedIndex] navigationController] pushViewController:productInfoVc animated:YES];
}


- (void)wairningOnload{
    [MDB_UserDefault showNotifyHUDwithtext:@"您的登录已过期，请重新登录!" inView:[[UIApplication sharedApplication].windows firstObject]];
    [[MDB_UserDefault defaultInstance] setUserNil];    
    //退出第三方登录
    [SSEThirdPartyLoginHelper logout:[SSEThirdPartyLoginHelper currentUser]];
}

#pragma mark - uploadManager
-(void)uploadManager{
    if (_isloadShare) {
        _isloadShare=NO;
       NSArray *makeArr=[[FMDBHelper shareInstance] findMarkTable];
        if (makeArr&&makeArr.count>0) {
            for (Marked *mark in makeArr) {
                if ([mark.count integerValue]<2) {
                    _marked=mark;
                    _uuidSTr= [self getUUIDl];
                    [self loadimvImagel];
                    return;
                }
            }
            _isloadShare=YES;
            
        }else{
            _isloadShare=YES;
        }
    }
}

- (void)updateSaidan:(NSNotification *)notification{
    NSArray *makeArr=[[FMDBHelper shareInstance] findMarkTable];
    if (makeArr&&makeArr.count>0) {
        for (Marked *mark in makeArr) {
            if ([mark.count integerValue]<2) {
                _marked=mark;
                _uuidSTr= [self getUUIDl];
                [self loadimvImagel];
                return;
            }
        }
    }
}
//获取唯一标示 随机字符串
-(NSString *)getUUIDl{
    CFUUIDRef identifier=CFUUIDCreate(NULL);
    CFStringRef guid=CFUUIDCreateString(NULL, identifier);
    CFRelease(identifier);
    NSString *uuidString = [((__bridge NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(guid);
    return uuidString;
}

-(NSString *)getWithNumber:(NSNumber *)number{
    return [NSString stringWithFormat:@"%@",number];
}
-(void)loadimvImagel{
    _mutphotoCles= [[FMDBHelper shareInstance] findMarkPhotoWithFormat:_marked.markedid];
    if (_mutphotoCles.count==0) {
        _isloadShare=YES;
    }
    if (![MDB_UserDefault defaultInstance].usertoken) {
        return;
    }
    self.mutPhotos=[NSMutableArray new];
    [self obtainShaidanImageLink];
}

- (void)obtainShaidanImageLink{
    __block NSNumber *numb=[NSNumber numberWithInteger:([_marked.count integerValue]+1)];
    NSDictionary *dics=@{@"ext":@"png",
                         @"userkey":[MDB_UserDefault defaultInstance].usertoken};
    [HTTPManager sendRequestUrlToService:URL_uploadtoken withParametersDictionry:dics view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _isloadShare=YES;
            self.mutPhotos=[NSMutableArray new];
            _marked.count=[NSString stringWithFormat:@"%@",numb];
            [[FMDBHelper shareInstance] updateMarkedCount:[NSString stringWithFormat:@"%@",numb] markedid:_marked.markedid];
            [[NSNotificationCenter defaultCenter] postNotificationName:kShaidanDidSuccessSendNotification object:@(NO)];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue] == 1) {
                NSDictionary *mutdic=[dicAll objectForKey:@"data"];
                [self.mutPhotos addObject:mutdic];
                if (self.mutPhotos.count==_mutphotoCles.count) {
                    [self uploadeMansgerindex:0 str:_uuidSTr];
                }else{
                    [self obtainShaidanImageLink];
                }
            }
        }
    }];
}
-(void)uploadeMansgerindex:(NSInteger )indext str:(NSString *)strl{
    __block NSInteger inde=indext;
    __block NSNumber *numb=[NSNumber numberWithInteger:([_marked.count integerValue]+1)];
    if (indext<self.mutPhotos.count&&_mutphotoCles.count>indext) {
        Photoscle *phto=[_mutphotoCles objectAtIndex:indext];
        NSDictionary *dic=[self.mutPhotos objectAtIndex:indext];
        [self upManegepuData:phto.pdata key:[dic objectForKey:@"key"] token:[dic objectForKey:@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode==200) {
                inde++;
                if ([_uuidSTr isEqualToString:strl]) {
                    if (inde==_mutphotoCles.count) {
                        [self uploadall];
                    }else if(inde <_mutphotoCles.count){
                        NSInteger s=inde;
                        [self uploadeMansgerindex:s str:strl];
                    }
                }
            }else{
                _marked.count=[NSString stringWithFormat:@"%@",numb];
                [[FMDBHelper shareInstance] updateMarkedCount:[NSString stringWithFormat:@"%@",numb] markedid:_marked.markedid];
                _isloadShare=YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:kShaidanDidSuccessSendNotification object:@(NO)];
            }
        }];
    
    }
}
-(void)upManegepuData:(NSData *)data key:(NSString *)key token:(NSString *)token complete:(QNUpCompletionHandler)completionHandler{
    QNUploadManager *upManager=[[QNUploadManager alloc]init];
    [upManager putData:data key:key token:token complete:completionHandler option:nil];

}
-(NSString *)photoReturn:(NSArray *)arr{
    NSMutableString *strs=[[NSMutableString alloc]init];
    for (NSDictionary *dic in arr) {
        if ([arr indexOfObject:dic]==0) {
            [strs appendString:[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"domain"],[dic objectForKey:@"key"]]];
        }else{
            [strs appendString:[NSString stringWithFormat:@",%@%@",[dic objectForKey:@"domain"],[dic objectForKey:@"key"]]];
        }
    }
    return [NSString stringWithString:strs];
}
-(void)uploadall
{
    NSString *strl=[self photoReturn:self.mutPhotos];
    NSDictionary *parameters=@{
                               @"title":_marked.title,
                               @"content":_marked.content,
                               @"pics":strl,
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                               };
    [HTTPManager sendGETRequestUrlToService:URL_savese withParametersDictionry:parameters view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            _isloadShare=NO;
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue]==1) {
                [[FMDBHelper shareInstance] clearMarkeEditTableWithFormat:_marked.markedid];
                _isloadShare=YES;
                [self uploadManager];
                [MDB_UserDefault showNotifyHUDwithtext:@"原创已上传，请到我的原创查看" inView:self.window];
                [[NSNotificationCenter defaultCenter] postNotificationName:kShaidanDidSuccessSendNotification object:@(YES)];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:dicAll[@"info"]] inView:self.window];
                [[FMDBHelper shareInstance] updateMarkedCount:[NSString stringWithFormat:@"%@",@"2"] markedid:_marked.markedid];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kShaidanDidSuccessSendNotification object:@(NO)];
                });
            }
        }else{
            _isloadShare=YES;
            [[FMDBHelper shareInstance] updateMarkedCount:[NSString stringWithFormat:@"%@",@"2"] markedid:_marked.markedid];
            [[NSNotificationCenter defaultCenter] postNotificationName:kShaidanDidSuccessSendNotification object:@(NO)];
        }
    }];
}

- (void)setupAssessmentGuideView{
    NSString *lastVersion = [NSString nullToString:[MDB_UserDefault getVersionNumber]];
    NSString *currentVersion = [[MDB_UserDefault defaultInstance] applicationVersion];
    // 更新了版本
    if (![lastVersion isEqualToString:currentVersion]) {
        // statistic app launch
        [MDB_UserDefault setAppLaunchingNumber:@([[MDB_UserDefault getAppLaunchingNumber] intValue]+1)];
        // 启动3次以上
        if ([[MDB_UserDefault getAppLaunchingNumber] intValue] >= 3) {
            // 使用时间达到3分钟
//            int x = arc4random() % 2;
//            if(x==1)
//            {
//                
//            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*60*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NJAssessmentGuideView *guideView = [[NJAssessmentGuideView alloc] init];
                guideView.delegate = self;
                [guideView show];
                [MDB_UserDefault setVersionNumber:currentVersion];
                [MDB_UserDefault setAppLaunchingNumber:@(0)];
            });
        }
    }
}

- (void)setup{
    [self setUpInitData];
//    [PlusButtonSubclass registerPlusButton];
    _tabBarControllerConfig = [[TabBarControllerConfig alloc] init];
    [self.window setRootViewController:_tabBarControllerConfig.tabBarController];
    
    
    [self.window makeKeyAndVisible];
    [self.window makeKeyWindow];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults objectForKey:@"FirstLoad"] integerValue] != 3) {
        [userDefaults setInteger:3 forKey:@"FirstLoad"];
        //显示引导页
        UIStoryboard *Mainboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _guideVc=[Mainboard instantiateViewControllerWithIdentifier:@"com.mdb.GuideView.ViewController"];
        [self.window addSubview:_guideVc.view];
        [self.window bringSubviewToFront:_guideVc.view];
        [self setTabBar:YES];
    }else{
        [self setTabBar:NO];
    }
}
-(void)guideload{
    [_guideVc.view removeFromSuperview];
    [self setTabBar:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"completeGuidNotification"
                                                        object:nil];
    
}
- (void)setTabBar:(BOOL)bools{
    if (bools) {
        [MDB_UserDefault setUmengfirestStatue:YES];
    }else{
        [MDB_UserDefault setUmengfirestStatue:NO];
    }
}

#pragma mark - NJAssessmentGuideViewDelegate

- (void)assessmentGuideViewDidPressLinkBtn{
    if (@available(iOS 11.0 , *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"659197645"]]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=659197645"]];
    }
}


- (void)setUpInitData{
    // 设置推送类型
    user = [MDB_UserDefault defaultInstance];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveHTTPCookies];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [MDB_UserDefault setLastSelectMenuPath:@{}];
    [MDB_UserDefault setFilterProductTypes:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInspectPasteboardNotification object:nil];
    [self loadHTTPCookies];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    ///这里添加邀请码
    ///去读取粘贴板中的邀请码
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *strValue = pasteboard.string;
    if(strValue.length > 6)
    {
        if([[strValue substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"¥"] && [[strValue substringWithRange:NSMakeRange(strValue.length-1, 1)] isEqualToString:@"¥"])
        {
            strValue = [strValue stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            if([self isNum:strValue] == YES)
            {
                NSString *strtimec = [MDB_UserDefault getNowTimeTimestamp];
                strValue = [NSString stringWithFormat:@"%@-%@",strValue,strtimec];
                [[NSUserDefaults standardUserDefaults] setObject:strValue forKey:@"meb_user_yaoqingma"];
            }
        }
        
    }
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveHTTPCookies];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        NSString* message = @"";
        id alert = [userInfo valueForKeyPath:@"aps.alert"];
        if ([alert isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)alert;
            message = [[NSString nullToString:dict[@"title"]] stringByAppendingString:[NSString nullToString:dict[@"body"]]];
        }else if ([alert isKindOfClass:[NSString class]]){
            message = (NSString *)alert;
        }
        NSString *linkerId=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromid"]];
        if (!linkerId || [linkerId isEqualToString:@""]) {
            return;
        }
        if([message length])
        {
            
            NSString *fromtype=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromtype"]];
            stralterfromtype = fromtype;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"没得比提醒你"
                                                            message: message
                                                           delegate: self
                                                  cancelButtonTitle: @"取消"
                                                  otherButtonTitles: @"查看"
                                  ,nil];
            [alert setTag:[linkerId intValue]];
            [alert show];
        }

    }else{
        //应用处于前台时的本地推送接受
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSString* message = @"";
        id alert = [userInfo valueForKeyPath:@"aps.alert"];
        if ([alert isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)alert;
            message = [[NSString nullToString:dict[@"title"]] stringByAppendingString:[NSString nullToString:dict[@"body"]]];
        }else if ([alert isKindOfClass:[NSString class]]){
            message = (NSString *)alert;
        }
        
        NSString *linkerId=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromid"]];
        if (!linkerId || [linkerId isEqualToString:@""]) {
            return;
        }
        NSString *fromtype=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"fromtype"]];
        stralterfromtype = fromtype;
        [self skipProductInfoVcWithID:linkerId andfromtype:fromtype];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    if ([url.scheme isEqualToString:@"safepaymdb"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifubaoSuccessAction" object:resultDic];
        }];
        return YES;
    }
    NSString *strurls = url.scheme;
    if ([url.scheme isEqualToString:@"sdkbackcf979eeeb84c46848bcf5d771785d6c1"])
    {
        return [[KeplerApiManager sharedKPService] handleOpenURL:url];
    }
    
    
    NSString *strurl = url.scheme;
    if ([strurl isEqualToString:[NSString stringWithFormat:@"wx482499aac0e8d8f7"]])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
    }
    
    ///这里添加邀请码
    ////外部连接中带过来的邀请码
    
    NSString *string =url.absoluteString;
    if ([string hasPrefix:@"meidebi://"])
    {
        //截取html传递的参数类型
        NSArray *typepat = [string componentsSeparatedByString:@"//"];
        if(typepat.count>=2)
        {
            NSMutableDictionary *dictemp = [NSMutableDictionary new];
            for(NSString *str in typepat)
            {
                NSArray *arr = [str componentsSeparatedByString:@"="];
                if(arr.count==2)
                {
                    [dictemp setObject:arr[1] forKey:arr[0]];
                }
                
            }
            
            
            NSString *strpucode = [NSString nullToString:[dictemp objectForKey:@"pucode"]];
            ///邀请码
            if([strpucode length] > 6 && [self isNum:strpucode] == YES)
            {
                NSString *strtimec = [MDB_UserDefault getNowTimeTimestamp];
                strpucode = [NSString stringWithFormat:@"%@-%@",strpucode,strtimec];
                [[NSUserDefaults standardUserDefaults] setObject:strpucode forKey:@"meb_user_yaoqingma"];
            }
            
            if([[dictemp objectForKey:@"type"] intValue] == 1)
            {//爆料
                
                NSString *strshareid = [NSString nullToString:[dictemp objectForKey:@"linkid"]];
                if(strshareid.length>0)
                {
                    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
                    pvc.productId = strshareid;
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:pvc animated:YES];
                }
                
                
            }
            else if([[dictemp objectForKey:@"type"] intValue] == 2)
            {//外链
                NSString *strlinkurl = [NSString nullToString:[dictemp objectForKey:@"linkurl"]];
                if(strlinkurl.length>0)
                {
                    MDBPGGWebViewController *pvc = [[MDBPGGWebViewController alloc] init];
                    pvc.strurl = strlinkurl;
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:pvc animated:YES];
                }
                
                
            }
            else if([[dictemp objectForKey:@"type"] intValue] == 3)
            {//原创
                NSString *strshareid = [NSString nullToString:[dictemp objectForKey:@"linkid"]];
                if(strshareid.length>0)
                {
                    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:strshareid];
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:vc animated:YES];
                }
                
            }
            else if([[dictemp objectForKey:@"type"] intValue] == 4)
            {//全网优惠页面
                NSString *strshareid = [NSString nullToString:[dictemp objectForKey:@"linkid"]];
                if(strshareid.length>0)
                {
                    QuanWangYHDetailViewController *pvc = [[QuanWangYHDetailViewController alloc] init];
                    pvc.strid = strshareid;
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:pvc animated:YES];
                }
                
                
            }
            
            
        }
    }
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"%@",url.scheme);
    if ([url.scheme isEqualToString:@"safepaymdb"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifubaoSuccessAction" object:resultDic];
        }];
        return YES;
    }
    NSString *strurl = url.scheme;
    if ([url.scheme isEqualToString:@"sdkbackcf979eeeb84c46848bcf5d771785d6c1"])
    {
        return [[KeplerApiManager sharedKPService] handleOpenURL:url];
    }
    
    if ([strurl isEqualToString:[NSString stringWithFormat:@"wx482499aac0e8d8f7"]])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
    }
    
    ///这里添加邀请码
    ////外部连接中带过来的邀请码
    
    NSString *string =url.absoluteString;
    if ([string hasPrefix:@"meidebi://"])
    {
        //截取html传递的参数类型
        NSArray *typepat = [string componentsSeparatedByString:@"//"];
        NSLog(@"%@",typepat);
        if(typepat.count>=2)
        {
            NSMutableDictionary *dictemp = [NSMutableDictionary new];
            for(NSString *str in typepat)
            {
                NSArray *arr = [str componentsSeparatedByString:@"="];
                if(arr.count==2)
                {
                    [dictemp setObject:arr[1] forKey:arr[0]];
                }
                
            }
            
            NSString *strpucode = [NSString nullToString:[dictemp objectForKey:@"pucode"]];
            ///邀请码
            if([strpucode length] > 6 && [self isNum:strpucode] == YES)
            {
                NSString *strtimec = [MDB_UserDefault getNowTimeTimestamp];
                strpucode = [NSString stringWithFormat:@"%@-%@",strpucode,strtimec];
                [[NSUserDefaults standardUserDefaults] setObject:strpucode forKey:@"meb_user_yaoqingma"];
            }
            
            if([[dictemp objectForKey:@"type"] intValue] == 1)
            {//爆料
                
                NSString *strshareid = [NSString nullToString:[dictemp objectForKey:@"linkid"]];
                if(strshareid.length>0)
                {
                    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
                    pvc.productId = strshareid;
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:pvc animated:YES];
                }
                
                
            }
            else if([[dictemp objectForKey:@"type"] intValue] == 2)
            {//外链
                NSString *strlinkurl = [NSString nullToString:[dictemp objectForKey:@"linkurl"]];
                if(strlinkurl.length>0)
                {
                    MDBPGGWebViewController *pvc = [[MDBPGGWebViewController alloc] init];
                    pvc.strurl = strlinkurl;
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:pvc animated:YES];
                }
                
                
            }
            else if([[dictemp objectForKey:@"type"] intValue] == 3)
            {//原创
                NSString *strshareid = [NSString nullToString:[dictemp objectForKey:@"linkid"]];
                if(strshareid.length>0)
                {
                    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:strshareid];
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:vc animated:YES];
                }
                
            }
            else if([[dictemp objectForKey:@"type"] intValue] == 4)
            {//全网优惠页面
                NSString *strshareid = [NSString nullToString:[dictemp objectForKey:@"linkid"]];
                if(strshareid.length>0)
                {
                    QuanWangYHDetailViewController *pvc = [[QuanWangYHDetailViewController alloc] init];
                    pvc.strid = strshareid;
                    [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:pvc animated:YES];
                }
                
                
            }
        }
    }
    
    
    return YES;
}

- (BOOL)application:(nonnull UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * __nullable))restorationHandler{
    
    NSDictionary *dictemp = userActivity.userInfo;
    NSString *idetifier = dictemp[@"kCSSearchableItemActivityIdentifier"];
//    NSLog(@"userActivity : %@",userActivity.webpageURL.description);
    /////根据idetifier 跳转不同的页面
    /*
     *com.meidebi.iPhone.haitao       海淘/海外购   首页的海淘频道
     *com.meidebi.iPhone.home         优惠/省钱/全球购/打折  首页
     *com.meidebi.iPhone.home99       9块9   首页的9.9
     *com.meidebi.iPhone.yuanchuang    原创    原创频道
     *com.meidebi.iPhone.daigou        代购    代购频道
     *com.meidebi.iPhone.souquan       搜券
     *com.meidebi.iPhone.blsearch      根据关键词进行爆料搜索
     */
    if([idetifier rangeOfString:@"com.meidebi.iPhone.haitao"].location != NSNotFound)
    {
        
        [[self.tabBarControllerConfig.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"0"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeitemNotfication" object:@"海淘"];
        
        
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.home"].location != NSNotFound)
    {
        [[self.tabBarControllerConfig.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"0"];
        
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.home99"].location != NSNotFound)
    {
        [[self.tabBarControllerConfig.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"0"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeitemNotfication" object:@"9.9包邮"];
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.yuanchuang"].location != NSNotFound)
    {
        [[self.tabBarControllerConfig.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"3"];
        
        
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.daigou"].location != NSNotFound)
    {
        [[self.tabBarControllerConfig.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"2"];
        
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.souquan"].location != NSNotFound)
    {
        [[self.tabBarControllerConfig.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"1"];
        
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.blsearch"].location != NSNotFound)
    {
        NSArray *arrtemp = @[@"家居日用",@"数码家电",@"美妆个护",@"鞋包配饰"];
        int itemp = [[idetifier stringByReplacingOccurrencesOfString:@"com.meidebi.iPhone.blsearch" withString:@""] intValue];
        if(itemp<arrtemp.count)
        {
            FindeCouponResultViewController *resultVC = [[FindeCouponResultViewController alloc] initWithSearchKeyword:arrtemp[itemp]];
            //        self.hidesBottomBarWhenPushed=YES;
            [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:resultVC animated:YES];
            //        self.hidesBottomBarWhenPushed=NO;
        }
        
        
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.blsaixuansearch"].location != NSNotFound)
    {
        NSArray *arrtemp = @[@"食品保健",@"母婴玩具",@"钟表配饰",@"运动户外"];
        NSArray *arrid = @[@"52",@"6",@"55",@"53"];
        int itemp = [[idetifier stringByReplacingOccurrencesOfString:@"com.meidebi.iPhone.blsaixuansearch" withString:@""] intValue];
        if(itemp<arrtemp.count)
        {
            NSDictionary *dictemp = @{@"dependentPathSection":@"0",@"itemID":arrid[itemp],@"itemName":arrtemp[itemp]};
            NSArray *types = @[dictemp];
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SearchMainViewController *searchM=[story instantiateViewControllerWithIdentifier:@"com.mdb.SearchMainView.ViewController"];
            searchM.searchContents = types;
            [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:searchM animated:YES];
        }
        
        
    }
    else if([idetifier rangeOfString:@"com.meidebi.iPhone.dgshangjialiebiao"].location != NSNotFound)
    {
        NSArray *arrtemp = @[@"lookfantastic中",@"lookfantastic英",@"unineed",@"feelunique",@"perfume´s club"];
        NSArray *arrid = @[@"1661",@"742",@"1258",@"1260",@"2148"];
        int itemp = [[idetifier stringByReplacingOccurrencesOfString:@"com.meidebi.iPhone.dgshangjialiebiao" withString:@""] intValue];
        if(itemp<arrtemp.count)
        {
            ShopMainTableViewController *svc = [[ShopMainTableViewController alloc] init];
            svc.strshopid = arrid[itemp];
            svc.strshopname = arrtemp[itemp];
            [[self.tabBarControllerConfig.tabBarController selectedViewController] pushViewController:svc animated:YES];
        }
        
        
    }
    
    
    
    /*
     ShopMainTableViewController *svc = [[ShopMainTableViewController alloc] init];
     svc.strshopid = strid;
     svc.strshopname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
     [self.navigationController pushViewController:svc animated:YES];
     */
    
    
    /*
     UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
     
     [navigationController popToRootViewControllerAnimated:YES];
     
     CoreSpotlightTableViewController *coreViewController = [[navigationController viewControllers] firstObject];
     
     [coreViewController showViewControllerWithIdentifier:idetifier];
     */
    
    
    NSLog(@"%@",idetifier);
 
    return YES;
}


#pragma mark - UPLOAD REMARK IMAGES
- (void)uploadRemarkImages:(NSNotification *)notification{
    NSMutableArray *images = [NSMutableArray arrayWithArray:(NSArray *)notification.object];
    NSDictionary *tokenInfoDict = notification.userInfo;
    if (images.count<=0 || tokenInfoDict == nil) {
        [self update:tokenInfoDict];
        return;
    };
    __block NSInteger index = 0;
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil
                                                        progressHandler:^(NSString *key, float percent) {
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    NSArray *tokens = [tokenInfoDict[@"token"] componentsSeparatedByString:@","];
    NSArray *keys = [tokenInfoDict[@"key"] componentsSeparatedByString:@","];
    NSString *type = [NSString nullToString:tokenInfoDict[@"type"]];
    for (NSInteger i = 0; i<images.count; i++) {
        NSData *data = nil;
        if ([images[i] isKindOfClass:[NSData class]]) {
            data = images[i];
        }else{
            data = UIImagePNGRepresentation(images[i]);
        }
        [self.qnUpManager putData:data
                              key:keys[i]
                            token:tokens[i]
                         complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode==200){
                index ++;
                if (index == images.count) {
                    if ([@"11111" isEqualToString:type]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBrokeUpdataImageNotification object:@(YES)];
                    }else{
                        [self update:tokenInfoDict];
                    }
                }
            }else{
                NSDictionary *remarkDict = [[MDB_UserDefault remarkCache] JSONValue];
                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:remarkDict];
                if ([@"100" isEqualToString:parameters[@"type"]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"joinUploadImage" object:@(NO) userInfo:parameters];
                }if ([@"11111" isEqualToString:type]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBrokeUpdataImageNotification object:@(NO)];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUpdataNotification object:@(NO)];
                }
                
            }
        } option:uploadOption];

    }
}

- (void)update:(NSDictionary *)tokenInfoDict{
    NSMutableArray *pics = [NSMutableArray array];
    NSArray *imageNames = [tokenInfoDict[@"key"] componentsSeparatedByString:@","];
    for (NSString *imageName in imageNames) {
        NSString *str = [NSString stringWithFormat:@"%@%@",tokenInfoDict[@"domain"],imageName];
        if (str) {
            [pics addObject:str];
        }
    }
    NSDictionary *remarkDict = [[MDB_UserDefault remarkCache] JSONValue];
    if (!remarkDict) return;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:remarkDict];
    [parameters setValue:pics forKey:@"pics"];
    RemarkHomeDatacontroller * dataController = [[RemarkHomeDatacontroller alloc] init];
    if ([parameters[@"type"] isEqualToString:@"100"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"joinUploadImage" object:@(YES) userInfo:parameters];
    }else{
        [dataController requestHandleRemarkDataWithParameters:parameters InView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
            if(describle==nil)
            {
                describle = @"";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUpdataNotification object:@(state) userInfo:@{kRemarkErrorTips:describle}];
        }];
    }
    
}

#pragma mark - HTTPCookies
-(void)loadHTTPCookies
{
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

-(void)saveHTTPCookies
{
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - shareSDK
-(void)AuthshareSDKSetting{
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupQQWithAppId:@"100311602" appkey:@"1563d7a829419609adc8e8bb39f290bc"];
        [platformsRegister setupWeChatWithAppId:@"wx482499aac0e8d8f7" appSecret:@"9ffaba8e19183fbddb27120482b0fa76"];
        [platformsRegister setupSinaWeiboWithAppkey:@"2987262446" appSecret:@"dee4382cba2ceed538402f0e9cf877af" redirectUrl:@"http://www.meidebi.com.app"];
    }];
    
    /*
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
//                                        @(SSDKPlatformTypeTencentWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)]
                             onImport:^(SSDKPlatformType platformType) {
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [ShareSDKConnector connectQQ:[QQApiInterface class]
                                                    tencentOAuthClass:[TencentOAuth class]];
                                         break;
                                     case SSDKPlatformTypeSinaWeibo:
                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                         break;
                                     default:
                                         break;
                                 }
                                 
                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeSinaWeibo:
                                         //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                         [appInfo SSDKSetupSinaWeiboByAppKey:@"2987262446"
                                                                   appSecret:@"dee4382cba2ceed538402f0e9cf877af"
                                                                 redirectUri:@"http://www.meidebi.com.app"
                                                                    authType:SSDKAuthTypeBoth];
                                         break;
                                     case SSDKPlatformTypeTencentWeibo:
                                         //设置腾讯微博应用信息
                                         [appInfo SSDKSetupTencentWeiboByAppKey:@"801369089"
                                                                      appSecret:@"6af64886b18c1aa2b6ba294fcdb4ca23"
                                                                    redirectUri:@"http://sns.whalecloud.com/app/2UFKo"];
                                         break;
                                     case SSDKPlatformTypeWechat:
                                         //设置微信应用信息
                                         [appInfo SSDKSetupWeChatByAppId:@"wx482499aac0e8d8f7"
                                                               appSecret:@"9ffaba8e19183fbddb27120482b0fa76"];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         //设置QQ应用信息，其中authType设置为只用SSO形式授权
                                         [appInfo SSDKSetupQQByAppId:@"100311602"
                                                              appKey:@"1563d7a829419609adc8e8bb39f290bc"
                                                            authType:SSDKAuthTypeSSO];
                                         break;
                                     default:
                                         break;
                                 }
                             }];
     */
}

#pragma mark - Status bar touch tracking
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    @try
    {
        [super touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
    @try
    {
        CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        if (CGRectContainsPoint(statusBarFrame, location)) {
            [self statusBarTouchedAction];
        }
    }
    @finally
    {
        
    }
    
}

- (void)statusBarTouchedAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusBarTappedNotification
                                                        object:nil];
}

#pragma mark - setters and getters
- (QNUploadManager *)qnUpManager{
    if (!_qnUpManager) {
        _qnUpManager = [[QNUploadManager alloc] init];
    }
    return _qnUpManager;
}

- (NSMutableArray *)mutPhotos{
    if (!_mutPhotos) {
        _mutPhotos =[[NSMutableArray alloc]init];
    }
    return _mutPhotos;
}


-(void)VersonUpdate{
    //定义的app的地址
    NSString *urld = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"659197645"];
    
    //网络请求app的信息，主要是取得我说需要的Version
    NSURL *url = [NSURL URLWithString:urld];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            //data是有关于App所有的信息
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
                
                //请求的有数据，进行版本比较
                [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
    }];
    
    [task resume];
}

-(void)receiveData:(id)sender
{
    //获取APP自身版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    NSString *strtemp = [NSString stringWithFormat:@"%@",[sender objectForKey:@"version"]];
    
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *versionArray = [sender[@"version"] componentsSeparatedByString:@"."];
    
    
    if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
        
        if ([localArray[0] intValue] <  [versionArray[0] intValue]) {
            [self updateVersion:strtemp];
        }else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue]) {
                [self updateVersion:strtemp];
            }else if ([localArray[1] intValue] ==  [versionArray[1] intValue]){
                if ([localArray[2] intValue] <  [versionArray[2] intValue]) {
                    [self updateVersion:strtemp];
                }
            }
        }
    }
}
-(void)updateVersion:(NSString *)sversion{
    
    if(dicuploadalder!= nil)
    {
        [self showUploadAlter];
    }
    else
    {
        NSDictionary *parameters=[NSDictionary new];
        [HTTPManager sendGETRequestUrlToService:APP_Upload_alter withParametersDictionry:parameters view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue]==1)
            {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    dicuploadalder = [dicAll objectForKey:@"data"];
                    NSString *strgetvesdion = [NSString stringWithFormat:@"%@",[dicuploadalder objectForKey:@"version"]];
                    if([strgetvesdion isEqualToString:sversion])
                    {
                        [self showUploadAlter];
                    }
                    
                }
                
            }
            else
            {
                
            }
            
        }];
    }
}

-(void)showUploadAlter
{
    NSString *msg = [NSString stringWithFormat:@"%@", [NSString nullToString:[dicuploadalder objectForKey:@"description"]]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *ios_state = [NSString stringWithFormat:@"%@", [NSString nullToString:[dicuploadalder objectForKey:@"ios_state"]]];
    
    if([ios_state isEqualToString:@"1"])
    {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
            [self showUploadAlter];
            if (@available(iOS 11.0 , *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"659197645"]]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=659197645"]];
            }
            
        }];
        [alertController addAction:otherAction];
    }
    else
    {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
            if (@available(iOS 11.0 , *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"659197645"]]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=659197645"]];
            }
            
        }];
        [alertController addAction:otherAction];
        
        UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
            
        }];
        [alertController addAction:otherAction1];
        
    }
    
    
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    [req openID];
}
-(void) onResp:(BaseResp*)resp
{
    @try {
        
        if([resp isKindOfClass:[PayResp class]])
        {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:[NSString stringWithFormat:@"%d",resp.errCode] forKey:@"errCode"];
            [dic setObject:[NSString nullToString:[(PayResp *)resp returnKey]] forKey:@"returnKey"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinzhifupay" object:dic];
        }

    }
    @catch (NSException *exception) {

    }
    @finally {

    }


}

@end
