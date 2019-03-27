//
//  LPMechanismModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPMechanismDataModel;
@class LPMechanismDataTypeListModel;

@interface LPMechanismModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPMechanismDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPMechanismDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismTypeName;
@property (nonatomic, copy) NSArray <LPMechanismDataTypeListModel *> *workTypeList;

@end

@interface LPMechanismDataTypeListModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismTypeId;
@property (nonatomic, copy) NSString *workTypeName;

@end
NS_ASSUME_NONNULL_END
