//
//  LPMechanismcommentDetailModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMechanismcommentDetailDataModel;
@interface LPMechanismcommentDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPMechanismcommentDetailDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPMechanismcommentDetailDataModel : NSObject

@end
