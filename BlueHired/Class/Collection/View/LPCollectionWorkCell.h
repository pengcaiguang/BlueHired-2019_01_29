//
//  LPCollectionWorkCell.h
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPCollectionWorkCellBlock)(LPWorkCollectionDataModel *model);

@interface LPCollectionWorkCell : UITableViewCell
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

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_contraint_width;


@property(nonatomic,strong) LPWorkCollectionDataModel *model;
@property (nonatomic,copy) LPCollectionWorkCellBlock selectBlock;

@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;
@end

NS_ASSUME_NONNULL_END
