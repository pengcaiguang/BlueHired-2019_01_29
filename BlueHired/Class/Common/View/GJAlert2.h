//
//  GJAlert.h
//  GJPersonal
//
//  Created by zab on 16/1/15.
//  Copyright © 2016年 xinyi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AlertBlock)(NSInteger index);
@interface GJAlert2 : NSObject
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonClick:(void(^)(NSInteger buttonIndex))block;
- (void)show;
- (void)dismiss;
@end
