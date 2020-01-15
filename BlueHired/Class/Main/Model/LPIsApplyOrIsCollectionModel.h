//
//  LPIsApplyOrIsCollectionModel.h
//  BlueHired
//
//  Created by peng on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPIsApplyOrIsCollectionDataModel;
@class teacher;

@interface LPIsApplyOrIsCollectionModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPIsApplyOrIsCollectionDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPIsApplyOrIsCollectionDataModel : NSObject
@property (nonatomic, copy) NSNumber *isApply;
@property (nonatomic, copy) NSNumber *isCollection;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *isRealname;
@property (nonatomic, strong) teacher *teacher;

@end

@interface teacher : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, copy) NSString *teacherTel;

@end
