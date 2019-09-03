//
//  AppDelegate.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "AppDelegate.h"
#import "LPTabBarViewController.h"
@import Firebase;
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>
#import "LPHongBaoVC.h"
#import "LPWorkHour2VC.h"
#import "LPEssaylistModel.h"
#import "LPEssayDetailVC.h"
#import "LPWXLoginBindingVC.h"
#import "DHGuidePageHUD.h"
#import "LPAdvertModel.h"
#import "ADAlertView.h"
#import "ADModel.h"
#import "LPActivityDatelisVC.h"
#import "LPActivityModel.h"
#import <Bugly/Bugly.h>

//极光
static NSString *appKey = @"1f178d6e983414ed2ee662fb";
static NSString *channel = @"edf99cf2a69b26084499b31b";
static BOOL isProduction = YES;
//极光测试
//static NSString *appKey = @"2fd800e71146331dbcd9ffde";
//static NSString *channel = @"37043b9486c186aa9abd902b";
//static BOOL isProduction = NO;
//微信
static NSString *WXAPPID = @"wx566f19a70d573321";
//QQ
static NSString *QQAPPID = @"1107911286";
//高德地图key
static NSString *AMapKey = @"0f4330993390e62d08cd4964e1f94a06";

//百度Ocr
static NSString *OCRAk = @"afnwBt8L3Th1ZDyEkmNL7QKd";
static NSString *OCRSK = @"AuzzqkelToqzXjsaKI4n2L6U9QaH92Vs";
//百度地图key
static NSString *BaiduMapKey = @"Is1tZn8s2L4SvALlxeBjef5Rzi3a7luV";

//BugLy appID
static NSString *BugLy_App_ID = @"ee0d53e516";

BMKMapManager* _mapManager;
static AFHTTPSessionManager * afHttpSessionMgr = NULL;

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) LPTabBarViewController *mainTabBarController;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic,assign) NSTimer *countDownTimer;
@property (nonatomic,assign) NSInteger seconds;//倒计时
@property (nonatomic,strong)LPAdvertModel *AdvertModel;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
 
    _mapManager = [[BMKMapManager alloc]init];
    //百度AR识别
