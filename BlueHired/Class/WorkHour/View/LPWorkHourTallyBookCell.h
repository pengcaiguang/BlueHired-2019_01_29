//
//  LPWorkHourTallyBookCell.h
//  BlueHired
//
//  Created by iMac on 2019/2/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOverTimeAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPWorkHourTallyBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BookContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentView_Height;
@property (weak, nonatomic) IBOutlet UIButton *TallyButton;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;

@property (nonatomic, strong)NSArray <LPOverTimeAccountDataaccountListModel *> *accountList;

@end

NS_ASSUME_NONNULL_END
