//
//  LPCustomMessageModel.h
//  BlueHired
//
//  Created by iMac on 2019/11/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPCustomMessageModel : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isSender;
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, copy) NSString *telephone;

@end

NS_ASSUME_NONNULL_END
