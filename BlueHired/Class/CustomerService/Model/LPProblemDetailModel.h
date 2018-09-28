//
//  LPProblemDetailModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPProblemDetailDataModel;
@interface LPProblemDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPProblemDetailDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPProblemDetailDataModel : NSObject

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *labelId;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, copy) NSString *labelUrl;
@property (nonatomic, copy) NSString *problemTitle;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
