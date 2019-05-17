//
//  NetRequestManager.m
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import "NetRequestManager.h"
#import "NetApiManager.h"
#import "AppDelegate.h"
#import "LPUserModel.h"
#import "DSBaActivityView.h"

static AFHTTPSessionManager * afHttpSessionMgr = NULL;

@implementation NetRequestManager
+ (void) requestWithEnty:(NetRequestEnty *)requestEnty
{
    NSLog(@"\n\nrequestEnty.requestUrl == %@\n",requestEnty.requestUrl);
    if(![NetApiManager getNetStaus]){ //无网统一提示
//        [[UIWindow visibleViewController].view showLoadingMeg:NETE_ERROR_MESSAGE time:3];
//        [LPTools AlertMessageView:NETE_ERROR_MESSAGE dismiss:1];
        [NetRequestManager HiddView];
        requestEnty.responseHandle(NO,nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            [DSBaActivityView hideActiviTy];
        });
        return;
    }
//    if ([self getProxyStatus]) {//系统设置了代理
//        requestEnty.responseHandle(NO,nil);
//        return;
//    }
//    if ([self getWithURL:requestEnty]) {
//        requestEnty.responseHandle(YES, [self getWithURL:requestEnty]);
//    }
    if (requestEnty.requestType == 0) { //请求方式 0:get
        NSLog(@"\n\nGET requestEnty.params == %@",requestEnty.params);
        AFHTTPSessionManager *manager = [self initHttpManager];

        if (AlreadyLogin) {
//            NSLog(@"%@",kUserDefaultsValue(COOKIES));
//            [manager.requestSerializer setValue:kUserDefaultsValue(COOKIES) forHTTPHeaderField:@"Cookie"];
            if (kUserDefaultsValue(COOKIES)) {
 
                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                [cookieProperties setObject:@"user" forKey:NSHTTPCookieName];
                [cookieProperties setObject:[kUserDefaultsValue(COOKIES) substringFromIndex:5] forKey:NSHTTPCookieValue];
                [cookieProperties setObject:BaseRequestCookie forKey:NSHTTPCookieDomain];
                [cookieProperties setObject:BaseRequestCookie forKey:NSHTTPCookieOriginURL];
                [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
                [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
                NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30];
                [cookieProperties setObject:expiresDate forKey:NSHTTPCookieExpires];

                NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                
            }

        }else{
            [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];

        }
 

//        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//            NSLog(@"%@", cookie);
//        }
        
        
        afHttpSessionMgr.requestSerializer =[AFJSONRequestSerializer serializer];

        [manager GET:requestEnty.requestUrl
          parameters:requestEnty.params
            progress:^(NSProgress * _Nonnull downloadProgress) {
//                [self performSelector:@selector(HiddView) withObject:nil afterDelay:0.1];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [NetRequestManager HiddView];

//                NSHTTPURLResponse* response = (NSHTTPURLResponse* )task.response;
//                NSDictionary *allHeaderFieldsDic = response.allHeaderFields;
//                NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
//                if (setCookie != nil) {
//                    NSString *cookie = [[setCookie componentsSeparatedByString:@";"] objectAtIndex:0];
//                    NSLog(@"cookie : %@", cookie); // 这里可对cookie进行存储
//                    kUserDefaultsSave(cookie, COOKIES);
//                }
                
                [self commonCheckErrorCode:responseObject];
                if ([requestEnty.requestUrl containsString:@"login/user_sign_out"]) {
                    
                    kUserDefaultsSave(@"0", kLoginStatus);
                     kUserDefaultsRemove(COOKIES);
                    kUserDefaultsRemove(USERDATA);
                    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
                    for(id obj in cookieArray)
                    {
                        [cookieJar deleteCookie:obj];
                    }
                }
                
                
                //获取cookie
                NSHTTPURLResponse* response = (NSHTTPURLResponse* )task.response;
                NSDictionary *allHeaderFieldsDic = response.allHeaderFields;
                NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
                if (setCookie != nil) {
                    NSString *cookie = [[setCookie componentsSeparatedByString:@";"] objectAtIndex:0];
                    NSLog(@"cookie : %@", cookie); // 这里可对cookie进行存储
                    NSString *cookiejiemi =  [NetRequestManager decodeFromPercentEscapeString:cookie];
                    NSDictionary *dic = [NetRequestManager dictionaryWithJsonString:[cookiejiemi substringFromIndex:5]];
                    //                     [LPTools shareInstance].UserRole = [dic[@"role"] integerValue];
                    if (dic) {
                        kUserDefaultsSave(dic[@"role"], USERDATA);
                        kUserDefaultsSave(dic[@"userId"], LOGINID);
                        kUserDefaultsSave(dic[@"USERIDENTIY"], USERIDENTIY);

                        if (dic[@"userId"]) {
                            kUserDefaultsSave(@"1", kLoginStatus);
                         }
                        if ([kUserDefaultsValue(LOGINID) integerValue]  != [kUserDefaultsValue(OLDLOGINID) integerValue]) {
                            kUserDefaultsRemove(ERRORTIMES);
                        }
                        
                        LPUserMaterialModel *userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
                        if (userMaterialModel) {
                            userMaterialModel.data.role = dic[@"role"];
                            userMaterialModel.data.user_url = dic[@"userImage"];
                            userMaterialModel.data.user_name = dic[@"userName"];
                            userMaterialModel.data.workStatus = dic[@"workStatus"];
                            userMaterialModel.data.grading = dic[@"grading"];
                            userMaterialModel.data.identity = dic[@"identity"];

                            [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
                        }else{
                            LPUserMaterialModel *userMaterialModel = [[LPUserMaterialModel alloc] init];
                            LPUserMaterialDataModel *data = [[LPUserMaterialDataModel alloc] init];
                            data.role = dic[@"role"];
                            data.user_url = dic[@"userImage"];
                            data.user_name = dic[@"userName"];
                            data.workStatus = dic[@"workStatus"];
                            data.grading = dic[@"grading"];
                            userMaterialModel.data.identity = dic[@"identity"];

                            userMaterialModel.data = data;
                            
                            [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
                        }
                        
                        
                        
                        kUserDefaultsSave(cookie, COOKIES);
                    }
                   
                }
                
                

                requestEnty.responseHandle(YES,responseObject);
                [self saveWithURL:requestEnty response:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [NetRequestManager HiddView];

                NSString * errorStr = [self returnStringWithError:error];
                //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
                //错误信息已经过处理为NSString,可直接用于展示
                //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
                requestEnty.responseHandle(NO,errorStr);
                if ([self getWithURL:requestEnty]) {
//                    [self performSelector:@selector() withObject:nil afterDelay:0.1];

                    requestEnty.responseHandle(YES, [self getWithURL:requestEnty]);
                }
            }];
    }else if (requestEnty.requestType == 1){//请求方式 1:post
        NSLog(@"\n\nPOST requestEnty.params == %@",requestEnty.params);
        AFHTTPSessionManager *manager = [self initHttpManager];

        if (AlreadyLogin) {
//            [manager.requestSerializer setValue:kUserDefaultsValue(COOKIES) forHTTPHeaderField:@"Cookie"];
            if (kUserDefaultsValue(COOKIES)) {
                
                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                [cookieProperties setObject:@"user" forKey:NSHTTPCookieName];
                [cookieProperties setObject:[kUserDefaultsValue(COOKIES) substringFromIndex:5] forKey:NSHTTPCookieValue];
                [cookieProperties setObject:BaseRequestCookie forKey:NSHTTPCookieDomain];
                [cookieProperties setObject:BaseRequestCookie forKey:NSHTTPCookieOriginURL];
                [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
                [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
                NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30];
                [cookieProperties setObject:expiresDate forKey:NSHTTPCookieExpires];
                
                NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                
            }
        }else{
            [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
        }
        afHttpSessionMgr.requestSerializer =[AFJSONRequestSerializer serializer];

        [manager POST:requestEnty.requestUrl
           parameters:requestEnty.params
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 NSHTTPURLResponse* response = (NSHTTPURLResponse* )task.response;
                 NSDictionary *allHeaderFieldsDic = response.allHeaderFields;
                 NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
                 if (setCookie != nil) {
                     NSString *cookie = [[setCookie componentsSeparatedByString:@";"] objectAtIndex:0];
                     NSLog(@"cookie : %@", cookie); // 这里可对cookie进行存储
                     NSString *cookiejiemi =  [NetRequestManager decodeFromPercentEscapeString:cookie];
                     NSDictionary *dic = [NetRequestManager dictionaryWithJsonString:[cookiejiemi substringFromIndex:5]];
//                     [LPTools shareInstance].UserRole = [dic[@"role"] integerValue];
                     if (dic) {
                         kUserDefaultsSave(dic[@"role"], USERDATA);
                         
                         kUserDefaultsSave(dic[@"userId"], LOGINID);
                         kUserDefaultsSave(dic[@"USERIDENTIY"], USERIDENTIY);
                         if (dic[@"userId"]) {
                             kUserDefaultsSave(@"1", kLoginStatus);
                         }
                         LPUserMaterialModel *userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
                         if (userMaterialModel) {
                             userMaterialModel.data.role = dic[@"role"];
                             userMaterialModel.data.user_url = dic[@"userImage"];
                             userMaterialModel.data.user_name = dic[@"userName"];
                             userMaterialModel.data.workStatus = dic[@"workStatus"];
                             userMaterialModel.data.grading = dic[@"grading"];
                             userMaterialModel.data.identity = dic[@"identity"];

                              [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
                         }else{
                             LPUserMaterialModel *userMaterialModel = [[LPUserMaterialModel alloc] init];
                             LPUserMaterialDataModel *data = [[LPUserMaterialDataModel alloc] init];
                             data.role = dic[@"role"];
                             data.user_url = dic[@"userImage"];
                             data.user_name = dic[@"userName"];
                             data.workStatus = dic[@"workStatus"];
                             data.grading = dic[@"grading"];
                             userMaterialModel.data.identity = dic[@"identity"];

                             userMaterialModel.data = data;
                             [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
                         }
 
                          kUserDefaultsSave(cookie, COOKIES);
                     }
                     
                 }
                 [NetRequestManager HiddView];

                 [self commonCheckErrorCode:responseObject];
                 requestEnty.responseHandle(YES,responseObject);
                 [self saveWithURL:requestEnty response:responseObject];

             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 NSString * errorStr = [self returnStringWithError:error];
                 //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
                 //错误信息已经过处理为NSString,可直接用于展示
                 //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
                 [NetRequestManager HiddView];

                 requestEnty.responseHandle(NO,errorStr);
                 if ([self getWithURL:requestEnty]) {

                     requestEnty.responseHandle(YES, [self getWithURL:requestEnty]);
                 }
             }];
    }else if (requestEnty.requestType == 2){// 2:上传单张图片
        NSLog(@"\n\nPOST 单张图片上传requestEnty.params == %@",requestEnty.params);
        AFHTTPSessionManager *manager = [self initHttpManager];

        if (AlreadyLogin) {
            [manager.requestSerializer setValue:kUserDefaultsValue(COOKIES) forHTTPHeaderField:@"Cookie"];
        }else{
            [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
        }
        afHttpSessionMgr.requestSerializer =[AFJSONRequestSerializer serializer];

        [manager POST:requestEnty.requestUrl
           parameters:requestEnty.params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
        if (requestEnty.singleImage) {
            NSData *imageData = UIImageJPEGRepresentation(requestEnty.singleImage, 0.5);
            [formData appendPartWithFileData:imageData
                                        name:requestEnty.singleImageName
                                    fileName:@"image.jpeg"
                                    mimeType:@"image/jpeg"];
        }
    
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self commonCheckErrorCode:responseObject];
            requestEnty.responseHandle(YES,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString * errorStr = [self returnStringWithError:error];
            //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
            //错误信息已经过处理为NSString,可直接用于展示
            //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
            requestEnty.responseHandle(NO,errorStr);
        }];
    }else if (requestEnty.requestType == 3){//3:上传多张图片
        NSLog(@"\n\nPOST 多张图片上传requestEnty.params == %@",requestEnty.params);
        AFHTTPSessionManager *manager = [self initHttpManager];

        if (AlreadyLogin) {
            [manager.requestSerializer setValue:kUserDefaultsValue(COOKIES) forHTTPHeaderField:@"Cookie"];
        }else{
            [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
        }
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];

        
        [manager POST:requestEnty.requestUrl
           parameters:requestEnty.params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    for (int i = 0; i < requestEnty.imagesArray.count; i++) {
        UIImage *image = requestEnty.imagesArray[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@%d.jpg", dateString,i];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:imageData name:@"fileList" fileName:fileName mimeType:@"image/jpg"]; //
    }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self commonCheckErrorCode:responseObject];
                requestEnty.responseHandle(YES,responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString * errorStr = [self returnStringWithError:error];
                //打开可统一提示错误信息(考虑有的场景可能不需要,由自己去选择是否显示错误信息),
                //错误信息已经过处理为NSString,可直接用于展示
                //            [kKeyWindow showLoadingMeg:errorStr time:MESSAGESHOWTIME];
                requestEnty.responseHandle(NO,errorStr);
            }];
    }
}

//检查通用错误 可扩展增加相应错误码及相关处理即可
//{
//    code, //api执行结果，（1、成功  0、业务失败  2、未登陆  3、无权访问  404、无此接口  500、程序异常）此结果不等同于业务执行结果，只是单单表示api的程序是否正常执行成功。具体的业务执行结果在data字段中按需提供。
//    data, //具体的业务数据，形态结构不定
//    message, //用于api调用结果的文字提示
//security: { //通常当安全信息不需要更新时，security 为 null
//    time //unix timestamp
//    token //用于更新本地存储的token
//},
//fail: {    //失败时出现
//code: 1,    //code为0时不出现，视为默认业务执行失败。    当出现值不为0时，开发时的具体业务逻辑需根据此值判断/决定下一步操作。
//    ...         //用户失败处理逻辑的相关数据，字段名为不定
//}
//}


+(BOOL)commonCheckErrorCode:(id)responseObject{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSString * codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSString * msgStr = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
//        if (kStringIsEmpty(msgStr)) {
//            msgStr = TOKEN_ERROR_MESSAGE;
//        }
//        NSString * security = [NSString stringWithFormat:@"%@",responseObject[@"security"]];
//
//        if (kStringIsEmpty(security)) {
//            NSString * token = [NSString stringWithFormat:@"%@",responseObject[@"security"][@"token"]];
//            if (kStringIsEmpty(token)) {
//                kUserDefaultsSave(token, ktoken);
//            }
//        }
        if ([codeStr integerValue] == 10002) {
//            kUserDefaultsSave(@"0", kLoginStatus);
            return YES;
        }else{
            return YES;
        }
//        else if([codeStr integerValue] == 2){
//            [self performSelector:@selector(tokenErrorBackToLoginVC) withObject:nil afterDelay:MESSAGE_SHOW_TIME];
//            return NO;
//        }else if([codeStr integerValue] == 10){
//            return NO;
//        }else{
//            return NO;
//        }
        
//        if ([codeStr isEqualToString:@"101"]) { //2017.7.27约定token错误唯一错误码为101
//            [[UIWindow visibleViewController].view showLoadingMeg:msgStr time:MESSAGE_SHOW_TIME];
//            [self performSelector:@selector(tokenErrorBackToLoginVC) withObject:nil afterDelay:MESSAGE_SHOW_TIME];
//        }
    }else{
        return NO;
    }
}

+(void)tokenErrorBackToLoginVC{
//    [kAppDelegate LoginOut];
//    ((AppDelegate *)[UIApplication sharedApplication].delegate)
    [((AppDelegate *)[UIApplication sharedApplication].delegate) LoginOut];
}

//错误信息处理
+ (NSString *)returnStringWithError:(NSError * _Nonnull)error {
    NSLog(@"%@",error);
    NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString * errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(![NetApiManager getNetStaus]){ //无网统一提示
        errorStr = NETE_ERROR_MESSAGE;
    }else { //有网但是请求错误
//        if (error.code == -999) {
//            NSLog(@"证书错误");
//            [NetInstance shareInstance].baseUrl = BaseRequestURL;
//            [self cancelAllRequest];
//        }
        if ([[NetInstance shareInstance].baseUrl isEqualToString:BaseRequestURL]) {
            if (kStringIsEmpty(errorStr)) {
                errorStr = NETE_REQUEST_ERROR;
            }
        }else{
            [NetInstance shareInstance].baseUrl = BaseRequestURL;
            [self cancelAllRequest];
            return RESETREQUESTURL;
        }
        
        
//        if (kStringIsEmpty(errorStr)) {
//            errorStr = NETE_REQUEST_ERROR;
//        }
    }
    return errorStr;
}

//AFHTTPSessionManager初始化
+ (AFHTTPSessionManager *)initHttpManager {
    if(afHttpSessionMgr == NULL ){
        afHttpSessionMgr = [AFHTTPSessionManager manager];
        afHttpSessionMgr.responseSerializer = [AFJSONResponseSerializer serializer];
        afHttpSessionMgr.requestSerializer =[AFJSONRequestSerializer serializer];
        [afHttpSessionMgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
        afHttpSessionMgr.requestSerializer.timeoutInterval = TimeOutIntervalSet;
//        [afHttpSessionMgr setSecurityPolicy:[self customSecurityPolicy]];
        
//        afHttpSessionMgr = [AFHTTPSessionManager manager];
//        //  JSON序列化
//        afHttpSessionMgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//        afHttpSessionMgr.requestSerializer.stringEncoding = NSUTF8StringEncoding;
//        afHttpSessionMgr.requestSerializer.timeoutInterval = TimeOutIntervalSet;
//        afHttpSessionMgr.responseSerializer = [AFJSONResponseSerializer serializer];
//        afHttpSessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[ @"application/json", @"text/html", @"text/json", @"text/javascript" ]];
    }
    
    return afHttpSessionMgr;
}
+ (AFSecurityPolicy *)customSecurityPolicy
{
    // 先导入证书，在这加证书，一般情况适用于单项认证
    // 证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];
    
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    if (cerData == nil) {
        return nil;
    }
    NSSet *setData = [NSSet setWithObject:cerData];
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // allowInvalidCertificates 是否允许无效证书(也就是自建的证书)，默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    // validatesDomainName 是否需要验证域名，默认为YES;
    // 假如证书的域名与你请求的域名不一致，需要把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    // 设置为NO，主要用于这种情况：客户端请求的事子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com,那么mail.google.com是无法验证通过的；当然有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    // 如设置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    [securityPolicy setPinnedCertificates:setData];
    
    return securityPolicy;
}

//取消所有的网络请求
+ (void)cancelAllRequest
{
    if (afHttpSessionMgr) {
        [afHttpSessionMgr.operationQueue cancelAllOperations];
    }
}

+ (BOOL)getProxyStatus {
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        //没有设置代理
        NSLog(@"没有设置代理");
        return NO;
    }else{
        //设置代理了
        NSLog(@"//设置代理了");
        return YES;
    }
}

+(void)saveWithURL:(NetRequestEnty *)requestEnty response:(id)res{
    if (requestEnty.params) {
        if ([requestEnty.params objectForKey:@"page"]) {
            NSArray *arr = [requestEnty.requestUrl componentsSeparatedByString:@"/"];
            [LPUserDefaults saveObject:res byFileName:[NSString stringWithFormat:@"%@%@",arr[arr.count-1],[requestEnty.params objectForKey:@"page"]]];
        }
    }else{
        NSArray *arr = [requestEnty.requestUrl componentsSeparatedByString:@"/"];
        [LPUserDefaults saveObject:res byFileName:arr[arr.count-1]];
    }
}
+(id)getWithURL:(NetRequestEnty *)requestEnty{
    if (requestEnty.params) {
        if ([requestEnty.params objectForKey:@"page"]) {
            NSArray *arr = [requestEnty.requestUrl componentsSeparatedByString:@"/"];
            return [LPUserDefaults getObjectByFileName:[NSString stringWithFormat:@"%@%@",arr[arr.count-1],[requestEnty.params objectForKey:@"page"]]];
        }else{
            NSArray *arr = [requestEnty.requestUrl componentsSeparatedByString:@"/"];
            return [LPUserDefaults getObjectByFileName:arr[arr.count-1]];
        }
    }else{
        NSArray *arr = [requestEnty.requestUrl componentsSeparatedByString:@"/"];
        return [LPUserDefaults getObjectByFileName:arr[arr.count-1]];
    }
}

//解编码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (void)HiddView
{
    //    [DSBeiAnimationLoading hideInView:[UIApplication sharedApplication].keyWindow];
    [DSBaActivityView hideActiviTy];
}



@end
