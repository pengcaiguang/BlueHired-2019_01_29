//
//  LPLabourCostEditVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabourCostModel.h"
#import "LPProListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPLabourCostEditVCBlock)(void);

@interface LPLabourCostEditVC : LPBaseViewController
@property (nonatomic, assign) NSInteger WorkHourType;
@property (nonatomic, strong) LPLabourCostDataModel *model;
@property (nonatomic, copy) LPLabourCostEditVCBlock Block;
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, strong) LPProListDataModel *Promodel;
@property(nonatomic,strong) NSMutableArray <LPProListDataModel *>*listArray;

@end

NS_ASSUME_NONNULL_END
