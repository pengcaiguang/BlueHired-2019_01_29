//
//  LPInfoDetailModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/18.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPInfoDetailModel : NSObject
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *informationTitle;
@property (nonatomic, copy) NSString *informationDetails;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *set_time;
@property (nonatomic, copy) NSNumber *unreadTotal;

@end



NS_ASSUME_NONNULL_END
