//
//  LPTypeWorkHourCell.m
//  BlueHired
//
//  Created by iMac on 2019/2/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPTypeWorkHourCell.h"
@interface LPTypeWorkHourCell()

@end
@implementation LPTypeWorkHourCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self addShadowToView:self.BackBGView withColor:[UIColor colorWithHexString:@"#12598B"]];
}


/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 4;
    theView.layer.masksToBounds = NO;
    
}

- (void)setCount:(NSInteger)count{
    
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (self.ArrowsBt.selected) {
        UIView *TopLineView;
        for (int i = 0; i <count; i++) {
            UIView *lineV = [[UIView alloc] init];
            [self.SubBGView addSubview:lineV];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make){
                if (i == 0) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                }else{
                    make.top.equalTo(TopLineView.mas_bottom).offset(48);
                    make.left.mas_equalTo(33);
                }
                make.right.mas_equalTo(0);
                make.width.mas_equalTo(1);
            }];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
            
            UILabel *SubTypeLabel = [[UILabel alloc] init];
            [self.SubBGView addSubview:SubTypeLabel];
            [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.left.mas_equalTo(33);
                make.height.mas_equalTo(48);
            }];
            SubTypeLabel.font = [UIFont systemFontOfSize:14];
            SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            SubTypeLabel.text  = [NSString stringWithFormat:@"%d,调休",i];
            
            UILabel *SubMoneyLabel = [[UILabel alloc] init];
            [self.SubBGView addSubview:SubMoneyLabel];
            [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.right.mas_equalTo(-32);
                make.height.mas_equalTo(48);
            }];
            SubMoneyLabel.font = [UIFont systemFontOfSize:14];
            SubMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            SubMoneyLabel.text  = [NSString stringWithFormat:@"%d",i*100];
            
            UIImageView *SubimageView = [[UIImageView alloc] init];
            [self.SubBGView addSubview:SubimageView];
            [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.right.mas_equalTo(-11);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(48);
            }];
            SubimageView.contentMode = UIViewContentModeScaleAspectFit;
            SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
            
            UIButton *TouchBt = [[UIButton alloc] init];
            [self.SubBGView addSubview:TouchBt];
            [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(48);
            }];
            TouchBt.tag = 1000+i;
            [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            TopLineView = lineV;
        }
        self.view_constrait_height.constant = 48+48*count;
        self.Subview_constrait_height.constant =48*count;

    }else{
        self.view_constrait_height.constant = 48;
        self.Subview_constrait_height.constant =0;
    }

}


