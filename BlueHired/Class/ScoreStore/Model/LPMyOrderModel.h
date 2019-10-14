//
//  LPMyOrderModel.h
//  BlueHired
//
//  Created by iMac on 2019/9/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPOrderGenerateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPMyOrderModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPOrderGenerateDataorderModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end



NS_ASSUME_NONNULL_END
