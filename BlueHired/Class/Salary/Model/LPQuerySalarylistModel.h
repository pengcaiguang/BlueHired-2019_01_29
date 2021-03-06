//
//  LPQuerySalarylistModel.h
//  BlueHired
//
//  Created by peng on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPQuerySalarylistDataModel;
@interface LPQuerySalarylistModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSMutableArray <LPQuerySalarylistDataModel *>*data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPQuerySalarylistDataModel : NSObject
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *salaryDetails;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *actualPay;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;

@end
