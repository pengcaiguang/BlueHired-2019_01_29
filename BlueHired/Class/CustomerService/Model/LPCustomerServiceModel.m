//
//  LPCustomerServiceModel.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCustomerServiceModel.h"

@implementation LPCustomerServiceModel

@end

@implementation LPCustomerServiceDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"list": @"LPCustomerServiceDataListModel",
             };
}
@end

@implementation LPCustomerServiceDataListModel

@end
