//
//  LPWorkHourDetailPieChartCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkHourDetailPieChartCell.h"
#import "WSPieChart.h"

@implementation LPWorkHourDetailPieChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    WSPieChart *pie = [[WSPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    pie.valueArr = @[@500,@200,@330,@220];
    pie.descArr = @[@"早班时长",@"中班时长",@"晚班时长",@"夜班时长"];
    pie.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:pie];
    pie.positionChangeLengthWhenClick = 20;
    pie.showDescripotion = YES;
    [pie showAnimation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
