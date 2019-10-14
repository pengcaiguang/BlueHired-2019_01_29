//
//  LPOrderAddressModel.h
//  BlueHired
//
//  Created by iMac on 2019/9/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPOrderAddressDataModel;

@interface LPOrderAddressModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPOrderAddressDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPOrderAddressDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *detailAddress;
@property (nonatomic, copy) NSString *sendStatus;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
 

@end

NS_ASSUME_NONNULL_END
