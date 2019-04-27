//
//  LPRegisterDetailModel.m
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisterDetailModel.h"

@implementation LPRegisterDetailModel

@end

@implementation LPRegisterDetailDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"relationList": @"LPRegisterDetailDataListModel",
             };
}
@end

@implementation LPRegisterDetailDataListModel

@end
