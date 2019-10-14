//
//  LPProductListModel.m
//  BlueHired
//
//  Created by iMac on 2019/9/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPProductListModel.h"

@implementation LPProductListModel

@end

@implementation LPProductListListModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"list": @"LPProductListDataModel",
             @"slideList": @"LPProductListDataModel",
             };
}
@end

@implementation LPProductListDataModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}
@end
