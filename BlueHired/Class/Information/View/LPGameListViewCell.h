//
//  LPGameListViewCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPShanDWLIistModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPGameListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GameImage;
@property (weak, nonatomic) IBOutlet UILabel *GameName;
@property (weak, nonatomic) IBOutlet UILabel *GameTyep;
@property (weak, nonatomic) IBOutlet UILabel *GameSub;
@property (weak, nonatomic) IBOutlet UIButton *GameBtn;

@property (nonatomic, strong) LPShanDWLIistDataModel *model;

@end

NS_ASSUME_NONNULL_END
