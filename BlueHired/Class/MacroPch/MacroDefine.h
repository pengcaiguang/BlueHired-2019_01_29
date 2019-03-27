//
//  MacroDefine.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define WEAK_SELF()  __weak __typeof(self) weakSelf = self;

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//http://ceshi.lanpin123.com/lifetime/comment/get_comment_list?id=38&page=1&type=1
//#define BaseRequestURL  @"http://192.168.0.152:8080/lifetime/"

//#define BaseRequestURL  @"http://192.168.0.108:8080/lifetime/"
//#define BaseRequestWeiXiURL  @"http://192.168.0.108:8080/"
//#define BaseRequestCookie  @"192.168.0.108"

//#define BaseRequestURL  @"http://www.lanpin123.com/lifetime/"
//#define BaseRequestWeiXiURL  @"http://www.lanpin123.com/"
//#define BaseRequestCookie  @"www.lanpin123.com"

//#define BaseRequestURL  @"http://47.106.208.91:8180/lifetime/"
//#define BaseRequestWeiXiURL  @"http://47.106.208.91/"
//#define BaseRequestCookie  @"47.106.208.91"

//#define BaseRequestURL  @"http://ceshi.lanpin123.com/lifetime/"
//#define BaseRequestWeiXiURL  @"http://ceshi.lanpin123.com/"
//#define BaseRequestCookie  @"ceshi.lanpin123.com"

//
#define BaseRequestURL  @"http://192.168.0.169:8080/lifetime/"        //胡经理
#define BaseRequestWeiXiURL  @"http://192.168.0.169/"
#define BaseRequestCookie  @"192.168.0.169"

#define QiNiuBaseUrl @"http://pic.lanpin123.com/"

//UserDefaults存取
#pragma NSUserDefaults

#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kUserDefaultsSave(value,key) [LPUserDefaults saveValue:value forKey:key]
#define kUserDefaultsRemove(key) [LPUserDefaults removeValueWithKey:key]
#define kUserDefaultsValue(key) [LPUserDefaults valueWithKey:key]
#define kAppDelegate        ((AppDelegate *)[UIApplication sharedApplication].delegate)

/**
 * 登录成功后保存
 */
#define OLDLOGINID  @"OLDOGINID"
#define LOGINID  @"LOGINID"
#define COOKIES  @"COOKIES"
#define COOKIES2  @"COOKIES2"

#define USERDATA  @"USERDATA"
#define USERIDENTIY  @"USERidentity"
#define BOOK  @"Cashbook"
#define WORKTYPE  @"WorkType"

//登录状态
#define kLoginStatus    @"LoginStatus"
//登录Token
#define kLoginToken     @"LoginToken"

#define AlreadyLogin    [kUserDefaultsValue(kLoginStatus) boolValue]

//DeviceToken
#define kDeviceToken     @"kDeviceToken"
#define kcredentials      @"credentials"
#define ktoken            @"token"
#define USERINFO           @"USERINFO"
/**
 * 通用提示语
 */
#define  DEFAULT_LOADING_MESSAGE    @"数据加载中"
#define  UPLOAD_LOADING_MESSAGE     @"数据上传中"
#define  NETE_ERROR_MESSAGE         @"网络不给力，请稍候再试"
#define  NO_MORE_DATA_MESSAGE       @"没有更多数据了"
//#define  NETE_REQUEST_ERROR         @"当前网络不可用，请检查您的网络设置"
#define  NETE_REQUEST_ERROR         @"当前网络请求超时,请稍候再试"
#define  TOKEN_ERROR_MESSAGE        @"该账号已在其他设备上登录"
#define     RESETREQUESTURL  @"RESETREQUESTURL"

/**
 * 信息提示显示时间 单位为秒
 */
#define  MESSAGE_SHOW_TIME       1

#define TimeOutIntervalSet       60

/**
 * 判空处理
 */
//判断对象是否为空
#define reviseString(temp)     [NSString reviseString:temp]

/**
 * 判空处理
 */
//判断对象是否为空
#define ISNIL(temp)     (temp == nil || [temp isKindOfClass:[NSNull class]])

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 || dic.count == 0)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//字符串矫正,将任何非字符串类型的对象转成字符串
#define kCorrectString(value) \
({\
__typeof__(value) __a = (value); \
![__a isKindOfClass:[NSString class]] ? __a = @"" : __a; \
})


#define SetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//** 颜色定义*/
#define ViewBgColor SetColor(245, 245, 245, 1)
#define LightTextColor SetColor(102, 102, 102, 1)
#define BlackTextColor SetColor(51, 51, 51, 1)
#define TextBlackColor SetColor(178, 178, 178, 1)
#define NavBackColor SetColor(61, 199, 112, 1)
#define LineColor SetColor(236, 236, 236, 1.0)
#define OrangerColor SetColor(251, 182, 97, 1)
#define WhiteColor  SetColor(255, 255, 255, 1)
#define GreenColor  SetColor(61, 199, 112, 1)

#define AlertMsg(alertMsg) [[SGAlertUtil alertManager]alertNowTimeWith:alertMsg];
#define Alert(alertMsg) [[SGAlertUtil alertManager]alertNowTimeWith:alertMsg];
#define CurrentDeviceSn [[UIDevice currentDevice].identifierForVendor UUIDString]//手机序列号
#define RemovernNil(alertMsg) [LPTools isNullToString:alertMsg]



#endif /* MacroDefine_h */
