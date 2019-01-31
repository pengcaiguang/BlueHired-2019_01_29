//
//  NetRequestManager.h
//  RedPacket
//
//  Created by 邢晓亮 on 2018/6/8.
//  Copyright © 2018年 邢晓亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestEnty.h"
#import "NetInstance.h"

@interface NetRequestManager : NSObject
+ (void) requestWithEnty:(NetRequestEnty *)requestEnty;

//取消所有的网络请求
+ (void)cancelAllRequest;

//解编码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
