//
//  LPEmployeeManageCell.h
//  BlueHired
//
//  Created by iMac on 2019/8/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLPEmployeeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPEmployeeRemarkBlock)(void);

@interface LPEmployeeManageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PostLabel;
@property (weak, nonatomic) IBOutlet UILabel *WorkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (nonatomic, strong) LPEmployeeRemarkBlock remarkBlock;

@property (nonatomic,strong) LPLPEmployeeDataModel *model;

@end

NS_ASSUME_NONNULL_END
