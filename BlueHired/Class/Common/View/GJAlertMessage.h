//
//  GJAlertMessage.h
//  BlueHired
//
//  Created by peng on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AlertMessageBlock)(NSInteger index);
@interface GJAlertMessage : NSObject
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
      textAlignment:(NSTextAlignment)textAlignment
       buttonTitles:(NSArray *)buttonTitles
       buttonsColor:(NSArray *)buttonColors
buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors
        buttonClick:(void(^)(NSInteger buttonIndex))block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        backDismiss:(BOOL) Dis
      textAlignment:(NSTextAlignment)textAlignment
       buttonTitles:(NSArray *)buttonTitles
       buttonsColor:(NSArray *)buttonColors
buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors
        buttonClick:(void(^)(NSInteger buttonIndex))block;

- (id)initWithTitle:(NSMutableAttributedString *)title
            message:(NSString *)message
        IsShowhead:(BOOL) Dis
      textAlignment:(NSTextAlignment)textAlignment
       buttonTitles:(NSArray *)buttonTitles
       buttonsColor:(NSArray *)buttonColors
buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors
        buttonClick:(void(^)(NSInteger buttonIndex))block;

- (id)initWithTitle:(NSMutableAttributedString *)title
            message:(NSString *)message
         IsShowhead:(BOOL) Dis
        backDismiss:(BOOL) backDis
      textAlignment:(NSTextAlignment)textAlignment
       buttonTitles:(NSArray *)buttonTitles
       buttonsColor:(NSArray *)buttonColors
buttonsBackgroundColors:(NSArray *)buttonsBackgroundColors
        buttonClick:(void(^)(NSInteger buttonIndex))block;

- (void)show;
- (void)dismiss;

@end
