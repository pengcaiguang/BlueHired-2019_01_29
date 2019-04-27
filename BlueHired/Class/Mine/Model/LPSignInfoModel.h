//
//  LPSignInfoModel.h
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPSignInfoDataModel;

@interface LPSignInfoModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPSignInfoDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@class LPSignInfoDataListModel;
@interface LPSignInfoDataModel : NSObject
@property (nonatomic, copy) NSNumber *dayScore;
@property (nonatomic, copy) NSNumber *gainDayScore;
@property (nonatomic, copy) NSNumber *signNumber;
@property (nonatomic, copy) NSArray *signTimeList;
@end

NS_ASSUME_NONNULL_END
