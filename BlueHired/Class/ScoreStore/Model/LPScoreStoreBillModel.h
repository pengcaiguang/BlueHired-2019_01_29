//
//  LPScoreStoreBillModel.h
//  BlueHired
//
//  Created by iMac on 2019/9/30.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPScoreStoreBillDataModel;

@interface LPScoreStoreBillModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPScoreStoreBillDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPScoreStoreBillDataModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
 


@end



NS_ASSUME_NONNULL_END
