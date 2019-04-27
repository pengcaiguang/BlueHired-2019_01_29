//
//  LPMineCardCell.h
//  BlueHired
//
//  Created by peng on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPUserMaterialModel.h"

@interface LPMineCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBghigh;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;

@end
