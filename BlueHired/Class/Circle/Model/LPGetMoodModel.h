//
//  LPGetMoodModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/18.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPGetMoodDataModel;
@interface LPGetMoodModel : NSObject

@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPGetMoodDataModel *data;
@property (nonatomic, copy) NSString *msg;

@end

@interface LPGetMoodDataModel : NSObject

@property (nonatomic, copy) NSNumber *chioceStatus;
@property (nonatomic, copy) NSNumber *commentTotal;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *isCollection;
@property (nonatomic, copy) NSNumber *isConcern;
@property (nonatomic, copy) NSNumber *isPraise;
@property (nonatomic, copy) NSNumber *mechanismId;
@property (nonatomic, copy) NSString *moodDetails;
@property (nonatomic, copy) NSString *moodName;
@property (nonatomic, copy) NSNumber *moodTypeId;
@property (nonatomic, copy) NSString *moodUrl;
@property (nonatomic, copy) NSNumber *praiseTotal;
@property (nonatomic, copy) NSNumber *score;
@property (nonatomic, copy) NSNumber *setTime;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSNumber *view;

@end
