//
//  LPMechanismcommentMechanismlistModel.h
//  BlueHired
//
//  Created by peng on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMechanismcommentMechanismlistDataModel;
@interface LPMechanismcommentMechanismlistModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPMechanismcommentMechanismlistDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPMechanismcommentMechanismlistDataModel : NSObject
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *imageList;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *lendType;
@property (nonatomic, copy) NSString *mechanismAddress;
@property (nonatomic, copy) NSString *mechanismDetails;
@property (nonatomic, copy) NSString *mechanismLogo;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSNumber *mechanismScore;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *x;
@property (nonatomic, copy) NSNumber *y;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *postType;
@property (nonatomic, copy) NSString *recommendType;//0未推荐  1已推荐



@end
