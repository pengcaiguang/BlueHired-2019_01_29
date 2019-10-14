//
//  LPReMoneyDrawModel.m
//  BlueHired
//
//  Created by iMac on 2019/8/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPReMoneyDrawModel.h"

@implementation LPReMoneyDrawModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"data": @"LPReMoneyDrawDataModel",
             };
}
@end

@implementation LPReMoneyDrawDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"reMoneyDetailsList": @"LPReMoneyDrawDataDetailsModel",
             };
}
@end

@implementation LPReMoneyDrawDataDetailsModel
@end
