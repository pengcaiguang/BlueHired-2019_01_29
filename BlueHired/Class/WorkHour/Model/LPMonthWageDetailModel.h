//
//  LPMonthWageDetailModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPMonthWageDetailDataModel;
@interface LPMonthWageDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) LPMonthWageDetailDataModel  *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPMonthWageDetailDataModel : NSObject
@property(nonatomic,copy) NSString *hours;
@property(nonatomic,copy) NSString *overtimeDay;
@property(nonatomic,copy) NSString *salary;
//@property(nonatomic,copy) NSString *salary;
//@property(nonatomic,copy) NSString *salary;
//@property(nonatomic,copy) NSString *salary;
//@property(nonatomic,copy) NSString *salary;

@end
NS_ASSUME_NONNULL_END
