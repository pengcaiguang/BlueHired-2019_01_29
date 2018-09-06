//
//  NetInstance.m
//  RedPacket
//
//  Created by 邢晓亮 on 2018/6/8.
//  Copyright © 2018年 邢晓亮. All rights reserved.
//

#import "NetInstance.h"

static NetInstance * singleInstance = nil;

@implementation NetInstance

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [[NetInstance alloc] init];
    });
    return singleInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baseUrl = BaseRequestURL;
    }
    return self;
}

//网络请求基础配置
- (NetRequestEnty *) commonRequestEnty:(RequestType)requestType
                   withAppendUrlString:(NSString *)appendURLString
{
    NetRequestEnty * enty = [[NetRequestEnty alloc] init];
    enty.requestUrl = kStringIsEmpty(appendURLString) ? self.baseUrl : [NSString stringWithFormat:@"%@%@",self.baseUrl,appendURLString];
    switch (requestType) {
        case RequestTypeGet:   //GET请求
            enty.requestType = 0;
            break;
        case RequestTypePost:  //POST请求
            enty.requestType = 1;
            break;
        case RequestTypeUploadSingleImage: //单张图片上传
            enty.requestType = 2;
            break;
        case RequestTypeUploadImagesArray: //多张图片上传
            enty.requestType = 3;
            break;
        default:
            enty.requestType = 1; //默认为POST
            break;
    }
    return enty;
}

//公共基础参数
- (NSMutableDictionary *)basicParameter
{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 //kVersionNo,@"version",
//                                 nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if (AlreadyLogin) {
//        [dict setObject:kUserDefaultsValue(kLoginToken) forKey:@"token"];
    }
    NSLog(@"dict == 基础参数 == %@",dict);
    return dict;
}
@end
