//
//  LPInfoCell.h
//  BlueHired
//
//  Created by peng on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPInfoListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPInfoCellSelectBlock)(LPInfoListDataModel *model);

@interface LPInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *informationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img_contraint_width;

@property(nonatomic,strong) LPInfoListDataModel *model;
@property (nonatomic,copy) LPInfoCellSelectBlock selectBlock;
@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;

@end

NS_ASSUME_NONNULL_END
