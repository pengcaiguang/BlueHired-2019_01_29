//
//  LPRegisterEntryCell.h
//  BlueHired
//
//  Created by iMac on 2019/8/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPInviteWorkListModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface LPRegisterEntryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddresLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property(nonatomic,strong) LPInviteWorkListDataModel *model;

@end

NS_ASSUME_NONNULL_END
