//
//  LPWorkDetailFromCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPWorkDetailFromCell : UITableViewCell
@property(nonatomic,strong) LPWorkDetailModel *model;
@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_postType_Top;

@end

NS_ASSUME_NONNULL_END
