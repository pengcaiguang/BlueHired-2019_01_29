//
//  NSTimer+block.m
//  BlueHired
//
//  Created by iMac on 2019/8/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "NSTimer+block.h"

@implementation NSTimer (block)
+ (instancetype)repeatWithInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(trigger:) userInfo:[block copy] repeats:YES];
    return timer;
}

+ (void)trigger:(NSTimer *)timer {
    void(^block)(NSTimer *timer) = [timer userInfo];
    if (block) {
        block(timer);
    }
}
@end
