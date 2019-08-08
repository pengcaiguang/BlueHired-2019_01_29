//
//  LPDrawalStateModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPDrawalStateDataModel;

@interface LPDrawalStateModel : NSObject
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankNum;
@property (nonatomic, strong) NSString *del_status;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSNumber *set_time;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *chargeMoney;

@end



NS_ASSUME_NONNULL_END
