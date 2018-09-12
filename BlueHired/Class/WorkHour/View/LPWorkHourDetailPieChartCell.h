//
//  LPWorkHourDetailPieChartCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPSelectWorkhourModel.h"

@interface LPWorkHourDetailPieChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_constrait_height;

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;


@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong) LPSelectWorkhourModel *model;

@end
