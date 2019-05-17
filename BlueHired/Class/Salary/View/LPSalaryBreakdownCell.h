//
//  LPSalaryBreakdownCell.h
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPSalaryBreakdownCellBlock)(void);

@interface LPSalaryBreakdownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *AlreadyLabel;
@property (weak, nonatomic) IBOutlet UIButton *DrawBt;
@property (nonatomic,copy) LPSalaryBreakdownCellBlock block;

@end

NS_ASSUME_NONNULL_END
