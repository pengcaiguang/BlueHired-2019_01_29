//
//  LPCommentListModel.m
//  BlueHired
//
//  Created by peng on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCommentListModel.h"

@implementation LPCommentListModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"data": @"LPCommentListDataModel",
             };
}
@end

@implementation LPCommentListDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"commentModelList": @"LPCommentListDataModel",
             };
}
@end

