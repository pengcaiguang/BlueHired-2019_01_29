//
//  LPWorkRecordModel.h
//  BlueHired
//
//  Created by iMac on 2019/10/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPWorkRecordDataModel;

@interface LPWorkRecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPWorkRecordDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPWorkRecordDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *time;

@end


NS_ASSUME_NONNULL_END
