//
//  NSTimer+block.h
//  BlueHired
//
//  Created by iMac on 2019/8/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (block)
+ (instancetype)repeatWithInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block;
@end

NS_ASSUME_NONNULL_END
