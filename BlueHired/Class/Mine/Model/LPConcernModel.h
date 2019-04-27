//
//  LPConcernModel.h
//  BlueHired
//
//  Created by iMac on 2019/4/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPConcernDataModel;

@interface LPConcernModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPConcernDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPConcernDataModel : NSObject
@property (nonatomic, copy) NSString *concernUserId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *focusStatus;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, assign) BOOL isDelete;

@end

NS_ASSUME_NONNULL_END
