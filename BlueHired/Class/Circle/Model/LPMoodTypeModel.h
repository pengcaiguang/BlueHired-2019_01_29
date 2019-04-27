//
//  LPMoodTypeModel.h
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMoodTypeDataModel;
@interface LPMoodTypeModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPMoodTypeDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPMoodTypeDataModel : NSObject
@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSString *labelName;
@property(nonatomic,copy) NSString *labelType;
@property(nonatomic,copy) NSString *labelUrl;

@end
