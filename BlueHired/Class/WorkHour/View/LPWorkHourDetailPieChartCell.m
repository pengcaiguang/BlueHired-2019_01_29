//
//  LPWorkHourDetailPieChartCell.m
//  BlueHired
//
//  Created by peng on 2018/9/11.
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
    WSPieChart *pie = [[WSPieChart alloc] initWithFrame:CGRectMake(0, 50, 107/320*SCREEN_WIDTH+26, 215)];
//    pie.valueArr = @[@500,@200,@330,@220];
//    pie.descArr = @[@"早班时长",@"中班时长",@"晚班时长",@"夜班时长"];
    pie.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:pie];
    pie.positionChangeLengthWhenClick = 20;
    pie.showDescripotion = YES;
    [pie showAnimation];
    self.pie = pie;
    
    self.workTypeArray = @[@"企业底薪",@"加班工资",@"请假总计",@"补贴总计",@"扣款总计",@"其他总计"];
    self.addTypeTypeArray = @[@"普通加班时长",@"周六,日加班时长",@"节假日加班时长"];
    self.leaveTypeArray = @[@"带薪休假",@"调休",@"事假",@"病假",@"其它请假"];

    for (UIView *v in self.typeTitleLabel.superview.subviews) {
        if (v.tag == 1000) {
            v.layer.cornerRadius = 3;
        }
    }
    [self addShadowToView:self.BackBGView withColor:[UIColor colorWithHexString:@"#12598B"]];
 

}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.x = 13;
//    frame.origin.y = 3;
//
//    frame.size.width -= 2 * frame.origin.x;
//    frame.size.height -= 6;
//    [super setFrame:frame];
//}


/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,4);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 6;
    theView.layer.masksToBounds = NO;

}



-(void)setIndex:(NSInteger)index{
    _index = index;
}

