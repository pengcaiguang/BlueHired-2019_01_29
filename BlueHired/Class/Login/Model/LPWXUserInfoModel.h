//
//  LPWXUserInfoModel.h
//  BlueHired
//
//  Created by iMac on 2018/12/13.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPWXUserInfoModel : NSObject
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* headimgurl;
@property (nonatomic,strong) NSString* language;
@property (nonatomic,strong) NSString* nickname;
@property (nonatomic,strong) NSString* openid;
@property (nonatomic,strong) NSString* privilege;
@property (nonatomic,strong) NSString* province;
@property (nonatomic,strong) NSString* sex;
@property (nonatomic,strong) NSString* unionid;

@end

NS_ASSUME_NONNULL_END
