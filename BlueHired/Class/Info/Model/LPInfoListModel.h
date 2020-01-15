//
//  LPInfoListModel.h
//  BlueHired
//
//  Created by peng on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPInfoListDataModel;
@class LPInfoListDataListModel;

@interface LPInfoListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPInfoListDataListModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPInfoListDataListModel : NSObject
@property (nonatomic, copy) NSString *moodInfoNum;
@property (nonatomic, copy) NSString *workInfoNum;
@property (nonatomic, copy) NSArray <LPInfoListDataModel *> *list;

@end

@interface LPInfoListDataModel : NSObject
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *informationDetails;
@property (nonatomic, copy) NSString *informationTitle;
@property (nonatomic, copy) NSNumber *moodId;
@property (nonatomic, copy) NSNumber *sendUserId;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSNumber *unreadTotal;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *moodUrl;
@property (nonatomic, copy) NSString *moodDetails;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *infoContent;
@property (nonatomic, copy) NSString *upIdentity;
@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *workTitle;
@property (nonatomic, copy) NSString *maxNumber;
@property (nonatomic, copy) NSString *postType;

@end

NS_ASSUME_NONNULL_END
