//
//  LPVideoSortAlertView.h
//  BlueHired
//
//  Created by iMac on 2018/11/16.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LPVideoSortAlertViewDelegate<NSObject>

-(void)touchTableView:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LPVideoSortAlertView : UIView

@property (nonatomic,assign)id <LPVideoSortAlertViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
