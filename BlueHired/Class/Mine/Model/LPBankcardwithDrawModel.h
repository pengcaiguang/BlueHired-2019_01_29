//
//  LPBankcardwithDrawModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/30.
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

@end
NS_ASSUME_NONNULL_END
