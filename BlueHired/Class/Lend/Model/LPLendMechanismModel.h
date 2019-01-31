//
//  LPLendMechanismModel.h
//  BlueHired
//
//  Created by iMac on 2018/12/13.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPLendMechanismDataModel;

@interface LPLendMechanismModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPLendMechanismDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPLendMechanismDataModel : NSObject

@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageList;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *lendType;
@property (nonatomic, copy) NSString *mechanismAddress;
@property (nonatomic, copy) NSString *mechanismDetails;
@property (nonatomic, copy) NSString *mechanismLogo;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *mechanismScore;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;

@end
NS_ASSUME_NONNULL_END
