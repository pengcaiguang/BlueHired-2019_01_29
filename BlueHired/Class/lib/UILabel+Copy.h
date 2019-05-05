//
//  UILabel+Copy.h
//  BlueHired
//
//  Created by iMac on 2019/4/1.
//  Copyright © 2019 lanpin. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPUILabelDeleteBlock)(UILabel *label);

typedef void(^LPUILabelTouchBlock)(void);

@interface UILabel (Copy)

@property (nonatomic, assign) BOOL copyable;
@property (nonatomic, assign) BOOL Deleteable;

@property (nonatomic,copy) LPUILabelDeleteBlock DeleteBlock;
@property (nonatomic,copy) LPUILabelDeleteBlock CopyBlock;

@property (nonatomic,copy) LPUILabelTouchBlock TouchBlock;

@end

NS_ASSUME_NONNULL_END
