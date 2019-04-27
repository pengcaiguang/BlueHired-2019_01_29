//
//  GJAlertText.h
//  BlueHired
//
//  Created by peng on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AlertTextBlock)(NSInteger index , NSString *string);
@interface GJAlertText : NSObject
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsColor:(NSArray *)buttonColors MaxLength:(NSInteger)Length NilTitel:(NSString *)NilTitel buttonClick:(void(^)(NSInteger buttonIndex , NSString * string))block;
- (void)show;
- (void)dismiss;

@end
