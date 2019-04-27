//
//  LPMainCell.h
//  BlueHired
//
//  Created by peng on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorklistModel.h"


typedef void(^LPMainCellBlock)(void);

@interface LPMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mechanismUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isApplyLabel;

@property (weak, nonatomic) IBOutlet UILabel *workTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *IssueBt;
@property (weak, nonatomic) IBOutlet UILabel *ReMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *ReturnBt;

@property(nonatomic,strong) LPWorklistDataWorkListModel *model;

@property (nonatomic,copy) LPMainCellBlock block;


@end
