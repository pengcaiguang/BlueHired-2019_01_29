//
//  LPCircleInfoCell.h
//  BlueHired
//
//  Created by iMac on 2019/4/17.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPInfoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPCircleInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *informationDetails;
@property (weak, nonatomic) IBOutlet UILabel *Date;

@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UIImageView *MoodImage;
@property (weak, nonatomic) IBOutlet UIImageView *gradingImage;
@property (weak, nonatomic) IBOutlet UIImageView *PlayImage;
@property (weak, nonatomic) IBOutlet UIImageView *PraiseImage;

@property(nonatomic,strong) LPInfoListDataModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutContraint_MoodImage_width;

@end

NS_ASSUME_NONNULL_END
