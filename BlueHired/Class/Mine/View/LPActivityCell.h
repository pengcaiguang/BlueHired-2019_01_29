//
//  LPActivityCell.h
//  BlueHired
//
//  Created by iMac on 2019/1/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPActivityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BGImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UIButton *ActivityBT;
@property(nonatomic,strong) LPActivityDataModel *model;

@end

NS_ASSUME_NONNULL_END
