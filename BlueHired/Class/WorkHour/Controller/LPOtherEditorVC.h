//
//  LPOtherEditorVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMonthWageDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPOtherEditorVCBlock)(void);

@interface LPOtherEditorVC : LPBaseViewController
@property (nonatomic, strong)LPMonthWageDetailsModel *WageDetailsModel;
@property (nonatomic, assign) NSInteger ClassType;
@property (nonatomic, strong) NSString *KQDateString;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) LPOtherEditorVCBlock block;
@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
