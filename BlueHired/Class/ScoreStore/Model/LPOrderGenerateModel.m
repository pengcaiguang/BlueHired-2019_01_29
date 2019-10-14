//
//  LPOrderGenerateModel.m
//  BlueHired
//
//  Created by iMac on 2019/9/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPOrderGenerateModel.h"

@implementation LPOrderGenerateModel

@end

@implementation LPOrderGenerateDataModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"orderItemList": @"LPOrderGenerateDataItemModel",
             };
}
@end

@implementation LPOrderGenerateDataItemModel

@end

@implementation LPOrderGenerateDataorderModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"orderItemList": @"LPOrderGenerateDataItemModel",
             };
}
@end
