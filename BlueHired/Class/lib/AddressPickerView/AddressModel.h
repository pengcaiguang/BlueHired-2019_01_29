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
@property (nonatomic, copy) NSArray <NSString *>*area;
@property (nonatomic, copy) NSArray <AddressModel *>*city;


@end

NS_ASSUME_NONNULL_END
