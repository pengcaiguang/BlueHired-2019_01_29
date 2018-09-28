//
//  LPRegisterDetailModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
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


@end
