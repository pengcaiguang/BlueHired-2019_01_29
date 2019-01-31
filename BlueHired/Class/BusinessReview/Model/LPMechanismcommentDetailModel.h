//
//  LPMechanismcommentDetailModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMechanismcommentDetailDataModel;
@interface LPMechanismcommentDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPMechanismcommentDetailDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPMechanismcommentDetailDataModel : NSObject
@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic, copy) NSString *commentUrl;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *foodEnvironScore;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *manageEnvironScore;
@property (nonatomic, copy) NSString *mechanismId;
@property (nonatomic, copy) NSNumber *moneyEnvironScore;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSNumber *sleepEnvironScore;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSNumber *workEnvironScore;

@property (nonatomic,assign) BOOL IsAllShow;
@end
