//
//  LPUserProblemModel.h
//  BlueHired
//
//  Created by iMac on 2019/4/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPUserProblemDataModel;

@interface LPUserProblemModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPUserProblemDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPUserProblemDataModel : NSObject
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *problemAnswer;
@property (nonatomic, copy) NSString *problemName;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *userId;

@end
NS_ASSUME_NONNULL_END
