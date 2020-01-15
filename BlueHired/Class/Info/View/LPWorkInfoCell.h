//
//  LPWorkInfoCell.h
//  BlueHired
//
//  Created by iMac on 2020/1/8.
//  Copyright © 2020 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPInfoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPWorkInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DetailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *WorkImage;
@property (weak, nonatomic) IBOutlet UIView *BgView;

@property (nonatomic,strong) LPInfoListDataModel *model;
@end

NS_ASSUME_NONNULL_END
