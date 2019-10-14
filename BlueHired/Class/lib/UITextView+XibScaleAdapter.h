//
//  UITextView+XibScaleAdapter.h
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/21.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (XibScaleAdapter)
@property(nonatomic, assign) IBInspectable BOOL adapterScreen;

@end

NS_ASSUME_NONNULL_END
