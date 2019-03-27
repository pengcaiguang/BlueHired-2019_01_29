//
//  LPAccountPriceModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPAccountPriceDataModel;

@interface LPAccountPriceModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) NSArray <LPAccountPriceDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPAccountPriceDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *accountPrice;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *conType;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@end
NS_ASSUME_NONNULL_END
