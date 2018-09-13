//
//  LPWorkHourDetailPieChartCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkHourDetailPieChartCell.h"
#import "WSPieChart.h"

@interface LPWorkHourDetailPieChartCell ()

@property(nonatomic,strong) WSPieChart *pie;

@property(nonatomic,strong) NSArray *workTypeArray;
@property(nonatomic,strong) NSArray *addTypeTypeArray;
@property(nonatomic,strong) NSArray *leaveTypeArray;

@end

@implementation LPWorkHourDetailPieChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    WSPieChart *pie = [[WSPieChart alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 120)];
//    pie.valueArr = @[@500,@200,@330,@220];
//    pie.descArr = @[@"早班时长",@"中班时长",@"晚班时长",@"夜班时长"];
    pie.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:pie];
    pie.positionChangeLengthWhenClick = 20;
    pie.showDescripotion = YES;
    [pie showAnimation];
    self.pie = pie;
    
    self.workTypeArray = @[@"早班",@"中班",@"晚班",@"夜班"];
    self.addTypeTypeArray = @[@"普通加班",@"周末加班",@"节假日加班"];
    self.leaveTypeArray = @[@"带薪休假",@"调休",@"事假",@"病假",@"其它请假"];
    
}
-(void)setIndex:(NSInteger)index{
    _index = index;
}

-(void)setModel:(LPSelectWorkhourModel *)model{
    _model = model;
    if (self.index == 0) {
        self.colorView.backgroundColor = [UIColor baseColor];
        self.typeTitleLabel.text = @"正常上班/月";
        
        NSMutableArray *hourArray = [NSMutableArray array];
        for (LPSelectWorkhourDataNormalHourListModel *m in model.data.normalHourList) {
            [hourArray addObject:m.totalWorkHour ? m.totalWorkHour : @(0)];
        }
        if (hourArray.count < self.workTypeArray.count) {
            for (int i=0; i<self.workTypeArray.count-model.data.normalHourList.count; i++) {
                [hourArray addObject:@(0)];
            }
        }
        self.pie.valueArr = [hourArray copy];
        
//        NSMutableArray *typeArray = [NSMutableArray array];
//        for (LPSelectWorkhourDataNormalHourListModel *m in model.data.normalHourList) {
//            [typeArray addObject:self.workTypeArray[m.workType.integerValue]];
//        }
//        self.pie.descArr = [typeArray copy];
        self.pie.descArr = self.workTypeArray;

        NSArray *colorArray = @[[UIColor colorWithHexString:@"#F0E7A8"],[UIColor colorWithHexString:@"#FFD8BE"],[UIColor colorWithHexString:@"#9FBEE2"],[UIColor colorWithHexString:@"#A7F4C4"]];
        self.pie.colorArr = colorArray;
//        if (typeArray.count <= colorArray.count) {
//            self.pie.colorArr = [colorArray subarrayWithRange:NSMakeRange(0, typeArray.count)];
//        }

        CGFloat h = 24*self.workTypeArray.count+30 + 50;
        if (h < 170) {
            h = 170;
        }
        self.view_constrait_height.constant = h;
        self.pie.frame = CGRectMake(0, 50, SCREEN_WIDTH, h-50);

    }else if (self.index == 1) {
        self.colorView.backgroundColor = [UIColor colorWithHexString:@"#45F4FF"];
        self.typeTitleLabel.text = @"加班记录/月";
        
        NSMutableArray *hourArray = [NSMutableArray array];
        for (LPSelectWorkhourDataAddHourListModel *m in model.data.addHourList) {
            [hourArray addObject:m.totalAddHour];
        }
        if (hourArray.count < self.addTypeTypeArray.count) {
            for (int i=0; i<self.addTypeTypeArray.count-model.data.addHourList.count; i++) {
                [hourArray addObject:@(0)];
            }
        }
        self.pie.valueArr = [hourArray copy];
        
//        NSMutableArray *typeArray = [NSMutableArray array];
//        for (LPSelectWorkhourDataAddHourListModel *m in model.data.addHourList) {
//            [typeArray addObject:self.addTypeTypeArray[m.addType.integerValue]];
//        }
//        self.pie.descArr = [typeArray copy];
        self.pie.descArr = self.addTypeTypeArray;
        NSArray *colorArray = @[[UIColor colorWithHexString:@"#FFD8BE"],[UIColor colorWithHexString:@"#80BCFF"],[UIColor colorWithHexString:@"#F0E7A8"]];
        self.pie.colorArr = colorArray;
//        if (typeArray.count <= colorArray.count) {
//            self.pie.colorArr = [colorArray subarrayWithRange:NSMakeRange(0, typeArray.count)];
//        }
        CGFloat h = 24*self.addTypeTypeArray.count+30 + 50;
        if (h < 170) {
            h = 170;
        }
        self.view_constrait_height.constant = h;
        self.pie.frame = CGRectMake(0, 50, SCREEN_WIDTH, h-50);

    }else if (self.index == 2) {
        self.colorView.backgroundColor = [UIColor colorWithHexString:@"#FFBC3C"];
        self.typeTitleLabel.text = @"请假记录/月";
        
        NSMutableArray *hourArray = [NSMutableArray array];
        for (LPSelectWorkhourDataLeaveHourListModel *m in model.data.leaveHourList) {
            [hourArray addObject:m.totalLeaveHour];
        }
        if (hourArray.count < self.leaveTypeArray.count) {
            for (int i=0; i<self.leaveTypeArray.count-model.data.leaveHourList.count; i++) {
                [hourArray addObject:@(0)];
            }
        }
        self.pie.valueArr = [hourArray copy];
        
//        NSMutableArray *typeArray = [NSMutableArray array];
//        for (LPSelectWorkhourDataLeaveHourListModel *m in model.data.leaveHourList) {
//            [typeArray addObject:self.leaveTypeArray[m.leaveType.integerValue]];
//        }
//        self.pie.descArr = [typeArray copy];
        self.pie.descArr = self.leaveTypeArray;
        NSArray *colorArray = @[[UIColor colorWithHexString:@"#FFCC73"],[UIColor colorWithHexString:@"#FFD8BE"],[UIColor colorWithHexString:@"#F0E7A8"],[UIColor colorWithHexString:@"#9FBEE2"],[UIColor colorWithHexString:@"#A7F4C4"]];
        self.pie.colorArr = colorArray;
//        if (typeArray.count <= colorArray.count) {
//            self.pie.colorArr = [colorArray subarrayWithRange:NSMakeRange(0, typeArray.count)];
//        }

        CGFloat h = 24*self.leaveTypeArray.count+30 + 50;
        if (h < 170) {
            h = 170;
        }
        self.view_constrait_height.constant = h;
        self.pie.frame = CGRectMake(0, 50, SCREEN_WIDTH, h-50);
    }
    
//    self.pie.valueArr = @[@10,@2,@3,@8,@4.5];
//    self.pie.descArr = @[@"早班时长",@"中班时长",@"晚班时长",@"夜班时长",@"中班"];
//
//    CGFloat h = 24*self.pie.descArr.count+30 + 50;
//    if (h < 120) {
//        h = 120;
//    }
//    self.view_constrait_height.constant = h;
//    self.pie.frame = CGRectMake(0, 50, SCREEN_WIDTH, h-50);
    
    [self.pie showAnimation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
