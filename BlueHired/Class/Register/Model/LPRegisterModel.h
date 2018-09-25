//
//  LPRegisterModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
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

@property(nonatomic,copy) NSNumber *BUserNum; //直接邀请
@property(nonatomic,copy) NSNumber *CUserNum;//间接邀请
@property(nonatomic,copy) NSNumber *fullMonthNum;//注册已到账人数
@property(nonatomic,copy) NSNumber *sumNum;//注册总人数

@end

