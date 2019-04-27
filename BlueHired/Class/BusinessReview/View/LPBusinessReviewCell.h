//
//  LPBusinessReviewCell.h
//  BlueHired
//
//  Created by peng on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMechanismcommentMechanismlistModel.h"

@interface LPBusinessReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mechanismLogoImgView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mechanismAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mechanismScoreLabel;

@property(nonatomic,strong) LPMechanismcommentMechanismlistDataModel *model;

@end
