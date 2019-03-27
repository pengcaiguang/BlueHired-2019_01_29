//
//  LPWorkHourTypeRedactVC.h
//  BlueHired
//
//  Created by iMac on 2019/2/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPWorkHourTypeRedactVC : LPBaseViewController

//0.企业底薪编辑
//1.加班工资编辑
//2.所得税编辑
//3.事假编辑
//4.调休编辑
//5.病假编辑
//6.其他假编辑
//7.白班补贴编辑
//8.餐费补贴编辑
//9.其他扣款编辑
//10.公积金编辑
//11.社保编辑
@property (nonatomic,assign) NSInteger ClassType;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,strong) NSString *ShiftAllowance;

@end

NS_ASSUME_NONNULL_END
