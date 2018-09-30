//
//  LPBillrecordModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPBillrecordDataModel;
@interface LPBillrecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPBillrecordDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPBillrecordDataModel : NSObject

@end

NS_ASSUME_NONNULL_END
