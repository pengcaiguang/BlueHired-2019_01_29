//
//  GJAlertPassword.h
//  BlueHired
//
//  Created by peng on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GJAlertPasswordBlock)(NSInteger index , NSString *string);
@interface GJAlertPassword : NSObject
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors buttonClick:(void(^)(NSInteger buttonIndex , NSString * string))block;
- (void)show;
- (void)dismiss;
@end

