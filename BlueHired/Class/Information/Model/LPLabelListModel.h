//
//  LPLabelListModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPLabelListDataModel;
@interface LPLabelListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPLabelListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPLabelListDataModel : NSObject
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, copy) NSNumber *labelType;
@property (nonatomic, copy) NSString *labelUrl;

@end
