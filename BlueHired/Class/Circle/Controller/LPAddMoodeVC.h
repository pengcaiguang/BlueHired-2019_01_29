//
//  LPAddMoodeVC.h
//  BlueHired
//
//  Created by peng on 2018/9/19.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPrizeMoney.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddMoodeVCBlock)(NSString *moodDetails ,NSString *moodUrl ,NSString *address);
typedef void(^LPSenderMoodeVCBlock)(void);

@interface LPAddMoodeVC : LPBaseViewController

//Type =0 发圈子  type =1 工资分享   type =2 奖励分享
@property (nonatomic,assign) NSInteger Type;
@property (nonatomic,strong) NSString *ShareString;
@property (nonatomic,strong) UIImage *ShareImage;
@property (nonatomic,strong) LPPrizeDataMoney *Sharemodel;
@property (nonatomic,copy) LPAddMoodeVCBlock block;
@property (nonatomic,copy) LPSenderMoodeVCBlock Senderblock;


@end

NS_ASSUME_NONNULL_END
