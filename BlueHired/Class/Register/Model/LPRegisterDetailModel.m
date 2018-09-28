//
//  LPRegisterDetailModel.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
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
