//
//  LPWorkOrderRemarkModel.h
//  BlueHired
//
//  Created by iMac on 2019/6/22.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class LPWorkOrderRemarkDataModel;
@class CustomerList;
@class WorkRemarkList;

@interface LPWorkOrderRemarkModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) LPWorkOrderRemarkDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPWorkOrderRemarkDataModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray <CustomerList *> *customerList;
@property (nonatomic, copy) NSArray <CustomerList *> *teacherList;
@property (nonatomic, copy) NSArray <WorkRemarkList *> *workRemarkList;

@end


@interface CustomerList : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *upIdentity;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *grading;
@end



@interface WorkRemarkList : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *workOrderId;
@property (nonatomic, copy) NSString *teacherId;
@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, copy) NSString *problemName;
@property (nonatomic, copy) NSString *problemAnswer;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
