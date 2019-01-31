//
//  LPentryModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LPentryDataModel;

@interface LPentryModel : UIView
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPentryDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPentryDataModel : NSObject

@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *interviewTime;
@property (nonatomic, copy) NSString *isEntry;
@property (nonatomic, copy) NSString *isReal;
@property (nonatomic, copy) NSString *mechanismId;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *postName;
@property (nonatomic, copy) NSString *postType;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *reTime;
@property (nonatomic, copy) NSString *recruitAddress;
@property (nonatomic, copy) NSString *recruitStatus;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *set_status;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *teacherList;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *upUserId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workName;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;


@end
NS_ASSUME_NONNULL_END
