//
//  GJAlertWithDrawPassword.h
//  BlueHired
//
//  Created by iMac on 2019/1/24.
//  Copyright © 2019 lanpin. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^GJAlertPasswordBlock)(NSInteger index , NSString *string);

@interface GJAlertWithDrawPassword : NSObject

- (id)initWithTitle:(NSMutableAttributedString *)title
            message:(NSString *)message
       buttonTitles:(NSArray *)buttonTitles
       buttonsColor:(NSArray *)buttonColors
        buttonClick:(void(^)(NSInteger buttonIndex , NSString * string))block;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
