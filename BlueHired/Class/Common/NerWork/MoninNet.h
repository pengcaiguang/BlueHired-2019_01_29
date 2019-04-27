//
//  MoninNet.h
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoninNet : NSObject
- (void)startMoninNet;
- (void)stopMoninNet;

//获取当前使用的网络状态
- (AFNetworkReachabilityStatus)getNetState;

@end
