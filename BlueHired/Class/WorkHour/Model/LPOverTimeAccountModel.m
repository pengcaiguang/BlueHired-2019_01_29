//
//  LPOverTimeAccountModel.m
//  BlueHired
//
//  Created by iMac on 2019/3/4.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPOverTimeAccountModel.h"

@implementation LPOverTimeAccountModel

@end
@implementation LPOverTimeAccountDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"overtimeRecordList": @"LPOverTimeAccountDataRecordListModel",
             @"accountList": @"LPOverTimeAccountDataaccountListModel",
             };
}
@end
@implementation LPOverTimeAccountDataRecordListModel

@end
@implementation LPOverTimeAccountDataaccountListModel

@end
