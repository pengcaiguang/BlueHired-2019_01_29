//
//  LPScoreStoreDetalisModel.m
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStoreDetalisModel.h"

@implementation LPScoreStoreDetalisModel

@end

@implementation LPScoreStoreDetalisDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"mProductSkuList": @"ProductSkuListModel",
             };
}
+(NSDictionary *)replacedKeyFromPropertyName{

    return @{@"Description":@"description"};

}
@end

@implementation ProductSkuListModel


@end
