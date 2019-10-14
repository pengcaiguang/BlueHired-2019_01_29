//
//  LPUserBillRecordModel.h
//  BlueHired
//
//  Created by iMac on 2019/10/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPUserBillRecordDataModel;

@interface LPUserBillRecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSArray <LPUserBillRecordDataModel *>*data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPUserBillRecordDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userName;


@end
NS_ASSUME_NONNULL_END
