//
//  LPWorkHourSetCell.h
//  BlueHired
//
//  Created by iMac on 2019/3/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPWorkHourSetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameTitle;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;
@property (weak, nonatomic) IBOutlet UIImageView *Image;

@end

NS_ASSUME_NONNULL_END
