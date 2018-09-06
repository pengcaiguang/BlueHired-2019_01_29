//
//  LPIsApplyOrIsCollectionModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPIsApplyOrIsCollectionDataModel;
@interface LPIsApplyOrIsCollectionModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPIsApplyOrIsCollectionDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPIsApplyOrIsCollectionDataModel : NSObject
@property (nonatomic, assign) BOOL isApply;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, copy) NSString *userName;
@end
