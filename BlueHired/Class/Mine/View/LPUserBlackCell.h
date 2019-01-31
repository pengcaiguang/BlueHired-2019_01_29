//
//  LPUserBlackCell.h
//  BlueHired
//
//  Created by iMac on 2018/11/19.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPUserBlackModel.h"
typedef void(^LPUserBlackCellBlock)(LPUserBlackDataModel *Delete);

NS_ASSUME_NONNULL_BEGIN

@interface LPUserBlackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic,copy) LPUserBlackCellBlock Block;

@property (nonatomic,strong) LPUserBlackDataModel *model;

@end

NS_ASSUME_NONNULL_END
