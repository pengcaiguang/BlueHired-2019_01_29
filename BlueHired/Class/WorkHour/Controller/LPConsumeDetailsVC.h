//
//  LPConsumeDetailsVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOverTimeAccountModel.h"

typedef void(^LPConsumeDetailsVCBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface LPConsumeDetailsVC : LPBaseViewController
@property (nonatomic,strong) LPOverTimeAccountDataaccountListModel *model;
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic,copy) LPConsumeDetailsVCBlock block;
@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
