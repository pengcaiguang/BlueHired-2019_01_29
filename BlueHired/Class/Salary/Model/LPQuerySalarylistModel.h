//
//  LPQuerySalarylistModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPQuerySalarylistDataModel;
@interface LPQuerySalarylistModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSArray <LPQuerySalarylistDataModel *>*data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPQuerySalarylistDataModel : NSObject

@end
