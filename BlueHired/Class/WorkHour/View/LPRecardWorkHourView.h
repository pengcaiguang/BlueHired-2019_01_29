//
//  LPRecardWorkHourView.h
//  BlueHired
//
//  Created by iMac on 2019/2/22.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOverTimeAccountModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPRecardWorkHourViewBlock)(NSInteger index);

@interface LPRecardWorkHourView : UIView
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic, copy) NSString *monthHours;
@property (nonatomic, strong)NSArray <LPOverTimeAccountDataRecordListModel *> *RecordModelList;
@property (nonatomic,copy) LPRecardWorkHourViewBlock block;
@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