- (void)setMoneyNum:(NSString *)MoneyNum{
    _MoneyNum = MoneyNum;
    self.MontyLabel1.text = MoneyNum;
}
- (void)setMoneyList:(NSArray *)MoneyList{
    _MoneyList = MoneyList;
    NSArray *colorArr = @[];
    if (self.WorkHourType == 3) {
        self.MontyTitleLabel2.text = @"工作工资(元)";
        self.MontyTitleLabel3.text = @"补贴总计(元)";
        self.MontyTitleLabel4.text = @"扣款总计(元)";
        self.MontyTitleLabel5.text = @"其他总计(元)";
        self.MontyTitleLabel6.text = @"";
        self.MontyTitleLabel7.text = @"";
        
        self.MontyView2.backgroundColor = [UIColor colorWithHexString:@"#3B7BEF"];
        self.MontyView3.backgroundColor = [UIColor colorWithHexString:@"#FFAF3C"];
        self.MontyView4.backgroundColor = [UIColor colorWithHexString:@"#14DFFF"];
        self.MontyView5.backgroundColor = [UIColor colorWithHexString:@"#3CAFFF"];
        self.MontyView6.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.MontyView7.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.MontyLabel2.text = MoneyList[0];
        self.MontyLabel3.text = MoneyList[1];
        self.MontyLabel4.text = MoneyList[2];
        self.MontyLabel5.text = MoneyList[3];
        self.MontyLabel6.text = @"";
        self.MontyLabel7.text = @"";
        
        colorArr = @[[UIColor colorWithHexString:@"#3B7BEF"],
                     [UIColor colorWithHexString:@"#FFAF3C"],
                     [UIColor colorWithHexString:@"#14E0FF"],
                     [UIColor colorWithHexString:@"#3CAFFF"]];
    }else if (self.WorkHourType == 4){
        self.MontyTitleLabel2.text = @"企业底薪(元)";
        self.MontyTitleLabel3.text = @"计件工资(元)";
        self.MontyTitleLabel4.text = @"补贴总计(元)";
        self.MontyTitleLabel5.text = @"扣款总计(元)";
        self.MontyTitleLabel6.text = @"其他总计(元)";
        self.MontyTitleLabel7.text = @"";
        
        self.MontyView2.backgroundColor = [UIColor colorWithHexString:@"#3B7BEF"];
        self.MontyView3.backgroundColor = [UIColor colorWithHexString:@"#EB64FF"];
        self.MontyView4.backgroundColor = [UIColor colorWithHexString:@"#FFAF3C"];
        self.MontyView5.backgroundColor = [UIColor colorWithHexString:@"#14DFFF"];
        self.MontyView6.backgroundColor = [UIColor colorWithHexString:@"#3CAFFF"];
        self.MontyView7.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.MontyLabel2.text = MoneyList[0];
        self.MontyLabel3.text = MoneyList[1];
        self.MontyLabel4.text = MoneyList[2];
        self.MontyLabel5.text = MoneyList[3];
        self.MontyLabel6.text = MoneyList[4];
        self.MontyLabel7.text = @"";
        
        colorArr = @[[UIColor colorWithHexString:@"#3B7BEF"],
                     [UIColor colorWithHexString:@"#EB64FF"],
                     [UIColor colorWithHexString:@"#FFAF3C"],
                     [UIColor colorWithHexString:@"#14DFFF"],
                     [UIColor colorWithHexString:@"#3CAFFF"]];
    }else{
        self.MontyTitleLabel2.text = @"企业底薪(元)";
        self.MontyTitleLabel3.text = @"加班工资(元)";
        self.MontyTitleLabel4.text = @"请假总计(元)";
        self.MontyTitleLabel5.text = @"补贴总计(元)";
        self.MontyTitleLabel6.text = @"扣款总计(元)";
        self.MontyTitleLabel7.text = @"其他总计(元)";
        
        self.MontyView2.backgroundColor = [UIColor colorWithHexString:@"#3B7BEF"];
        self.MontyView3.backgroundColor = [UIColor colorWithHexString:@"#EB64FF"];
        self.MontyView4.backgroundColor = [UIColor colorWithHexString:@"#FF6060"];
        self.MontyView5.backgroundColor = [UIColor colorWithHexString:@"#FFAF3C"];
        self.MontyView6.backgroundColor = [UIColor colorWithHexString:@"#14E0FF"];
        self.MontyView7.backgroundColor = [UIColor colorWithHexString:@"#3CAFFF"];
        
        self.MontyLabel2.text = MoneyList[0];
        self.MontyLabel3.text = MoneyList[1];
        self.MontyLabel4.text = MoneyList[2];
        self.MontyLabel5.text = MoneyList[3];
        self.MontyLabel6.text = MoneyList[4];
        self.MontyLabel7.text = MoneyList[5];
        
        colorArr = @[[UIColor colorWithHexString:@"#3B7BEF"],
                      [UIColor colorWithHexString:@"#EB64FF"],
                      [UIColor colorWithHexString:@"#FF6060"],
                      [UIColor colorWithHexString:@"#FFAF3C"],
                      [UIColor colorWithHexString:@"#14E0FF"],
                      [UIColor colorWithHexString:@"#3CAFFF"]];
    }
    


    self.colorView.backgroundColor = [UIColor baseColor];
    self.typeTitleLabel.text = @"";
 

 
     self.pie.valueArr = MoneyList;
 
    self.pie.colorArr = [colorArr copy];
    
    
    CGFloat h = 24*self.workTypeArray.count+30 + 50;
    if (h < 170) {
        h = 170;
    }
    self.view_constrait_height.constant = h;
    self.pie.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    [self.pie showAnimation];

}

-(void)setModel:(LPSelectWorkhourModel *)model{
//    if ([self.model.mj_JSONString isEqualToString:model.mj_JSONString]) {
//        return;
//    }

    _model = model;
    if (self.index == 0) {
        self.colorView.backgroundColor = [UIColor baseColor];
        self.typeTitleLabel.text = @"";
        
        NSMutableArray *hourArray = [NSMutableArray array];
        NSMutableArray *ColorArray = [NSMutableArray array];

        NSArray *colorArr = @[[UIColor colorWithHexString:@"#3B7BEF"],
                                [UIColor colorWithHexString:@"#EB64FF"],
                                [UIColor colorWithHexString:@"#FF6060"],
                                [UIColor colorWithHexString:@"#FFAF3C"],
                                [UIColor colorWithHexString:@"#14E0FF"],
                                [UIColor colorWithHexString:@"#3CAFFF"]];
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

//        self.pie.valueArr = [hourArray copy];
        self.pie.valueArr = @[@"2200.00",@"1800.00",@"600.00",@"200.00",@"100.00",@"200.00"];
        self.pie.descArr = self.workTypeArray;
    
        self.pie.colorArr = [colorArr copy];


        CGFloat h = 24*self.workTypeArray.count+30 + 50;
        if (h < 170) {
            h = 170;
        }
        self.view_constrait_height.constant = h;
        self.pie.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
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
        self.pie.frame = CGRectMake(0, 0, 107/320*SCREEN_WIDTH+26, 215);
        self.pie.showDescripotion = NO;
    }

    
    [self.pie showAnimation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
