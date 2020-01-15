//
//  LPRecreationModel.m
//  BlueHired
//
//  Created by iMac on 2019/11/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRecreationModel.h"

@implementation LPRecreationModel

@end

@implementation LPRecreationDataModel

+ (NSDictionary *)objectClassInArray {
    return @{
             @"videoList": @"LPRecreationVideoListModel",
             @"essayList": @"LPRecreationEssayListModel",
             };
}

@end

@implementation LPRecreationVideoListModel

@end

@implementation LPRecreationEssayListModel

@end
