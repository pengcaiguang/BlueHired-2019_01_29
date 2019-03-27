//
//  LPByThePieceCell.h
//  BlueHired
//
//  Created by iMac on 2019/3/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPHoursWorkListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPByThePieceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Subview_constrait_height;
@property (weak, nonatomic) IBOutlet UIView *BgView;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *SubBGView;

@property (nonatomic,strong) NSArray <LPHoursWorkListLeaveModel *> *model;



@end

NS_ASSUME_NONNULL_END
