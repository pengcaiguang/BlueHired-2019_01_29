//
//  UILabel+XibScaleAdapter.h
//  BlueHired
//
//  Created by iMac on 2019/5/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XibScaleAdapter)
@property(nonatomic, assign) IBInspectable BOOL adapterScreen;

@end

NS_ASSUME_NONNULL_END
