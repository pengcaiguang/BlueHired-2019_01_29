//
//  LPRegisterDetailModel.h
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>



@class LPRegisterDetailDataModel;
@interface LPRegisterDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPRegisterDetailDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@class LPRegisterDetailDataListModel;
@interface LPRegisterDetailDataModel : NSObject
@property(nonatomic,copy) NSNumber *remainderMoney;
@property(nonatomic,copy) NSNumber *totalMoney;
@property(nonatomic,copy) NSArray <LPRegisterDetailDataListModel *> *relationList;
@end

@interface LPRegisterDetailDataListModel : NSObject

@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *relationMoney;
@property (nonatomic, copy) NSString *relationMoneyTime;
@property (nonatomic, copy) NSNumber *setTime;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSNumber *upUserId;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *status;

@end
