//
//  DeviceUtils.h
//  RedPacket
//
//  Created by peng on 2018/6/12.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// iPhone4S

#define IS_iPhone_4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhone5 iPhone5s iPhoneSE

#define IS_iPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhone6 7 8

#define IS_iPhone_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

// iPhone6plus  iPhone7plus iPhone8plus

#define IS_iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

// iPhoneX

//#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define  IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size) : NO)
//#define  IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(828, 1792), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(1242, 2688), [UIScreen mainScreen].bounds.size) : NO)
#define kNavBarHeight              ([DeviceUtils deviceType] == IPhone_X ? 88.0 : 64.0)

#define kBottomBarHeight        ([DeviceUtils deviceType] == IPhone_X ? 34.0 : 0)

typedef NS_ENUM(NSInteger,DeviceType) {
    
    Unknown = 0,
    Simulator,
    IPhone_1G,          //基本不用
    IPhone_3G,          //基本不用
    IPhone_3GS,         //基本不用
    IPhone_4,           //基本不用
    IPhone_4s,          //基本不用
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X,
};
@interface DeviceUtils : NSObject
+ (DeviceType)deviceType;

+ (NSString*)deviceModelName;
@end
