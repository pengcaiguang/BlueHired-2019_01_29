//
//  LPLPEmployeeModel.h
//  BlueHired
//
//  Created by iMac on 2019/8/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPLPEmployeeDataModel;
@interface LPLPEmployeeModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPLPEmployeeDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPLPEmployeeDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *recStatus;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userUrl;
@end
NS_ASSUME_NONNULL_END