//加班时间
- (void)setOvertimeModel:(NSArray<LPHoursWorkListOverTimeModel *> *)overtimeModel{
    _overtimeModel = overtimeModel;
    self.AllArrowsBt.enabled = NO;
    
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    if (self.ArrowsBt.selected) {
    
    if (self.WorkHourType == 2) {
        UIView *TopLineView;
        for (int i = 0; i <overtimeModel.count+1; i++) {
            
            
            
            UIView *lineV = [[UIView alloc] init];
            [self.SubBGView addSubview:lineV];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make){
                if (i == 0) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                }else{
                    make.top.equalTo(TopLineView.mas_bottom).offset(48);
                    make.left.mas_equalTo(33);
                }
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
            
            UILabel *SubTypeLabel = [[UILabel alloc] init];
            [self.SubBGView addSubview:SubTypeLabel];
            [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.left.mas_equalTo(33);
                make.height.mas_equalTo(48);
            }];
            SubTypeLabel.font = [UIFont systemFontOfSize:14];
            SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            
            
            UILabel *SubMoneyLabel = [[UILabel alloc] init];
            [self.SubBGView addSubview:SubMoneyLabel];
            [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.right.mas_equalTo(-13);
                make.height.mas_equalTo(48);
            }];
            SubMoneyLabel.font = [UIFont systemFontOfSize:14];
            SubMoneyLabel.textColor = [UIColor baseColor];
            
            if (i ==0) {
                SubTypeLabel.text  = @"工作总时长";
                if (self.overtimeModel.count) {
                    SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f小时",self.overtimeModel[0].workHours.floatValue];
                }
            }else{
                LPHoursWorkListOverTimeModel *m = overtimeModel[i-1];
                SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue];
                SubTypeLabel.text  = m.mulName;
            }
            
            
            UIImageView *SubimageView = [[UIImageView alloc] init];
            [self.SubBGView addSubview:SubimageView];
            [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.right.mas_equalTo(-11);
                make.width.mas_equalTo(0);
                make.height.mas_equalTo(48);
            }];
            SubimageView.contentMode = UIViewContentModeScaleAspectFit;
            SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
            
            //            UIButton *TouchBt = [[UIButton alloc] init];
            //            [self.SubBGView addSubview:TouchBt];
            //            [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
            //                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            //                make.right.mas_equalTo(0);
            //                make.left.mas_equalTo(0);
            //                make.height.mas_equalTo(48);
            //            }];
            //            TouchBt.tag = 1000+i;
            //            [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            TopLineView = lineV;
        }
        self.view_constrait_height.constant = 48+48*overtimeModel.count;
        self.Subview_constrait_height.constant =48*overtimeModel.count;
    }else{
        UIView *TopLineView;
        for (int i = 0; i <overtimeModel.count; i++) {
            LPHoursWorkListOverTimeModel *m = overtimeModel[i];
            UIView *lineV = [[UIView alloc] init];
            [self.SubBGView addSubview:lineV];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make){
                if (i == 0) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                }else{
                    make.top.equalTo(TopLineView.mas_bottom).offset(48);
                    make.left.mas_equalTo(33);
                }
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
            
            UILabel *SubTypeLabel = [[UILabel alloc] init];
            [self.SubBGView addSubview:SubTypeLabel];
            [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.left.mas_equalTo(33);
                make.height.mas_equalTo(48);
            }];
            SubTypeLabel.font = [UIFont systemFontOfSize:14];
            SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
 
            SubTypeLabel.text  = m.mulName;
            
            
            UILabel *SubMoneyLabel = [[UILabel alloc] init];
            [self.SubBGView addSubview:SubMoneyLabel];
            [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.right.mas_equalTo(-13);
                make.height.mas_equalTo(48);
            }];
            SubMoneyLabel.font = [UIFont systemFontOfSize:14];
            SubMoneyLabel.textColor = [UIColor baseColor];
            SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue];
            
            UIImageView *SubimageView = [[UIImageView alloc] init];
            [self.SubBGView addSubview:SubimageView];
            [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(lineV.mas_bottom).offset(0);
                make.right.mas_equalTo(-11);
                make.width.mas_equalTo(0);
                make.height.mas_equalTo(48);
            }];
            SubimageView.contentMode = UIViewContentModeScaleAspectFit;
            SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
            
            TopLineView = lineV;
        }
        self.view_constrait_height.constant = 48+48*overtimeModel.count;
        self.Subview_constrait_height.constant =48*overtimeModel.count;
    }
    
    
        
//    }else{
//        self.view_constrait_height.constant = 48;
//        self.Subview_constrait_height.constant =0;
//    }
    
    
    
}

- (void)setLeaveeModel:(NSArray<LPHoursWorkListLeaveModel *> *)leaveeModel{
    _leaveeModel = leaveeModel;
    self.AllArrowsBt.enabled = NO;

    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
    NSInteger Count = leaveeModel.count>5?5:leaveeModel.count;
    
    CGFloat LeaveNum = 0.0;
    if (self.WorkHourType == 3) {
        Count = leaveeModel.count+1;
        for (LPHoursWorkListLeaveModel *m in leaveeModel) {
            LeaveNum += m.hours.floatValue;
        }
    }
    
    UIView *TopLineView;
    for (int i = 0; i <Count; i++) {
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//        if (m.leaveType.integerValue == 0) {
//            SubTypeLabel.text  = [NSString stringWithFormat:@"带薪休假"];
//        }else if (m.leaveType.integerValue == 1){
//            SubTypeLabel.text  = [NSString stringWithFormat:@"事假"];
//        }else if (m.leaveType.integerValue == 2){
//            SubTypeLabel.text  = [NSString stringWithFormat:@"病假"];
//        }else if (m.leaveType.integerValue == 3){
//            SubTypeLabel.text  = [NSString stringWithFormat:@"调休"];
//        }else if (m.leaveType.integerValue == 4){
//            SubTypeLabel.text  = [NSString stringWithFormat:@"其他"];
//        }
        

        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor baseColor];
        
        if (self.WorkHourType == 3) {
            if (i ==0) {
                SubTypeLabel.text  = @"工作总时长";
                SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f小时",LeaveNum];
            }else{
                LPHoursWorkListLeaveModel *m = leaveeModel[i-1];
                SubTypeLabel.text  = [NSString stringWithFormat:@"%.2f元/小时",m.leaveMoney.floatValue];
                SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue];
            }
        }else{
            LPHoursWorkListLeaveModel *m = leaveeModel[i];

            SubTypeLabel.text  = [NSString stringWithFormat:@"%@",m.time];
            SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue];
        }
        
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
//        UIButton *TouchBt = [[UIButton alloc] init];
//        [self.SubBGView addSubview:TouchBt];
//        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
//            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
//            make.right.mas_equalTo(0);
//            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(48);
//        }];
//        TouchBt.tag = 1000+i;
//        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    self.view_constrait_height.constant = 48+48*Count;
    self.Subview_constrait_height.constant =48*Count;
}

