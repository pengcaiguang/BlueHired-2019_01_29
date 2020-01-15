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
#import "LPWorkCollectionModel.h"
typedef void(^LPCollectionWorkCellBlock)(LPWorkCollectionDataModel *model);

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPMainCellBlock)(void);
@interface LPMain2Cell : UITableViewCell<XHStarRateViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mechanismUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isWorkers;
 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ayoutConstraint_Lend_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ayoutConstraint_Lend_Right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ayoutConstraint_WorkImage_left;
@property(nonatomic,strong) LPWorklistDataWorkListModel *model;

//收藏
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;
@property (nonatomic,copy) LPCollectionWorkCellBlock selectBlock;
@property(nonatomic,strong) LPWorkCollectionDataModel *Cmodel;

@property (nonatomic,copy) LPMainCellBlock block;

@property(nonatomic,assign) BOOL iscornerRadius;
@property(nonatomic,assign) NSInteger CellType;


@end

NS_ASSUME_NONNULL_END
