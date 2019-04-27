//
//  LPMoodListModel.h
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMoodListDataModel;
@class LPMoodCommentListDataModel;
@class LPMoodPraiseListDataModel;

@interface LPMoodListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPMoodListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPMoodListDataModel : NSObject

@property(nonatomic,copy) NSString *chioceStatus;
@property(nonatomic,copy) NSNumber *commentTotal;
@property(nonatomic,copy) NSNumber *delStatus;
@property(nonatomic,copy) NSString *grading;
@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSString *isCollection;
@property(nonatomic,copy) NSNumber *isConcern;
@property(nonatomic,copy) NSNumber *isPraise;
@property(nonatomic,copy) NSString *mechanismId;
@property(nonatomic,copy) NSString *moodDetails;
@property(nonatomic,copy) NSString *moodName;
@property(nonatomic,copy) NSNumber *moodTypeId;
@property(nonatomic,copy) NSString *moodUrl;
@property(nonatomic,copy) NSNumber *praiseTotal;
@property(nonatomic,copy) NSNumber *score;
@property(nonatomic,copy) NSNumber *setTime;
@property(nonatomic,copy) NSNumber *time;
@property(nonatomic,copy) NSNumber *userId;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *userUrl;
@property(nonatomic,copy) NSNumber *view;
@property(nonatomic,copy) NSString *identity;
@property(nonatomic,copy) NSString *address;
@property (nonatomic, strong) NSMutableArray <LPMoodCommentListDataModel *> *commentModelList;
@property (nonatomic, strong) NSMutableArray <LPMoodPraiseListDataModel *> *praiseList;
@property (nonatomic, assign) BOOL isOpening;           //是否label全部展示

@end

@interface LPMoodCommentListDataModel : NSObject
@property(nonatomic,copy) NSString *commentDetails;
@property(nonatomic,copy) NSString *commentId;
@property(nonatomic,copy) NSString *commentList;
@property(nonatomic,copy) NSString *commentType;
@property(nonatomic,copy) NSString *grading;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *identity;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *toUserId;
@property(nonatomic,copy) NSString *toUserIdentity;
@property(nonatomic,copy) NSString *toUserName;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *userUrl;

@end

@interface LPMoodPraiseListDataModel : NSObject
@property(nonatomic,copy) NSString *grading;
@property(nonatomic,copy) NSString *identity;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *role;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *upIdentity;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *userImage;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *workStatus;

@end
