//
//  LPMonthHoursModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPMonthHoursDataModel;

@interface LPMonthHoursModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) LPMonthHoursDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPMonthHoursDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *workHours;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *period;


@end
NS_ASSUME_NONNULL_END
