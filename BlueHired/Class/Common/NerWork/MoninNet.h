//
//  MoninNet.h
//  RedPacket
//
//  Created by 邢晓亮 on 2018/6/8.
//  Copyright © 2018年 邢晓亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoninNet : NSObject
- (void)startMoninNet;
- (void)stopMoninNet;

//获取当前使用的网络状态
- (AFNetworkReachabilityStatus)getNetState;

@end
