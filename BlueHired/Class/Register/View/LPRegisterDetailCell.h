//
//  LPRegisterDetailCell.h
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPRegisterDetailModel.h"


@interface LPRegisterDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remarkiamge;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Label_Top;

// 1 = 邀请入职。2 = 邀请注册
@property (nonatomic,assign) NSInteger Type;

@property(nonatomic,strong) LPRegisterDetailDataListModel *model;

@end


