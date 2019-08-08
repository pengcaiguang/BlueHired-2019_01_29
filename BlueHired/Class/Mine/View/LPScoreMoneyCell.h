//
//  LPScoreMoneyCell.h
//  BlueHired
//
//  Created by iMac on 2019/7/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPGetScoreMoneyRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPScoreMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *Money;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_UserName_Left;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) LPGetScoreMoneyRecordDataModel *model;


@end

NS_ASSUME_NONNULL_END
