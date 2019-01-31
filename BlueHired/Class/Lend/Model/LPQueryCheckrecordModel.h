//
//  LPQueryCheckrecordModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPQueryCheckrecordDataModel;
@interface LPQueryCheckrecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPQueryCheckrecordDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPQueryCheckrecordDataModel : NSObject
@property (nonatomic, copy) NSNumber *checkUserId;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *lendMoney;
@property (nonatomic, copy) NSNumber *mechanismId;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSNumber *set_time;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSNumber *userId;
@end
NS_ASSUME_NONNULL_END
