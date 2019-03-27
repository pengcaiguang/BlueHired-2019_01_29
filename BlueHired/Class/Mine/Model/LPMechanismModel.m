//
//  LPMechanismModel.m
//  BlueHired
//
//  Created by iMac on 2019/3/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMechanismModel.h"

@implementation LPMechanismModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"data": @"LPMechanismDataModel",
             };
}
@end

@implementation LPMechanismDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"workTypeList": @"LPMechanismDataTypeListModel",
             };
}
@end

@implementation LPMechanismDataTypeListModel

@end
