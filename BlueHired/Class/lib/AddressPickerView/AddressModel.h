//
//  AddressModel.h
//  BlueHired
//
//  Created by iMac on 2019/1/3.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cities;
@property (nonatomic, copy) NSArray *msg;

@end

NS_ASSUME_NONNULL_END
