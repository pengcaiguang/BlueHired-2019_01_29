//
//  LPWorkDetailHeadCell.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkDetailModel.h"
#import "XHStarRateView.h"

@interface LPWorkDetailHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mechanismScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyLabel_constraint_Height;
@property (weak, nonatomic) IBOutlet UIView *KeyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_KeyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyLabel_constraint_right;
@property (weak, nonatomic) IBOutlet UIButton *reMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *reMoneyImage;

@property (weak, nonatomic) IBOutlet UIButton *lendTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *ReMoneyDeclare;

@property (weak, nonatomic) IBOutlet UILabel *workTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workName;
@property (weak, nonatomic) IBOutlet UILabel *applyNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet UILabel *BackMoneylabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayouConstraint_BackView_Height;
@property (strong, nonatomic) IBOutlet UIView *mechanismScoreView;

@property(nonatomic,strong) LPWorkDetailModel *model;
@property(nonatomic,strong) XHStarRateView *starRateView;

@end
