//
//  LPStoreShareModel.m
//  BlueHired
//
//  Created by iMac on 2019/10/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPStoreShareModel.h"

@implementation LPStoreShareModel
+ (NSDictionary *)objectClassInArray{
    return @{
            @"data": @"LPStoreShareDataModel"
            };
}
@end

@implementation LPStoreShareDataModel
+ (NSDictionary *)objectClassInArray{
    return @{
            @"mProductSkuList": @"ProductSkuListModel",
            @"shareUserList": @"LPStoreShareDataUserModel"
            };
}
@end

@implementation LPStoreShareDataUserModel



@end
