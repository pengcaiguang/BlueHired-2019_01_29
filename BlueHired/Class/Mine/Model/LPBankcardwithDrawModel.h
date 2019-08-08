//
//  LPBankcardwithDrawModel.h
//  BlueHired
//
//  Created by peng on 2018/9/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPBankcardwithDrawDataModel;
@interface LPBankcardwithDrawModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPBankcardwithDrawDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPBankcardwithDrawDataModel : NSObject
@property(nonatomic,copy) NSNumber *type;
@property(nonatomic,strong) NSString *bankName;
@property(nonatomic,strong) NSString *bankNumber;
@property(nonatomic,strong) NSString *cardType;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *chargeMoney;
@property(nonatomic,strong) NSString *remark;

@end
NS_ASSUME_NONNULL_END