//    #if !TARGET_IPHONE_SIMULATOR
//    [[AipOcrService shardService] authWithAK:OCRAk andSK:OCRSK];
//    #endif

    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduMapKey authDelegate:self];
    BOOL ret = [_mapManager start:BaiduMapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // 要使用百度地图，请先启动BaiduMapManager
     [FIRApp configure];
    [Fabric with:@[[Crashlytics class]]];
    [Fabric.sharedSDK setDebug:YES];
    
    //高德地图key
    [AMapServices sharedServices].apiKey = AMapKey;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    [self startCheckNet];

    [self showTabVc:0];

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
 
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];

    
    [WXApi registerApp:WXAPPID];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
    
    //BugLy
    [Bugly startWithAppId:BugLy_App_ID];


    [LPTools deleteWebCache];
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    
  
   
    
    
    return YES;
}
-(void)showTabVc:(NSInteger)tabIndex{
    if (!self.mainTabBarController) {
        _mainTabBarController = [[LPTabBarViewController alloc] init];
        //        self.window.rootViewController = _mainTabBarController;
        //        [self.window makeKeyAndVisible];
    }
    [self.mainTabBarController setSelectedIndex:tabIndex];

    self.window.rootViewController = _mainTabBarController;
    [self.window makeKeyAndVisible];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        NSArray *imageNameArray = @[@"guideImage1",@"guideImage2",@"guideImage3",@"guideImage4"];
        // 创建并添加引导页
        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.window.frame imageNameArray:imageNameArray buttonIsHidden:NO isShowBt:NO isTouchNext:NO];
        guidePage.slideInto = NO;
        [self.window addSubview:guidePage];
    }
    
}
//退出登录
- (void)LoginOut {
//    //移除token 等用户信息
//    kUserDefaultsRemove(ktoken);
//    kUserDefaultsRemove(kcredentials);
//    kUserDefaultsRemove(kLoginStatus);
//    //跳转到登录页面
//    JWLoginVC *vc = [[JWLoginVC alloc]init];
//    RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:vc];
//    self.window.rootViewController = navi;
//    [self.window makeKeyAndVisible];
}
//启动网络监控
-(void)startCheckNet{
    _moninNet = [[MoninNet alloc]init];
    [_moninNet startMoninNet];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //进入后台;

    NSLog(@"进入后台,请空倒计时");
    
    
    if (_seconds>0) {
       [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        _seconds=-1;
    }
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [self requestQueryGetRedPacketStatus];
//    [self requestQueryActivityadvert];
    [self requestQueryDownload];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [LPUserDefaults saveObject:@"1" byFileName:[NSString stringWithFormat:@"CIRCLELISTCACHEISLogin"]];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
 
     [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
 didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
 }

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
     }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

//微信
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSString *path = [url absoluteString];
    if ([path hasPrefix:@"tencent"]) {
        
        //        if ([self.qqDelegate respondsToSelector:@selector(shareSuccssWithQQCode:)]) {
        //            [self.qqDelegate shareSuccssWithQQCode:[[path substringWithRange:NSMakeRange([path rangeOfString:@"&error="].location+[path rangeOfString:@"&error="].length, [path rangeOfString:@"&version"].location-[path rangeOfString:@"&error="].location)] integerValue]];
        //        }
        //        return [TencentOAuth HandleOpenURL:url];
    } else if([path hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString *path = [url absoluteString];
    if ([path hasPrefix:@"tencent"]){
         //        return[TencentOAuth HandleOpenURL:url];
     }else if([path hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}


-(void)onReq:(BaseReq *)req{
    
}

-(void)onResp:(BaseResp *)resp {
    NSLog(@"收到微信回调");
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *rep = (SendAuthResp *)resp;
        if (rep.errCode == 0) {
            NSString *secret = @"5e0a49ea067ffd82a55e556aba209da6";
            AFHTTPSessionManager *manager = [AppDelegate initHttpManager];
            NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,secret,rep.code];
//            https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
            NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

            [manager GET:encodedUrl
              parameters:nil
                progress:^(NSProgress * _Nonnull downloadProgress) {
                    NSLog(@"收到微信回调 downloadProgress");

                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"收到微信回调 responseObject %@",responseObject);
                     if (responseObject[@"unionid"]) {
                         
                         NSString *Infourl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",responseObject[@"access_token"],responseObject[@"openid"]];
                         NSString *encodedInfourl = [NSString stringWithString:[Infourl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

                         //获取用户信息
                         [manager GET:encodedInfourl
                           parameters:nil
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 NSLog(@"收到微信回调 downloadProgress");
                                 
                             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 NSLog(@"收到微信回调 responseObject %@",responseObject);
                                 if (responseObject[@"unionid"]) {
                                     LPWXUserInfoModel *UserModel = [LPWXUserInfoModel mj_objectWithKeyValues:responseObject];
                                     
                                     if ([self.WXdelegate respondsToSelector:@selector(LPWxLoginHBBack:)]) {
                                         [self.WXdelegate LPWxLoginHBBack:UserModel];
//                                         [self.navigationController  popViewControllerAnimated:YES];
                                     }
                                     
                                  }
                                 
                                 
                             }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSLog(@"收到微信回调 %@",error);
                                 //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
                                 //错误信息已经过处理为NSString,可直接用于展示
                                 //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
                                 
                             }];
                         
                        
                     }
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"收到微信回调 %@",error);
                     //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
                    //错误信息已经过处理为NSString,可直接用于展示
                    //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
                 
                }];
        }
    }
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//        NSString *type = [LPTools isNullToString:userInfo[@"type"]];
//        if(type.integerValue == 1 && AlreadyLogin){             //工时记录
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                LPWorkHourVC *vc = [[LPWorkHourVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            });
//        }else if (type.integerValue == 2){      //新闻详情
//            LPEssaylistDataModel *DataModel = [[LPEssaylistDataModel alloc] init];
//              DataModel.id = userInfo[@"id"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                vc.essaylistDataModel = DataModel;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            });
//        }
 
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
     completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
         NSString *type = [LPTools isNullToString:userInfo[@"type"]];
        if(type.integerValue == 1 && AlreadyLogin){             //工时记录
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LPWorkHour2VC *vc = [[LPWorkHour2VC alloc]init];
                vc.isPush = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            });
        }else if (type.integerValue == 2){      //新闻详情
            LPEssaylistDataModel *DataModel = [[LPEssaylistDataModel alloc] init];
            DataModel.id = userInfo[@"id"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.essaylistDataModel = DataModel;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            });
        }
         [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


-(void)requestQueryDownload{
    NSDictionary *dic = @{
                          @"type":@"2"
                          };
    [NetApiManager requestQueryDownload:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"] != nil &&
                    [responseObject[@"data"][@"version"] length]>0) {
                    if (self.version.floatValue <  [responseObject[@"data"][@"version"] floatValue]  ) {
                        NSString *updateStr = [NSString stringWithFormat:@"发现新版本V%@\n为保证软件的正常运行\n请及时更新到最新版本",responseObject[@"data"][@"version"]];
                        [self creatAlterView:updateStr];
                    }
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
            
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


//3. 弹框提示
-(void)creatAlterView:(NSString *)msg{
    UIAlertController *alertText = [UIAlertController alertControllerWithTitle:@"更新提醒" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //增加按钮
//    [alertText addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }]];
    [alertText addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1441365926?mt=8"; //更换id即可
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    [[UIWindow visibleViewController] presentViewController:alertText animated:YES completion:nil];
}
//版本
-(NSString *)version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version       = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}




-(void)requestQueryGetRedPacketStatus{
    [NetApiManager requestQueryGetRedPacketStatus:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                 if ([responseObject[@"data"][@"status"] integerValue] == 1) {
                    if (self.countDownTimer) {
                        [self.countDownTimer invalidate];
                        self.countDownTimer = nil;
                        self.seconds=-1;
                    }
                    self.seconds = [responseObject[@"data"][@"allTime"] integerValue];
                    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
         }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)timeFireMethod{
    _seconds--;
//    NSLog(@"红包雨倒计时 = %ld",(long)_seconds);
     if(_seconds ==0){
        [self.countDownTimer invalidate];
         self.countDownTimer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LPHongBaoVC *vc = [[LPHongBaoVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController   pushViewController:vc animated:YES];
        });
    }
}
 
//AFHTTPSessionManager初始化
+(AFHTTPSessionManager *)initHttpManager {
    if(afHttpSessionMgr == NULL ){
        afHttpSessionMgr = [AFHTTPSessionManager manager];
        afHttpSessionMgr.responseSerializer = [AFJSONResponseSerializer serializer];
        afHttpSessionMgr.requestSerializer =[AFJSONRequestSerializer serializer];
        [afHttpSessionMgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
        afHttpSessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        afHttpSessionMgr.requestSerializer.timeoutInterval = TimeOutIntervalSet;
    
    }
    
    return afHttpSessionMgr;
}

@end
