//
//  AppDelegate.h
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoninNet.h"
#import "WXApi.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>
#import "LPWXUserInfoModel.h"
 

@protocol LPWxLoginHBDelegate <NSObject>

- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,TencentSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) MoninNet* moninNet;
@property (nonatomic,assign)id <LPWxLoginHBDelegate>WXdelegate;

//退出登录
- (void)LoginOut;
@end

