//
//  MoninNet.m
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import "MoninNet.h"
@interface MoninNet()

@property(nonatomic,strong)AFNetworkReachabilityManager* net;

@end

@implementation MoninNet
- (id)init
{
    self = [super init];
    if( self )
    {
        _net = [AFNetworkReachabilityManager sharedManager];
    }
    
    return self;
}

- (void)dealloc
{
    _net = nil;
}

- (void)startMoninNet
{
    __weak typeof(self)weakSelf = self;
    
    [_net setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"当前网络环境");
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                NSLog(@"unKnow");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"StatusNotReachable");
                [weakSelf postNetworkReachabilityStatusNotReachableNotification];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"ReachableViaWWAN");
                [weakSelf postNetworkReachabilityStatusReachableNotification];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"ReachableViaWiFi");
                [weakSelf postNetworkReachabilityStatusReachableNotification];
            }
                break;
                
            default:
                break;
        }
    }];
    [_net startMonitoring];
}


- (void)postNetworkReachabilityStatusNotReachableNotification //发送无网络状态通知
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:DLCNetworkReachabilityStatusNotReachable object:nil];
}

-(void)postNetworkReachabilityStatusReachableNotification    //发送有网络状态通知
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:DLCNetworkReachabilityStatusReachable object:nil];
}


- (void)stopMoninNet
{
    [_net stopMonitoring];
}

- (AFNetworkReachabilityStatus)getNetState
{
    return _net.networkReachabilityStatus;
}
@end
