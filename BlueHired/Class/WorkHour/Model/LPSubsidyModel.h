//
//  LPSubsidyModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPSubsidyDataModel;

@interface LPSubsidyModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) LPSubsidyDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPSubsidyDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *monthWageId;
@property (nonatomic, copy) NSString *subsidyType;
@property (nonatomic, copy) NSString *subsidyMoney;
@property (nonatomic, copy) NSString *subsidyDays;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
 

@end
NS_ASSUME_NONNULL_END
