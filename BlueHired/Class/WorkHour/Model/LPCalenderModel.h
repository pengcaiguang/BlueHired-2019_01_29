//
//  LPCalenderModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/11.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPCalenderDataModel;

@interface LPCalenderModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) LPCalenderDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPCalenderDataModel : NSObject

@end
NS_ASSUME_NONNULL_END
