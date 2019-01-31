//
//  LPUserModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPUserDataModel;
@interface LPUserModel : NSObject
@property (nonatomic, strong) LPUserDataModel *user;
@end


@interface LPUserDataModel : NSObject

@property (nonatomic,strong) NSString* identity;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* phone;
@property (nonatomic,strong) NSString* role;
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSString* upIdentity;
@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* userImage;
@property (nonatomic,strong) NSString* userName;
@property (nonatomic,strong) NSString* workStatus;

@end

NS_ASSUME_NONNULL_END
