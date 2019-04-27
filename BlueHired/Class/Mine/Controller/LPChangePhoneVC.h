//
//  LPChangePhoneVC.h
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPChangePhoneVC : LPBaseViewController
//type 1 = 手机号验证(联系客服) 2= 手机号验证(密保) 3 =绑定新手机号 4= 手机号验证(微信) 
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger Newtype;

@end

NS_ASSUME_NONNULL_END
