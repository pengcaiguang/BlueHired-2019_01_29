//
//  NetInstance.h
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestEnty.h"

typedef NS_ENUM(NSInteger,RequestType) {
    RequestTypeGet = 1,
    RequestTypePost,
    RequestTypeUploadSingleImage,
    RequestTypeUploadImagesArray
};

@interface NetInstance : NSObject

@property (nonatomic,strong) NSString * baseUrl;

+ (instancetype) shareInstance;

//网络请求基础配置
- (NetRequestEnty *) commonRequestEnty:(RequestType)requestType
                   withAppendUrlString:(NSString *)appendURLString;
//公共基础参数
- (NSMutableDictionary *)basicParameter;
@end
