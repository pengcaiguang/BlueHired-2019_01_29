//
//  LPInfoListModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPInfoListDataModel;
@interface LPInfoListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPInfoListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
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
@end

NS_ASSUME_NONNULL_END
