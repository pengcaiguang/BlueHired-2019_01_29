//
//  LPBillRecordStateVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPBillrecordModel.h"
#import "LPDrawalStateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPBillRecordStateVC : LPBaseViewController
@property (nonatomic,strong) LPBillrecordDataModel *model;
@property (nonatomic,strong) LPDrawalStateModel *modelstate;

@end

NS_ASSUME_NONNULL_END
