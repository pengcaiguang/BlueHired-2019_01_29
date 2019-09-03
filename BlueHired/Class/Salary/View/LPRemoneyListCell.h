//
//  LPRemoneyListCell.h
//  BlueHired
//
//  Created by iMac on 2019/8/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPReMoneyDrawModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRemoneyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *WorkName;
@property (weak, nonatomic) IBOutlet UILabel *InTime;
@property (weak, nonatomic) IBOutlet UILabel *isShowDraw;
@property (nonatomic,strong) LPReMoneyDrawDataModel *model;

@end

NS_ASSUME_NONNULL_END
