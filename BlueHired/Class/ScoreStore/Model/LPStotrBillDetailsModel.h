//
//  LPStotrBillDetailsModel.h
//  BlueHired
//
//  Created by iMac on 2019/10/9.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPOrderGenerateModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface LPStotrBillDetailsModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPOrderGenerateDataorderModel *data;
@property (nonatomic, copy) NSString *msg;
@end
 

NS_ASSUME_NONNULL_END
