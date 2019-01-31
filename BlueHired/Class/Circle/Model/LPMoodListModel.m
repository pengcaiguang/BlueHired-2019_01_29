//
//  LPMoodListModel.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMoodListModel.h"

@implementation LPMoodListModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"data": @"LPMoodListDataModel",
             };
}
@end


@implementation LPMoodListDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"commentModelList": @"LPMoodCommentListDataModel",
             @"praiseList": @"LPMoodPraiseListDataModel",
             };
}

@end

@implementation LPMoodCommentListDataModel

@end

@implementation LPMoodPraiseListDataModel

@end
