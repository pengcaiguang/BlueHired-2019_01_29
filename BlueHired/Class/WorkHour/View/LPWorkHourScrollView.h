//
//  LPWorkHourScrollView.h
//  BlueHired
//
//  Created by iMac on 2019/2/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPWorkHourScrollView : UIView
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString *KQDateString;
@property (nonatomic, assign) NSInteger WorkHourType;
@end

NS_ASSUME_NONNULL_END
