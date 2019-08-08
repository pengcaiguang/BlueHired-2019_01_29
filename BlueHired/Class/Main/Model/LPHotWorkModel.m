//
//  LPHotWorkModel.m
//  BlueHired
//
//  Created by iMac on 2019/7/31.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHotWorkModel.h"

@implementation LPHotWorkModel

@end
@implementation LPHotWorkDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"hourWorkList": @"LPWorklistDataWorkListModel",
             @"fullWorkList": @"LPWorklistDataWorkListModel"
             };
}
@end