- (void)setShiftModel:(NSArray<LPHoursWorkListShiftModel *> *)shiftModel{
    _shiftModel = shiftModel;
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.AllArrowsBt.enabled = NO;

    UIView *TopLineView;
    for (int i = 0; i <6; i++) {
//        LPHoursWorkListShiftModel *m = shiftModel[i];
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        if (i == 0){
            SubTypeLabel.text  = [NSString stringWithFormat:@"白班"];
        }else if (i == 1){
            SubTypeLabel.text  = [NSString stringWithFormat:@"夜班"];
        }else if (i == 2){
            SubTypeLabel.text  = [NSString stringWithFormat:@"早班"];
        }else if (i == 3){
            SubTypeLabel.text  = [NSString stringWithFormat:@"中班"];
        }else if (i == 4){
            SubTypeLabel.text  = [NSString stringWithFormat:@"晚班"];
        }else if (i == 5){
            SubTypeLabel.text  = [NSString stringWithFormat:@"休息"];
        }
        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor baseColor];
        SubMoneyLabel.text  =  @"0天" ;
        for (LPHoursWorkListShiftModel *m in shiftModel) {
            if (m.shift.integerValue == i+1) {
                SubMoneyLabel.text  = [NSString stringWithFormat:@"%ld天",(long)m.hours.integerValue];
                break;
            }
        }
        
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
//        UIButton *TouchBt = [[UIButton alloc] init];
//        [self.SubBGView addSubview:TouchBt];
//        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
//            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
//            make.right.mas_equalTo(0);
//            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(48);
//        }];
//        TouchBt.tag = 1000+i;
//        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    self.view_constrait_height.constant = 48+48*shiftModel.count;
    self.Subview_constrait_height.constant =48*shiftModel.count;
}

- (void)setBasicsArray:(NSArray *)basicsArray{
    _basicsArray = basicsArray;
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
    UIView *TopLineView;
    for (int i = 0; i <basicsArray.count; i++) {
        NSString *m = basicsArray[i];
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        
        if (self.WorkHourType == 3) {
            SubTypeLabel.text = @"工作工资";
        }else if (self.WorkHourType == 4){
            SubTypeLabel.text  = i== 0?@"企业底薪":@"计件工资";
        } else {
            SubTypeLabel.text  = i== 0?@"企业底薪":@"加班工资";
        }
 
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-34);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor blackColor];
        SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f",m.floatValue];
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
        UIButton *TouchBt = [[UIButton alloc] init];
        [self.SubBGView addSubview:TouchBt];
        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        TouchBt.tag = 1000+i;
        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    
    if (self.SuperWageDetailsModel.data.IsShow1) {
        self.view_constrait_height.constant = 48+48*basicsArray.count;
        self.Subview_constrait_height.constant =48*basicsArray.count;
    }else{
        self.view_constrait_height.constant = 48;
        self.Subview_constrait_height.constant =0;
    }
    

}

