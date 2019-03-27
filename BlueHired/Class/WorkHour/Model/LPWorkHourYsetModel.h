//
//  LPWorkHourYsetModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPWorkHourYsetDataModel;

@interface LPWorkHourYsetModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) LPWorkHourYsetDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPWorkHourYsetDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *workDay;
@property (nonatomic, copy) NSString *workDayTime;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *overtimeMul;
@property (nonatomic, copy) NSString *weekendMul;

@end
NS_ASSUME_NONNULL_END
