//
//  LPProListModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPProListDataModel;

@interface LPProListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) NSArray <LPProListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPProListDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPrice;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;


@end
NS_ASSUME_NONNULL_END
