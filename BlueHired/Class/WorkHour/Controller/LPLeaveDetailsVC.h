//
//  LPLeaveDetailsVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPLeaveDetailsVC : LPBaseViewController
@property (nonatomic,strong) NSString *KQDateString;
@property (nonatomic,assign) NSInteger Type; //1为加班，2为请假，3为消费
@property (nonatomic, assign) NSInteger WorkHourType;

@end
 
NS_ASSUME_NONNULL_END
