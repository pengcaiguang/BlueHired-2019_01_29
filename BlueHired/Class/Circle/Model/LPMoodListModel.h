//
//  LPMoodListModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMoodListDataModel;
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

@end
