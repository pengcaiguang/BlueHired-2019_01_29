//
//  LPMechanismlistModel.h
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMechanismlistDataModel;
@interface LPMechanismlistModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPMechanismlistDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@class LPMechanismlistDataListModel;
@interface LPMechanismlistDataModel : NSObject
@property (nonatomic, copy) NSArray <LPMechanismlistDataListModel *> *mechanismTypeList;
@end


@interface LPMechanismlistDataListModel : NSObject

@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSString *mechanismTypeName;
@property(nonatomic,copy) NSString *workTypeList;

@end
