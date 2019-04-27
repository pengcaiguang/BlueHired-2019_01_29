//
//  LPWorklistModel.m
//  BlueHired
//
//  Created by peng on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorklistModel.h"

@implementation LPWorklistModel

@end

@implementation LPWorklistDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"slideshowList": @"LPWorklistDataSlideshowListModel",
             @"workList": @"LPWorklistDataWorkListModel",
             @"workBarsList": @"LPWorklistDataWorkBarsListModel",

             };
}
@end


@implementation LPWorklistDataSlideshowListModel

@end


@implementation LPWorklistDataWorkListModel

@end


@implementation LPWorklistDataWorkBarsListModel

@end


