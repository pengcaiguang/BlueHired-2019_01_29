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
    
    self.workTypeArray = @[@"早班时长",@"中班时长",@"晚班时长",@"夜班时长"];
    self.addTypeTypeArray = @[@"普通加班时长",@"周六,日加班时长",@"节假日加班时长"];
    self.leaveTypeArray = @[@"带薪休假",@"调休",@"事假",@"病假",@"其它请假"];
    
}
-(void)setIndex:(NSInteger)index{
    _index = index;
}

-(void)setModel:(LPSelectWorkhourModel *)model{
//    if ([self.model.mj_JSONString isEqualToString:model.mj_JSONString]) {
//        return;
//    }

    _model = model;
    if (self.index == 0) {
        self.colorView.backgroundColor = [UIColor baseColor];
        self.typeTitleLabel.text = @"正常上班/月";
        
        NSMutableArray *hourArray = [NSMutableArray array];
        NSMutableArray *ColorArray = [NSMutableArray array];

        NSArray *colorArr = @[[UIColor colorWithHexString:@"#F0E7A8"],
                                [UIColor colorWithHexString:@"#FFD8BE"],
                                [UIColor colorWithHexString:@"#9FBEE2"],
                                [UIColor colorWithHexString:@"#A7F4C4"]];
        // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
//        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workType" ascending:YES];
//        // 排序结果
//        NSArray *sortArray= [model.data.normalHourList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

        
        for (LPSelectWorkhourDataNormalHourListModel *m in model.data.normalHourList) {
            [hourArray addObject:m.totalWorkHour ? m.totalWorkHour : @(0)];
            [ColorArray addObject:colorArr[m.workType.integerValue]];
        }
        
        if (hourArray.count < self.workTypeArray.count) {
            for (int i=0; i<self.workTypeArray.count-model.data.normalHourList.count; i++) {
                [hourArray addObject:@(0)];
            }
        }

        self.pie.valueArr = [hourArray copy];
        self.pie.descArr = self.workTypeArray;
    
        self.pie.colorArr = [ColorArray copy];


        CGFloat h = 24*self.workTypeArray.count+30 + 50;
        if (h < 170) {
            h = 170;
        }
        self.view_constrait_height.constant = h;
        self.pie.frame = CGRectMake(0, 50, SCREEN_WIDTH, h-50);
//        self.pie.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];

    }else if (self.index == 1) {
        self.colorView.backgroundColor = [UIColor colorWithHexString:@"#45F4FF"];
        self.typeTitleLabel.text = @"加班记录/月";
        
        NSMutableArray *hourArray = [NSMutableArray array];
        NSMutableArray *ColorArray = [NSMutableArray array];

        NSArray *colorArr = @[[UIColor colorWithHexString:@"#FFD8BE"],
                                [UIColor colorWithHexString:@"#80BCFF"],
                                [UIColor colorWithHexString:@"#F0E7A8"]];
        // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
//        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"addType" ascending:YES];
//        // 排序结果
//        NSArray *sortArray= [model.data.addHourList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        for (LPSelectWorkhourDataAddHourListModel *m in model.data.addHourList) {
            [hourArray addObject:m.totalAddHour];
            [ColorArray addObject:colorArr[m.addType.integerValue]];
        }
        if (hourArray.count < self.addTypeTypeArray.count) {
            for (int i=0; i<self.addTypeTypeArray.count-model.data.addHourList.count; i++) {
                [hourArray addObject:@(0)];
            }
        }

    
        self.pie.valueArr = [hourArray copy];
        self.pie.descArr = self.addTypeTypeArray;
        self.pie.colorArr = [colorArr copy];

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
        NSMutableArray *ColorArray = [NSMutableArray array];

        // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
//        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"leaveType" ascending:YES];
//        // 排序结果
//        NSArray *sortArray= [model.data.leaveHourList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSArray *colorArr = @[[UIColor colorWithHexString:@"#FFCC73"],
                                [UIColor colorWithHexString:@"#9FBEE2"],
                                [UIColor colorWithHexString:@"#FFD8BE"],
                                [UIColor colorWithHexString:@"#F0E7A8"],
                                [UIColor colorWithHexString:@"#A7F4C4"]];
        
        for (LPSelectWorkhourDataLeaveHourListModel *m in model.data.leaveHourList) {
            [hourArray addObject:m.totalLeaveHour];
            [ColorArray addObject:colorArr[m.leaveType.integerValue]];

        }
        if (hourArray.count < self.leaveTypeArray.count) {
            for (int i=0; i<self.leaveTypeArray.count-model.data.leaveHourList.count; i++) {
                [hourArray addObject:@(0)];
            }
        }
        self.pie.valueArr = [hourArray copy];
        

        self.pie.descArr = self.leaveTypeArray;

        self.pie.colorArr = [ColorArray copy];


        CGFloat h = 24*self.leaveTypeArray.count+30 + 50;
        if (h < 170) {
            h = 170;
        }
        self.view_constrait_height.constant = h;
        self.pie.frame = CGRectMake(0, 50, SCREEN_WIDTH, h-50);
    }

    
    [self.pie showAnimation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
