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

@property (weak, nonatomic) IBOutlet UIView *BackBGView;

@property (weak, nonatomic) IBOutlet UILabel *MontyLabel1;
@property (weak, nonatomic) IBOutlet UILabel *MontyLabel2;
@property (weak, nonatomic) IBOutlet UILabel *MontyLabel3;
@property (weak, nonatomic) IBOutlet UILabel *MontyLabel4;
@property (weak, nonatomic) IBOutlet UILabel *MontyLabel5;
@property (weak, nonatomic) IBOutlet UILabel *MontyLabel6;
@property (weak, nonatomic) IBOutlet UILabel *MontyLabel7;

@property (weak, nonatomic) IBOutlet UILabel *MontyTitleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *MontyTitleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *MontyTitleLabel4;
@property (weak, nonatomic) IBOutlet UILabel *MontyTitleLabel5;
@property (weak, nonatomic) IBOutlet UILabel *MontyTitleLabel6;
@property (weak, nonatomic) IBOutlet UILabel *MontyTitleLabel7;

@property (weak, nonatomic) IBOutlet UIView *MontyView2;
@property (weak, nonatomic) IBOutlet UIView *MontyView3;
@property (weak, nonatomic) IBOutlet UIView *MontyView4;
@property (weak, nonatomic) IBOutlet UIView *MontyView5;
@property (weak, nonatomic) IBOutlet UIView *MontyView6;
@property (weak, nonatomic) IBOutlet UIView *MontyView7;

@property (nonatomic, assign) NSInteger WorkHourType;

@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong) LPSelectWorkhourModel *model;
@property(nonatomic,strong) NSArray *MoneyList;
@property(nonatomic,strong) NSString *MoneyNum;

@end
