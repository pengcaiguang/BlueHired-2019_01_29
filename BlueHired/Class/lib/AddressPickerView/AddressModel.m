//
//  AddressModel.m
//  BlueHired
//
//  Created by iMac on 2019/1/3.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"area": @"NSString",
             @"city": @"AddressModel",
             };
}
@end
