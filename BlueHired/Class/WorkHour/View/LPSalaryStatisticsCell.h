//
//  LPSalaryStatisticsCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/14.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LPSalaryStatisticsCellBlock)(NSString *string);

@interface LPSalaryStatisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subsidyLabel;
@property (weak, nonatomic) IBOutlet UILabel *deductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *overtimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *basicSalaryTextField;

@property (nonatomic,copy) LPSalaryStatisticsCellBlock block;

@end
