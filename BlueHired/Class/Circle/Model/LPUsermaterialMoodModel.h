//
//  LPUsermaterialMoodModel.h
//  BlueHired
//
//  Created by iMac on 2018/11/13.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPUsermaterialMoodDataModel;

@interface LPUsermaterialMoodModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPUsermaterialMoodDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end



@interface LPUsermaterialMoodDataModel : NSObject
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *concernNum;
@property (nonatomic, strong) NSString *grading;
@property (nonatomic, strong) NSString *ideal_money;
@property (nonatomic, strong) NSString *ideal_post;
@property (nonatomic, strong) NSString *marry_status;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *moodNum;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *shipping_address;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_sex;
@property (nonatomic, strong) NSString *user_url;
@property (nonatomic, strong) NSString *workStatus;
@property (nonatomic, strong) NSString *work_type;
@property (nonatomic, strong) NSString *work_years;
@property (nonatomic, strong) NSString *mechanismName;
@property (nonatomic, strong) NSString *isConcern;

@end

NS_ASSUME_NONNULL_END
