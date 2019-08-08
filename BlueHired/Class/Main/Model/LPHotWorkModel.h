//
//  LPHotWorkModel.h
//  BlueHired
//
//  Created by iMac on 2019/7/31.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPWorklistModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LPHotWorkDataModel;

@interface LPHotWorkModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPHotWorkDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPHotWorkDataModel : NSObject
@property (nonatomic, copy) NSString *activityTime;
@property (nonatomic, copy) NSString *workRange;
@property (nonatomic, copy) NSString *workMoney;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSArray <LPWorklistDataWorkListModel *> *hourWorkList;
@property (nonatomic, copy) NSArray <LPWorklistDataWorkListModel *> *fullWorkList;

@end



NS_ASSUME_NONNULL_END
