//
//  GJAlertMessage.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AlertMessageBlock)(NSInteger index);
@interface GJAlertMessage : NSObject
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonClick:(void(^)(NSInteger buttonIndex))block;
- (void)show;
- (void)dismiss;

@end
