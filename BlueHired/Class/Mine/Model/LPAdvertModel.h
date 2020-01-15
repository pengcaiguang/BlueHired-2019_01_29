//
//  LPAdvertModel.h
//  BlueHired
//
//  Created by iMac on 2019/1/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPAdvertDataModel;

@interface LPAdvertModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPAdvertDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPAdvertDataModel : NSObject
@property (nonatomic, copy) NSString *activityBeginTime;
@property (nonatomic, copy) NSString *activityDetails;
@property (nonatomic, copy) NSString *activityEndTime;
@property (nonatomic, copy) NSString *activityImage;
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *activityUrl;
@property (nonatomic, copy) NSString *countDownTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *userList;

@end
NS_ASSUME_NONNULL_END
