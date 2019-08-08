//
//  LPMain2Cell.h
//  BlueHired
//
//  Created by iMac on 2019/1/4.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"
#import "LPWorklistModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPMainCellBlock)(void);
@interface LPMain2Cell : UITableViewCell<XHStarRateViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mechanismUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageRangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mechanismScoreLabel;
@property (strong, nonatomic) IBOutlet UIView *mechanismScoreView;
@property (strong, nonatomic) IBOutlet UIImageView *mechanismScoreImage;

@property (weak, nonatomic) IBOutlet UIButton *reMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *reMoneyImage;

@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *isWorkers;

@property (weak, nonatomic) IBOutlet UILabel *isApplyLabel;

@property (weak, nonatomic) IBOutlet UILabel *AgeLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyLabel_constraint_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyLabel_constraint_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lendTypeLabel_constraint_Width;

 


@property(nonatomic,strong) LPWorklistDataWorkListModel *model;
@property(nonatomic,strong) XHStarRateView *starRateView;
@property (nonatomic,copy) LPMainCellBlock block;

@property(nonatomic,assign) BOOL iscornerRadius;


@property(nonatomic,assign) NSInteger CellType;


@end

NS_ASSUME_NONNULL_END
