//
//  LPProRecirdModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/16.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPProRecirdDataModel;

@interface LPProRecirdModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) NSArray <LPProRecirdDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPProRecirdDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productNum;
@property (nonatomic, copy) NSString *productPrice;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *userId;


@end
NS_ASSUME_NONNULL_END
