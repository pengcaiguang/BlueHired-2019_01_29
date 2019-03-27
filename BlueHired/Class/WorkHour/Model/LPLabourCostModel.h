//
//  LPLabourCostModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPLabourCostDataModel;

@interface LPLabourCostModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) NSArray <LPLabourCostDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPLabourCostDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *priceName;
@property (nonatomic, copy) NSString *priceMoney;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;


@end
NS_ASSUME_NONNULL_END
