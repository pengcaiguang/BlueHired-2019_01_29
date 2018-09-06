//
//  LPUserMaterialModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPUserMaterialDataModel;
@interface LPUserMaterialModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPUserMaterialDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPUserMaterialDataModel : NSObject
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSNumber *concernNum;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSString *ideal_money;
@property (nonatomic, copy) NSString *ideal_post;
@property (nonatomic, copy) NSNumber *marry_status;
@property (nonatomic, copy) NSNumber *money;
@property (nonatomic, copy) NSNumber *moodNum;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSNumber *score;
@property (nonatomic, copy) NSString *shipping_address;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_sex;
@property (nonatomic, copy) NSString *user_url;
@property (nonatomic, copy) NSNumber *workStatus;
@property (nonatomic, copy) NSString *work_type;
@property (nonatomic, copy) NSNumber *work_years;
@end
