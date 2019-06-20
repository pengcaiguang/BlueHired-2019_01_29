//
//  LPRegisterModel.h
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPRegisterDataModel;

@interface LPRegisterModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPRegisterDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPRegisterDataModel : NSObject

@property(nonatomic,copy) NSString *totalMoney;
@property(nonatomic,copy) NSString *regMoney;
@property(nonatomic,copy) NSString *BUserNum;
@property(nonatomic,copy) NSString *CUserNum;
@property(nonatomic,copy) NSString *bUserMoney;
@property(nonatomic,copy) NSString *cUserMoney;
@property(nonatomic,copy) NSString *fullMonthNum;
@property(nonatomic,copy) NSString *sumNum;
@property(nonatomic,copy) NSString *regUserMoney;
@property(nonatomic,copy) NSString *remark;

@end

