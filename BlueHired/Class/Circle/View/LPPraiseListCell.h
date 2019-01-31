//
//  LPPraiseListCell.h
//  BlueHired
//
//  Created by iMac on 2018/12/22.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPraiseListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LPPraiseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *gradingImage;

@property (nonatomic,strong) LPPraiseDataModel *model;

@end

NS_ASSUME_NONNULL_END
