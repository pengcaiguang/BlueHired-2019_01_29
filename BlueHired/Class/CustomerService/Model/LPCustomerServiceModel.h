//
//  LPCustomerServiceModel.h
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPCustomerServiceDataModel;
@interface LPCustomerServiceModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPCustomerServiceDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@class LPCustomerServiceDataListModel;
@interface LPCustomerServiceDataModel : NSObject
@property (nonatomic, copy) NSArray <LPCustomerServiceDataListModel *> *list;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *token;            // 环信token
@property (nonatomic, copy) NSString *imUserName;       //环信id
@property (nonatomic, copy) NSString *imPassword;       //环信用户密码
@property (nonatomic, copy) NSString *workTime;       //客服时间


    

@end


@interface LPCustomerServiceDataListModel : NSObject

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *labelId;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, copy) NSString *labelUrl;
@property (nonatomic, copy) NSString *problemTitle;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *time;

@end
NS_ASSUME_NONNULL_END
