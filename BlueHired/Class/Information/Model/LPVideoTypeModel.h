//
//  LPVideoTypeModel.h
//  BlueHired
//
//  Created by iMac on 2018/12/11.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPVideoTypeDataModel;
@interface LPVideoTypeModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPVideoTypeDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPVideoTypeDataModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *labelName;
@property (nonatomic, strong) NSString *labelType;
@property (nonatomic, strong) NSString *labelUrl;
 
@end
NS_ASSUME_NONNULL_END
