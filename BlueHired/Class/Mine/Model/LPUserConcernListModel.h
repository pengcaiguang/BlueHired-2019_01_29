//
//  LPUserConcernListModel.h
//  BlueHired
//
//  Created by iMac on 2019/6/11.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPUserConcernListDataModel;

@interface LPUserConcernListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPUserConcernListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPUserConcernListDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *concernUserId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *focusStatus;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *nickName;

@end
NS_ASSUME_NONNULL_END
