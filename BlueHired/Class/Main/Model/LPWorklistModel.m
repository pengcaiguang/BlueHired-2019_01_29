//
//  LPWorklistModel.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
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
             };
}
@end


@implementation LPWorklistDataSlideshowListModel

@end


@implementation LPWorklistDataWorkListModel

@end