- (void)setWageLeaveModel:(NSArray<LPMonthWageDetailsDataleaveListModel *> *)WageLeaveModel{
    _WageLeaveModel = WageLeaveModel;
    
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger Count = WageLeaveModel.count>3?3:WageLeaveModel.count;

    UIView *TopLineView;
    for (int i = 0; i <Count; i++) {
        LPMonthWageDetailsDataleaveListModel *m = WageLeaveModel[i];
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        
        SubTypeLabel.text  = m.time;
        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-34);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor blackColor];
        SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f",m.leaveMoneyTotal.floatValue];
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
        UIButton *TouchBt = [[UIButton alloc] init];
        [self.SubBGView addSubview:TouchBt];
        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        TouchBt.tag = 1000+i;
        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    
    UIView *lineV = [[UIView alloc] init];
    [self.SubBGView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(TopLineView.mas_bottom).offset(48);
        make.bottom.mas_equalTo(-48);
        make.left.mas_equalTo(33);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    
    UIButton *DetailsButton = [[UIButton alloc] init];
    [self.SubBGView addSubview:DetailsButton];
    [DetailsButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lineV.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    [DetailsButton setTitle:Count?@"查看更多":@"暂无请假记录" forState:UIControlStateNormal];
    [DetailsButton setTitleColor:Count?[UIColor baseColor]:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    DetailsButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    if (Count) {
        [DetailsButton addTarget:self action:@selector(TouchAllBt:) forControlEvents:UIControlEventTouchUpInside];
    }
 
    
    if (self.SuperWageDetailsModel.data.IsShow2) {
        if (WageLeaveModel.count<=3 && WageLeaveModel.count>0 ) {
            DetailsButton.hidden = YES;
            lineV.hidden = YES;
            self.view_constrait_height.constant = 48+48*Count;
            self.Subview_constrait_height.constant =48*Count;
        }else{
            self.view_constrait_height.constant = 48+48*Count+48;
            self.Subview_constrait_height.constant =48*Count+48;
            DetailsButton.hidden = NO;
            lineV.hidden = NO;

        }
    }else{
        self.view_constrait_height.constant = 48;
        self.Subview_constrait_height.constant =0;
    }
    
}


- (void)setWageSubSidy:(NSString *)WageSubSidy{
    _WageSubSidy = WageSubSidy;
    
    NSArray *WageSubSidyArr = @[];
    
    if (WageSubSidy.length>0) {
        WageSubSidyArr = [WageSubSidy componentsSeparatedByString:@","];
    }
    
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
    UIView *TopLineView;
    for (int i = 0; i <WageSubSidyArr.count; i++) {
        NSString *m = WageSubSidyArr[i];
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        
        SubTypeLabel.text  = [m componentsSeparatedByString:@"-"][0];
        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-34);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor blackColor];
        SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f",[m componentsSeparatedByString:@"-"][1].floatValue];
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
        UIButton *TouchBt = [[UIButton alloc] init];
        [self.SubBGView addSubview:TouchBt];
        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        TouchBt.tag = 1000+i;
        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    
    UIView *lineV = [[UIView alloc] init];
    [self.SubBGView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(-48);
        make.left.mas_equalTo(33);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    
    UIButton *DetailsButton = [[UIButton alloc] init];
    [self.SubBGView addSubview:DetailsButton];
    [DetailsButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lineV.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    [DetailsButton setTitle:@"添加补贴记录" forState:UIControlStateNormal];
    [DetailsButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    DetailsButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [DetailsButton addTarget:self action:@selector(TouchAllBt:) forControlEvents:UIControlEventTouchUpInside];

    if (self.SuperWageDetailsModel.data.IsShow3) {
        self.view_constrait_height.constant = 48+48*WageSubSidyArr.count+48;
        self.Subview_constrait_height.constant =48*WageSubSidyArr.count+48;
    }else{
        self.view_constrait_height.constant = 48;
        self.Subview_constrait_height.constant =0;
    }
 
}



- (void)setWageDuduct:(NSString *)WageDuduct{
    _WageDuduct = WageDuduct;
    NSArray *WageDuductArr =@[];
    if (WageDuduct.length>0) {
        WageDuductArr = [WageDuduct componentsSeparatedByString:@","];
    }
    
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *TopLineView;
    for (int i = 0; i <WageDuductArr.count; i++) {
        NSString *m = WageDuductArr[i];
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        
        SubTypeLabel.text  = [m componentsSeparatedByString:@"-"][0];
        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-34);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor blackColor];
        SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f",[m componentsSeparatedByString:@"-"][1].floatValue];
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
        UIButton *TouchBt = [[UIButton alloc] init];
        [self.SubBGView addSubview:TouchBt];
        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        TouchBt.tag = 1000+i;
        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    
    UIView *lineV = [[UIView alloc] init];
    [self.SubBGView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(-48);
        make.left.mas_equalTo(33);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    
    UIButton *DetailsButton = [[UIButton alloc] init];
    [self.SubBGView addSubview:DetailsButton];
    [DetailsButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lineV.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    [DetailsButton setTitle:@"添加扣款记录" forState:UIControlStateNormal];
    [DetailsButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    DetailsButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [DetailsButton addTarget:self action:@selector(TouchAllBt:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.SuperWageDetailsModel.data.IsShow4) {
        self.view_constrait_height.constant = 48+48*WageDuductArr.count+48;
        self.Subview_constrait_height.constant =48*WageDuductArr.count+48;
    }else{
        self.view_constrait_height.constant = 48;
        self.Subview_constrait_height.constant =0;
    }
    

}


- (void)setWageOther:(NSArray *)WageOther{
    _WageOther = WageOther;
 
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *NameArr = @[@"社保",@"公积金",@"个人所得税"];
    
    UIView *TopLineView;
    for (int i = 0; i <WageOther.count; i++) {
        NSString *m = WageOther[i];
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        
        SubTypeLabel.text  = NameArr[i];
        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-34);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor blackColor];
        SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f",m.floatValue];
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
        UIButton *TouchBt = [[UIButton alloc] init];
        [self.SubBGView addSubview:TouchBt];
        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        TouchBt.tag = 1000+i;
        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    
//    UIButton *DetailsButton = [[UIButton alloc] init];
//    [self.BackBGView addSubview:DetailsButton];
//    [DetailsButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(self.SubBGView.mas_bottom).offset(0);
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(48);
//    }];
//    [DetailsButton setTitle:@"添加扣款记录" forState:UIControlStateNormal];
//    [DetailsButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
//    DetailsButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    if (self.SuperWageDetailsModel.data.IsShow5) {
        self.view_constrait_height.constant = 48+48*WageOther.count;
        self.Subview_constrait_height.constant =48*WageOther.count;
    }else{
        self.view_constrait_height.constant = 48;
        self.Subview_constrait_height.constant =0;
    }
}

-(void)TouchAllBt:(UIButton *)sender{
    if (self.AllBlock) {
        self.AllBlock();
    }
}

-(void)SubTouch:(UIButton *)sender{
    NSLog(@"点击第%ld行",(long)sender.tag);
    if (self.block) {
        self.block(sender.tag-1000);
    }
}
- (void)setSuperWageDetailsModel:(LPMonthWageDetailsModel *)SuperWageDetailsModel
{
    _SuperWageDetailsModel = SuperWageDetailsModel;
    if (self.section == 1) {
        self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow1;
    }else if (self.section == 2){
        self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow2;
    }else if (self.section == 3){
        self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow3;
    }else if (self.section == 4){
        self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow4;
    }else if (self.section == 5){
        self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow5;
    }
    
}

- (IBAction)CellTouchSelect:(id)sender {
    if (self.sectionType == 0) {
        
        if (self.section == 1) {
            self.SuperWageDetailsModel.data.IsShow1 = !self.SuperWageDetailsModel.data.IsShow1;
            self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow1;
        }else if (self.section == 2){
            self.SuperWageDetailsModel.data.IsShow2 = !self.SuperWageDetailsModel.data.IsShow2;
            self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow2;
        }else if (self.section == 3){
            self.SuperWageDetailsModel.data.IsShow3 = !self.SuperWageDetailsModel.data.IsShow3;
            self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow3;
        }else if (self.section == 4){
            self.SuperWageDetailsModel.data.IsShow4 = !self.SuperWageDetailsModel.data.IsShow4;
            self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow4;
        }else if (self.section == 5){
            self.SuperWageDetailsModel.data.IsShow5 = !self.SuperWageDetailsModel.data.IsShow5;
            self.ArrowsBt.selected = self.SuperWageDetailsModel.data.IsShow5;
        }
        
        if (self.Rowblock) {
            self.Rowblock(self.ArrowsBt.selected);
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
