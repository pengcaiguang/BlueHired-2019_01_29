//
//  LPCircleSearchVC.h
//  BlueHired
//
//  Created by iMac on 2018/12/11.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LPCircleSearchDelegate <NSObject>

- (void)LPCircleSearchBack:(AMapPOI *)poi;

@end
NS_ASSUME_NONNULL_BEGIN

@interface LPCircleSearchVC : LPBaseViewController
@property (nonatomic,assign)id <LPCircleSearchDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
