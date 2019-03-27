//
//  LPRecardWorkHourView.m
//  BlueHired
//
//  Created by iMac on 2019/2/22.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRecardWorkHourView.h"
#import "LPDurationView.h"
#import "LPYsetMulListModel.h"
#import "LPLabourCostModel.h"

static NSString *TEXT = @"来点工作备注吧，最多填写30字！";
static NSString *TEXT2 = @"可以备注您请假的原因，最多30字!";

@interface LPRecardWorkHourView()<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *selectView;

@property(nonatomic,strong) LPYsetMulListModel *YsetModel;
@property (nonatomic, strong) LPLabourCostModel *model;

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UIView *KeyBoardView;

@property(nonatomic,strong) UITextView *KeyBoardText;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,assign) CGFloat transformY;
@property(nonatomic,strong) LPDurationView *durationView;
@property(nonatomic,strong) NSArray *workTypeArray;
@property(nonatomic,strong) NSArray *SalaryArray;

//加班控件
@property(nonatomic,strong) UILabel *OverTimeLabel;     //加班时间标题
@property(nonatomic,strong) UILabel *OverTimeContent;     //加班时间
@property(nonatomic,strong) UIButton *OverButton;     //加班按钮
@property(nonatomic,strong) UIButton *LeaveButton;     //请假按钮
@property(nonatomic,strong) UIView *overLineV;     //加班下划线
@property(nonatomic,strong) UIView *overLineV2;     //加班下划线
@property(nonatomic,strong) UIDatePicker *datePicker;     //时间选择器
@property(nonatomic,strong) UILabel *OverTypeLabel;     //加班班次
@property(nonatomic,strong) UIButton *OverTypeButton;     //加班班次
@property(nonatomic,strong) UILabel *SalaryLabel;     //加班工资倍数
@property(nonatomic,strong) UIImageView *SalaryImage; //加班工资iamge
@property(nonatomic,strong) UIButton *SalaryButton;     //加班工资倍数
@property(nonatomic,strong) UITextField *SalaryTF;     //加班输入框

@property(nonatomic,strong) UILabel *HourMoney;     //小时工单价
@property(nonatomic,strong) UILabel *HourLabel;     //小时工标题

@property(nonatomic,strong) UITextField *LeaveTextField; //请假输入框

@property(nonatomic,strong) UIView *lineView3;


@property (nonatomic,strong) UIView *ToolTextView;

@property (nonatomic,assign) BOOL isTopShow;
@property (nonatomic,assign) BOOL isTopShow2;

@property (nonatomic,strong) LPOverTimeAccountDataRecordListModel *SalaryModel;
@property (nonatomic,strong) LPOverTimeAccountDataRecordListModel *LeaveModel;


@end

@implementation LPRecardWorkHourView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.isTopShow = NO;
        self.isTopShow2 = NO;
        [self KeyBoardView];
        [self setTextFieldView];
        self.workTypeArray = @[@"白班",@"夜班",@"早班",@"中班",@"晚班",@"休息"];
        self.SalaryArray = @[];
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];

    }
    return self;
}


#pragma mark - 输入框编辑view
-(void)setTextFieldView{
    //输入框编辑view
    UIView *ToolTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.ToolTextView = ToolTextView;
    ToolTextView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    UIButton *DoneBt = [[UIButton alloc] init];
    [ToolTextView addSubview:DoneBt];
    [DoneBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [DoneBt setTitle:@"确定" forState:UIControlStateNormal];
    [DoneBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    DoneBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    DoneBt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [DoneBt addTarget:self action:@selector(TouchTextDone:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *CancelBt = [[UIButton alloc] init];
    [ToolTextView addSubview:CancelBt];
    [CancelBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.equalTo(DoneBt.mas_left).offset(0);
        make.width.equalTo(DoneBt.mas_width);
    }];
    [CancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [CancelBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CancelBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CancelBt.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [CancelBt addTarget:self action:@selector(TouchTextCancel:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)TouchTextDone:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)TouchTextCancel:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark - Touch

-(void)TouchOverButton:(UIButton *)sender{      //加班
    if (![sender.currentTitleColor isEqual:[UIColor baseColor]]) {
        
       
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

        self.overLineV.hidden = NO;
        self.overLineV2.hidden = YES;
      
        [self.OverButton setTitle:self.WorkHourType==1?@"加班":@"工时" forState:UIControlStateNormal];
        [self.OverButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [self.LeaveButton setTitleColor:[UIColor colorWithHexString:@"#444444"] forState:UIControlStateNormal];
        self.OverTimeLabel.text = @"加班时间:";
        self.OverTypeLabel.text = @"加班班次";
        self.SalaryLabel.text = @"加班工资倍数";
        [self.SalaryLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo([self calculateRowWidth:self.SalaryLabel.text]);
        }];
 
        self.titleLabel.text = [NSString stringWithFormat:@"%@·%@",self.currentDateString,[NSString weekdayStringFromDate:self.currentDateString]];

        self.OverTimeContent.text = [NSString stringWithFormat:@"01时00分"];
        NSDate* Date = [NSString dateFromString:@"1900-01-01 01:00:00"];
        self.datePicker.date = Date;
        [self.OverTypeButton setTitle:@"" forState:UIControlStateNormal];
        if (_YsetModel.data.count) {
            [self.SalaryButton setTitle:[NSString stringWithFormat:@"%.2f倍(%.2f元/小时)",_YsetModel.data[0].overtimeMultiples.floatValue, _YsetModel.data[0].overtime.floatValue] forState:UIControlStateNormal];
        }else{
            [self.SalaryButton setTitle:@"" forState:UIControlStateNormal];
        }
        self.OverTypeButton.tag = 0;
        self.SalaryButton.tag = 0;
        
        self.LeaveTextField.hidden = YES;
        self.OverTypeButton.hidden = NO;
        _selectView.lx_height = 453;
        _selectView.lx_y = SCREEN_HEIGHT - 453;
 
        [self.SalaryLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(40);
        }];
        [self.SalaryImage mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(13);
        }];
        [self.SalaryButton mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(40);
        }];
        [self.SalaryTF mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(40);
        }];
        [self.lineView3 mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(1);
        }];
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.text = TEXT;
        
        if (self.WorkHourType == 2) {
            self.SalaryButton.hidden = YES;
            self.SalaryTF.hidden = NO;
            self.SalaryLabel.text = @"本月设定的工作小时数";
            self.OverTimeLabel.text = @"工作时间:";
            self.OverTypeLabel.text = @"工作班次";
            [self.SalaryLabel mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_equalTo([self calculateRowWidth:self.SalaryLabel.text]);
            }];
            [self.SalaryImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(15);
            }];
            self.SalaryImage.image = [UIImage imageNamed:@"WorkHourRedactimage"];
            self.HourLabel.hidden = YES;
            self.HourMoney.hidden = YES;
            self.OverButton.hidden = NO;
            self.LeaveButton.hidden = NO;
        }else if (self.WorkHourType == 3){
            self.SalaryButton.hidden = NO;
            self.OverButton.hidden = YES;
            self.LeaveButton.hidden = YES;
            self.overLineV.hidden = YES;

            self.SalaryTF.hidden = YES;
            self.HourLabel.hidden = NO;
            self.HourMoney.hidden = NO;
            self.OverTimeLabel.text = @"工作时间:";
            self.OverTypeLabel.text = @"工作班次";
            self.SalaryLabel.text = @"工价";
            [self.SalaryLabel mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_equalTo([self calculateRowWidth:self.SalaryLabel.text]);
            }];

            [self.SalaryImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(12);
            }];
            self.SalaryImage.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
            
        } else{
            self.SalaryButton.hidden = NO;
            self.SalaryLabel.text = @"加班工资倍数";
            [self.SalaryLabel mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_equalTo([self calculateRowWidth:self.SalaryLabel.text]);
            }];

            self.SalaryTF.hidden = YES;
            [self.SalaryImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(12);
            }];
            self.SalaryImage.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
            self.HourLabel.hidden = YES;
            self.HourMoney.hidden = YES;
            self.OverButton.hidden = NO;
            self.LeaveButton.hidden = NO;
        }
        
        
        
        if (self.isTopShow) {
            LPOverTimeAccountDataRecordListModel *m = self.SalaryModel;
            if (m.leaveTime.integerValue == 0) {
                self.OverTimeContent.text = [NSString stringWithFormat:@"01时00分"];
                NSDate* Date = [NSString dateFromString:@"1900-01-01 01:00:00"];
                self.datePicker.date = Date;
            }else{
                self.OverTimeContent.text = [NSString stringWithFormat:@"%ld时%ld分",m.leaveTime.integerValue/60,m.leaveTime.integerValue%60];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"HH时mm分"];
                //NSString转NSDate
                NSDate *date=[formatter dateFromString:self.OverTimeContent.text];
                self.datePicker.date = date;
            }

            if (m.shift.integerValue == 1) {
                [self.OverTypeButton setTitle:@"白班" forState:UIControlStateNormal];
            }else if (m.shift.integerValue == 2){
                [self.OverTypeButton setTitle:@"夜班" forState:UIControlStateNormal];
            }else if (m.shift.integerValue == 3){
                [self.OverTypeButton setTitle:@"早班" forState:UIControlStateNormal];
            }else if (m.shift.integerValue == 4){
                [self.OverTypeButton setTitle:@"中班" forState:UIControlStateNormal];
            }else if (m.shift.integerValue == 5){
                [self.OverTypeButton setTitle:@"晚班" forState:UIControlStateNormal];
            }else if (m.shift.integerValue == 6){
                [self.OverTypeButton setTitle:@"休息" forState:UIControlStateNormal];
            }
//            self.OverTypeButton.tag = m.shift.integerValue;
 
            if (m.moneyType && self.WorkHourType == 1) {
                [self.SalaryButton setTitle:[self.SalaryArray[m.moneyType.integerValue] substringFromIndex:3]   forState:UIControlStateNormal];
            }else{

            }
            
            if (m.remark.length>0) {
                self.textView.text = m.remark;
                self.textView.textColor = [UIColor blackColor];
            }else{
                self.textView.textColor = [UIColor lightGrayColor];
                self.textView.text = TEXT;
            }
            return;
        }else{
            self.isTopShow = YES;
        }
        
        
        
        self.SalaryTF.text = [NSString stringWithFormat:@"%ld",(long)self.monthHours.integerValue];

        for (LPOverTimeAccountDataRecordListModel *m in self.RecordModelList) {
            NSArray  *MulRoMoney = [m.mulAmount componentsSeparatedByString:@"#"];//分隔符逗号
            NSString *mulStr = MulRoMoney[0];
            NSString *MoneyStr = MulRoMoney[1];
            if (m.status.integerValue == 1) {       //加班
                self.SalaryModel = m;
                self.OverTimeContent.text = [NSString stringWithFormat:@"%ld时%ld分",m.leaveTime.integerValue/60,m.leaveTime.integerValue%60];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"HH时mm分"];
                //NSString转NSDate
                NSDate *date=[formatter dateFromString:self.OverTimeContent.text];
                self.datePicker.date = date;
                if (m.shift.integerValue == 1) {
                    [self.OverTypeButton setTitle:@"白班" forState:UIControlStateNormal];
                }else if (m.shift.integerValue == 2){
                    [self.OverTypeButton setTitle:@"夜班" forState:UIControlStateNormal];
                }else if (m.shift.integerValue == 3){
                    [self.OverTypeButton setTitle:@"早班" forState:UIControlStateNormal];
                }else if (m.shift.integerValue == 4){
                    [self.OverTypeButton setTitle:@"中班" forState:UIControlStateNormal];
                }else if (m.shift.integerValue == 5){
                    [self.OverTypeButton setTitle:@"晚班" forState:UIControlStateNormal];
                }else if (m.shift.integerValue == 6){
                    [self.OverTypeButton setTitle:@"休息" forState:UIControlStateNormal];
                }
                self.OverTypeButton.tag = m.shift.integerValue;
                
                if (self.WorkHourType == 2) {
//                    self.SalaryTF.text = reviseString(m.workHours);
                }else{
                    if (m.moneyType.integerValue == 0) {
                        NSString *SalaryStr = [NSString stringWithFormat:@"%.2f倍(%.2f元/小时)",mulStr.floatValue ,MoneyStr.floatValue ];
                        [self.SalaryButton setTitle:SalaryStr forState:UIControlStateNormal];
                    }else if (m.moneyType.integerValue == 1){
                        NSString *SalaryStr = [NSString stringWithFormat:@"%.2f倍(%.2f元/小时)",mulStr.floatValue ,MoneyStr.floatValue ];
                        [self.SalaryButton setTitle:SalaryStr forState:UIControlStateNormal];
                    }else if (m.moneyType.integerValue == 2){
                        NSString *SalaryStr = [NSString stringWithFormat:@"%.2f倍(%.2f元/小时)",mulStr.floatValue ,MoneyStr.floatValue ];
                        [self.SalaryButton setTitle:SalaryStr forState:UIControlStateNormal];
                    }
                    self.SalaryButton.tag = m.moneyType.integerValue;
                }

                if (m.remark.length>0) {
                    self.textView.text = m.remark;
                    self.textView.textColor = [UIColor blackColor];
                }else{
                    self.textView.textColor = [UIColor lightGrayColor];
                    self.textView.text = TEXT;
                }
                
            }
 
        }
        
        
//        if (!self.SalaryModel) {
//            self.SalaryModel = [[LPOverTimeAccountDataRecordListModel alloc] init];
//        }
        
    }
}

-(void)TouchLeaveButton:(UIButton *)sender{     //请假
    if (![sender.currentTitleColor isEqual:[UIColor baseColor]]) {

        self.overLineV.hidden = YES;
        self.overLineV2.hidden = NO;
        [self.LeaveButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [self.OverButton setTitleColor:[UIColor colorWithHexString:@"#444444"] forState:UIControlStateNormal];
        self.OverTimeLabel.text = @"请假时间:";
        self.OverTypeLabel.text = @"请假单价";
        self.SalaryLabel.text = @"请假类型";
        self.OverTimeContent.text = [NSString stringWithFormat:@"01时00分"];
        NSDate* Date = [NSString dateFromString:@"1900-01-01 01:00:00"];
        self.datePicker.date = Date;
        [self.OverTypeButton setTitle:@"" forState:UIControlStateNormal];
        [self.SalaryButton setTitle:@"" forState:UIControlStateNormal];
        self.LeaveTextField.text = @"";
        self.OverTypeButton.tag = 0;
        self.SalaryButton.tag = 0;
        self.LeaveTextField.hidden = NO;
        self.OverTypeButton.hidden = YES;
        _selectView.lx_height = 412;
        _selectView.lx_y = SCREEN_HEIGHT - 412;
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.text = TEXT2;
        [self.SalaryLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(0);
        }];
        [self.SalaryImage mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(0);
        }];
        [self.SalaryButton mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(0);
        }];
        [self.SalaryTF mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(0);
        }];
        [self.lineView3 mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(0);
        }];
        self.SalaryButton.hidden = YES;
        
        if (self.isTopShow2) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@·%@",self.currentDateString,[NSString weekdayStringFromDate:self.currentDateString]];
            
            if (self.LeaveModel.leaveTime == 0) {
                self.OverTimeContent.text = [NSString stringWithFormat:@"01时00分"];
                NSDate* Date = [NSString dateFromString:@"1900-01-01 01:00:00"];
                self.datePicker.date = Date;
            }else{
                self.OverTimeContent.text = [NSString stringWithFormat:@"%ld时%ld分",self.LeaveModel.leaveTime.integerValue/60,self.LeaveModel.leaveTime.integerValue%60];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"HH时mm分"];
                //NSString转NSDate
                NSDate *date=[formatter dateFromString:self.OverTimeContent.text];
                self.datePicker.date = date;
            }
            
            if (self.LeaveModel.leaveMoney) {
                self.LeaveTextField.text = reviseString(self.LeaveModel.leaveMoney);
            }else{
                self.LeaveTextField.text = @"";
            }
            
            
            if (self.LeaveModel.remark.length>0) {
                self.textView.text = self.LeaveModel.remark;
                self.textView.textColor = [UIColor blackColor];
            }else{
                self.textView.textColor = [UIColor lightGrayColor];
                self.textView.text = TEXT2;
            }
            return;
        }else{
            self.isTopShow2 = YES;
        }
        
        
        for (LPOverTimeAccountDataRecordListModel *m in self.RecordModelList) {
            NSArray  *MulRoMoney = [m.mulAmount componentsSeparatedByString:@"#"];//分隔符逗号
//            NSString *mulStr = MulRoMoney[0];
//            NSString *MoneyStr = MulRoMoney[1];
            if (m.status.integerValue == 2) {       //请假
                self.LeaveModel = m;
                self.titleLabel.text = [NSString stringWithFormat:@"%@·%@",self.currentDateString,[NSString weekdayStringFromDate:self.currentDateString]];
                self.OverTimeContent.text = [NSString stringWithFormat:@"%ld时%ld分",m.leaveTime.integerValue/60,m.leaveTime.integerValue%60];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"HH时mm分"];
                //NSString转NSDate
                NSDate *date=[formatter dateFromString:self.OverTimeContent.text];
                self.datePicker.date = date;
                self.LeaveTextField.text = reviseString(m.leaveMoney);
//                if (m.shift.integerValue == 1) {
//                    [self.OverTypeButton setTitle:@"白班" forState:UIControlStateNormal];
//                }else if (m.shift.integerValue == 2){
//                    [self.OverTypeButton setTitle:@"早班" forState:UIControlStateNormal];
//                }else if (m.shift.integerValue == 3){
//                    [self.OverTypeButton setTitle:@"中班" forState:UIControlStateNormal];
//                }else if (m.shift.integerValue == 4){
//                    [self.OverTypeButton setTitle:@"晚班" forState:UIControlStateNormal];
//                }else if (m.shift.integerValue == 5){
//                    [self.OverTypeButton setTitle:@"休息" forState:UIControlStateNormal];
//                }
//                self.OverTypeButton.tag = m.shift.integerValue;
//
//                if (m.leaveType.integerValue == 1) {
//                    [self.SalaryButton setTitle:@"带薪休假" forState:UIControlStateNormal];
//                }else if (m.leaveType.integerValue == 2){
//                    [self.SalaryButton setTitle:@"事假" forState:UIControlStateNormal];
//                }else if (m.leaveType.integerValue == 3){
//                    [self.SalaryButton setTitle:@"病假" forState:UIControlStateNormal];
//                }else if (m.leaveType.integerValue == 4){
//                    [self.SalaryButton setTitle:@"调休" forState:UIControlStateNormal];
//                }else if (m.leaveType.integerValue == 5){
//                    [self.SalaryButton setTitle:@"其他" forState:UIControlStateNormal];
//                }
//                self.SalaryButton.tag = m.leaveType.integerValue;

                
                if (m.remark.length>0) {
                    self.textView.text = m.remark;
                    self.textView.textColor = [UIColor blackColor];
                }else{
                    self.textView.textColor = [UIColor lightGrayColor];
                    self.textView.text = TEXT2;
                }
                
            }
            
        }
        
//        if (!self.LeaveModel) {
//            self.LeaveModel = [[LPOverTimeAccountDataRecordListModel alloc] init];
//        }
        
        
        
    }
}

-(void)OverTypeTouch{       //类型
    WEAK_SELF()
    if (self.WorkHourType == 3) {
        self.durationView.titleString = @"请选择工作班次";
    }else{
        self.durationView.titleString = @"请选择加班班次";
    }
    self.durationView.typeArray = self.workTypeArray;
    self.durationView.block = ^(NSInteger index) {
        weakSelf.OverTypeButton.tag = index+1;
        [weakSelf.OverTypeButton setTitle:weakSelf.workTypeArray[index] forState:UIControlStateNormal];
        if ([weakSelf.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {//加班
            weakSelf.SalaryModel.shift = [NSString stringWithFormat:@"%ld",(long)index+1];
        }
    };
    self.durationView.hidden = NO;
    
    
    

}

-(void)SalaryTouch{         //倍数
    WEAK_SELF()
    if ([self.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {      //加班
        self.durationView.titleString = self.WorkHourType ==1? @"请选择加班倍数":@"请选择工价";
        self.durationView.typeArray = self.SalaryArray;
        self.durationView.block = ^(NSInteger index) {
            weakSelf.SalaryButton.tag = index;
            if (self.WorkHourType == 3) {
                [weakSelf.SalaryButton setTitle:[NSString stringWithFormat:@"%.2f元/小时",weakSelf.model.data[index].priceMoney.floatValue] forState:UIControlStateNormal];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"HH";
                CGFloat Hours = [formatter  stringFromDate:weakSelf.datePicker.date].floatValue;
                formatter.dateFormat = @"mm";
                CGFloat mm = [formatter  stringFromDate:weakSelf.datePicker.date].floatValue;
                CGFloat money = weakSelf.model.data[weakSelf.SalaryButton.tag].priceMoney.floatValue;
                weakSelf.HourMoney.text = [NSString stringWithFormat:@"%.2f元",(Hours+mm/60)*money];
                [weakSelf.SalaryButton setTitle:weakSelf.SalaryArray[index] forState:UIControlStateNormal];
            }else{
                [weakSelf.SalaryButton setTitle:[weakSelf.SalaryArray[index] substringFromIndex:3]   forState:UIControlStateNormal];
            }
            if ([weakSelf.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {//加班
                weakSelf.SalaryModel.moneyType = [NSString stringWithFormat:@"%ld",(long)index];
            }
            
        };
        self.durationView.hidden = NO;
    }else{
        self.durationView.titleString = @"请选择请假类型";
        NSArray *Array = @[@"带薪休假",@"事假",@"病假",@"调休",@"其他"];
        self.durationView.typeArray = Array;
        self.durationView.block = ^(NSInteger index) {
            weakSelf.SalaryButton.tag = index;
            [weakSelf.SalaryButton setTitle:Array[index] forState:UIControlStateNormal];
        };
        self.durationView.hidden = NO;
    }


}

-(void)save{
   
    
    
   if ([self.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {      //加班
       if (self.WorkHourType == 2) {
           if (self.SalaryTF.text.floatValue==0.0) {
               [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"请选择本月工作小时数" time:2.0];
               return;
           }
       }else{
           if (self.SalaryButton.currentTitle.length==0) {
               [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"请选择加班工资倍数" time:2.0];
               return;
           }
       }

//       if (self.OverTypeButton.currentTitle.length==0) {
//           [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"请选择加班班次" time:2.0];
//           return;
//       }
   }else{
       if (self.LeaveTextField.text.floatValue==0.0) {
           [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"请输入请假单价" time:2.0];
            return;
       }
   }
    
    [self requestQueryGetOvertime];
    
}

-(void)hidden{
    self.hidden = YES;
}
- (void)dateChange:(UIDatePicker *)datePicker {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.datePicker.countDownDuration = 0;
//    });
    NSLog(@"滚动事件 = %@",datePicker.date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat = @"HH时mm分";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    self.OverTimeContent.text = dateStr;
    
    if ([dateStr isEqualToString:@"00时01分"]) {
        NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60*1 sinceDate:datePicker.date];//后一天
        [datePicker setDate:nextDay];
    }
    
    if (self.WorkHourType == 3) {
        formatter.dateFormat = @"HH";
        CGFloat Hours = [formatter  stringFromDate:datePicker.date].floatValue;
        formatter.dateFormat = @"mm";
        CGFloat mm = [formatter  stringFromDate:datePicker.date].floatValue;
        CGFloat money = self.model.data[self.SalaryButton.tag].priceMoney.floatValue;
        self.HourMoney.text = [NSString stringWithFormat:@"%.2f元",(Hours+mm/60)*money];
    }else if (self.WorkHourType == 1 ||self.WorkHourType == 2){
        formatter.dateFormat = @"HH";
        CGFloat Hours = [formatter  stringFromDate:datePicker.date].floatValue;
        formatter.dateFormat = @"mm";
        CGFloat mm = [formatter  stringFromDate:datePicker.date].floatValue;
        if ([self.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {//加班
            self.SalaryModel.leaveTime = [NSString stringWithFormat:@"%.0f",Hours*60+mm];
        }else{
            self.LeaveModel.leaveTime =[NSString stringWithFormat:@"%.0f",Hours*60+mm];
        }
    }
    
    
}

-(void)Keyhidden{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.KeyBoardText.text = @"";
}

-(void)Keysave{
    self.textView.textColor = [UIColor blackColor];
    self.textView.text = self.KeyBoardText.text;
    [self Keyhidden];
    if (self.WorkHourType == 1 || self.WorkHourType == 2) {
        if ([self.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {//加班
            self.SalaryModel.remark = self.textView.text;
        }else{
            self.LeaveModel.remark = self.textView.text;
        }
    }
    
    
}

-(void)setHidden:(BOOL)hidden{
    if (hidden) {
        if (self.transformY < 0) {
           [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetHeight(self.selectView.frame));
        } completion:^(BOOL finished) {
            self.bgView.hidden = YES;
            self.selectView.hidden = YES;
            self.isTopShow = NO;
            self.isTopShow2 = NO;
//            [self clear];
//            [self clearType];
        }];
    }else{
        self.bgView.hidden = NO;
        self.selectView.hidden = NO;
        self.LeaveModel = [[LPOverTimeAccountDataRecordListModel alloc] init];
        self.SalaryModel = [[LPOverTimeAccountDataRecordListModel alloc] init];

        
        [self.OverButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self TouchOverButton:self.OverButton];

        //判断是否加班还是请假
        if (self.RecordModelList.count == 1) {
            if (self.RecordModelList[0].status.integerValue == 2) {
                [self TouchLeaveButton:self.LeaveButton];
                self.isTopShow2 = YES;
            }else{
                [self TouchOverButton:self.OverButton];
                self.isTopShow = YES;
            }
        }else{
            [self TouchOverButton:self.OverButton];
            self.isTopShow = YES;
        }
        
        if (self.WorkHourType == 1) {
            [self requestQueryGetYsetMulList];
        }else if (self.WorkHourType == 3){
            [self requestQueryGetOvertimeAccount];
        }

        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT-CGRectGetHeight(self.selectView.frame), SCREEN_WIDTH, CGRectGetHeight(self.selectView.frame));
        }];
    }
}
#pragma mark - TextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([textView.textColor isEqual:[UIColor lightGrayColor]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        if ([self.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {      //加班
            textView.text = TEXT;
        }else{
            textView.text = TEXT2;
        }
        textView.textColor = [UIColor lightGrayColor];
    }
}

//当编辑时动态判断是否超过规定字数，这里限制30字
- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.KeyBoardText) {
//        if (textView.text.length > 30) {
//            textView.text = [textView.text substringToIndex:30];
//        }
        /**
         *  最大输入长度,中英文字符都按一个字符计算
         */
        static int kMaxLength = 30;
        
        NSString *toBeString = textView.text;
        // 获取键盘输入模式
        NSString *lang = [textView.textInputMode primaryLanguage];
        // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
        // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮选择部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > kMaxLength) {
                    // 截取子串
                    textView.text = [toBeString substringToIndex:kMaxLength];
                }
            } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        } else {
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
        }
      }

}

#pragma mark - tagter
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    //匹配以0开头的数字
    NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
    //匹配两位小数、整数
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7? YES : NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.LeaveTextField) {
        if (self.WorkHourType == 1 || self.WorkHourType == 2) {
                self.LeaveModel.leaveMoney = textField.text;
        }
    }
}

#pragma mark - lazy
- (void)setYsetModel:(LPYsetMulListModel *)YsetModel{
    _YsetModel = YsetModel;
    if (YsetModel.data.count) {
        self.SalaryArray = @[[NSString stringWithFormat:@"正常日%.2f倍(%.2f元/小时)",
                              YsetModel.data[0].overtimeMultiples.floatValue,YsetModel.data[0].overtime.floatValue ],
                             [NSString stringWithFormat:@"休息日%.2f倍(%.2f/小时)",
                              YsetModel.data[0].weekendOvertimeMultiples.floatValue,YsetModel.data[0].weekendOvertime.floatValue],
                             [NSString stringWithFormat:@"节假日%.2f倍(%.2f/小时)",
                              YsetModel.data[0].holidayOvertimeMultiples.floatValue,YsetModel.data[0].holidayOvertime.floatValue]];
        BOOL IsStatus = NO;
        for (LPOverTimeAccountDataRecordListModel *m in self.RecordModelList) {
             if (m.status.integerValue == 1) {       //加班
                 IsStatus = YES;
            }
        }
        if (IsStatus == NO) {
            if(YsetModel.data[0].mulType.integerValue == 0 ){
                [self.SalaryButton setTitle:[NSString stringWithFormat:@"%.2f倍(%.2f元/小时)",
                                             YsetModel.data[0].overtimeMultiples.floatValue,
                                             YsetModel.data[0].overtime.floatValue]
                                   forState:UIControlStateNormal];
            }else if (YsetModel.data[0].mulType.integerValue == 1) {
                [self.SalaryButton setTitle:[NSString stringWithFormat:@"%.2f倍(%.2f元/小时)",
                                             YsetModel.data[0].weekendOvertimeMultiples.floatValue,
                                             YsetModel.data[0].weekendOvertime.floatValue]
                                                              forState:UIControlStateNormal];

            }else if (YsetModel.data[0].mulType.integerValue == 2) {
                [self.SalaryButton setTitle:[NSString stringWithFormat:@"%.2f倍(%.2f元/小时)",
                                             YsetModel.data[0].holidayOvertimeMultiples.floatValue,
                                             YsetModel.data[0].holidayOvertime.floatValue]
                                                              forState:UIControlStateNormal];
            }
            self.SalaryButton.tag = YsetModel.data[0].mulType.integerValue;


        }
    }

}

- (void)setModel:(LPLabourCostModel *)model{
    _model = model;
    if (model.data.count) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (LPLabourCostDataModel *m in model.data) {
            [array addObject:[NSString stringWithFormat:@"%@  %.2f元/小时",m.priceName,m.priceMoney.floatValue]];
        }
        self.SalaryArray  = [array copy];
        [self.SalaryButton setTitle:[NSString stringWithFormat:@"%.2f元",model.data[0].priceMoney.floatValue] forState:UIControlStateNormal];
        self.SalaryButton.tag = 0;
        self.HourMoney.text = [NSString stringWithFormat:@"%.2f元",model.data[0].priceMoney.floatValue];
        
        for (LPOverTimeAccountDataRecordListModel *m in self.RecordModelList) {
            if (m.status.integerValue == 1) {       //加班
                for (int i =0 ;i <model.data.count ;i ++) {
                    LPLabourCostDataModel *CostModel = model.data[i];
                    if ([CostModel.priceMoney isEqualToString:m.leaveMoney]) {
                        [self.SalaryButton setTitle:[NSString stringWithFormat:@"%.2f元/小时",model.data[i].priceMoney.floatValue] forState:UIControlStateNormal];
                        self.SalaryButton.tag = i;
                        self.HourMoney.text = [NSString stringWithFormat:@"%.2f元",model.data[i].priceMoney.floatValue];
                        
                        break;
                    }
                }
            }
        }
        
    }
}


-(UIView *)KeyBoardView{
    if (!_KeyBoardView) {
        _KeyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 118)];
        
        _KeyBoardView.backgroundColor = [UIColor whiteColor];

        UIButton *cancelButton = [[UIButton alloc]init];
        [_KeyBoardView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(47);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(Keyhidden) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        
        UIButton *saveButton = [[UIButton alloc]init];
        [_KeyBoardView addSubview:saveButton];
        //        saveButton.frame = CGRectMake(SCREEN_WIDTH/2, 253-47, SCREEN_WIDTH/2, 47);
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(47);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        saveButton.backgroundColor = [UIColor whiteColor];
        [saveButton setTitle:@"确定" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [saveButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(Keysave) forControlEvents:UIControlEventTouchUpInside];
        saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        
        UITextView *textView = [[UITextView alloc] init];
        self.KeyBoardText = textView;
        [_KeyBoardView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(saveButton.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(60);
        }];
        textView.backgroundColor = [UIColor colorWithHexString:@"#FFF2F2F2"];
//        textView.textColor = [UIColor lightGrayColor];
//        textView.text = TEXT;
        textView.delegate = self;
//        textView.inputAccessoryView = _KeyBoardView;//键盘上加view
    }
    return _KeyBoardView;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 453)];
        _selectView.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc]init];
        [_selectView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        self.titleLabel.text = @"2018-07-04·周一";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
 
        //加班时间标题
        self.OverTimeLabel = [[UILabel alloc] init];
        [_selectView addSubview:self.OverTimeLabel];
        [self.OverTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        self.OverTimeLabel.text = @"加班时间:";
        self.OverTimeLabel.font = [UIFont systemFontOfSize:15];
        self.OverTimeLabel.textColor = [UIColor colorWithHexString:@"#929292"];
        
        //加班时间
        UILabel *OverTimeContent = [[UILabel alloc] init];
        self.OverTimeContent = OverTimeContent;
        [_selectView addSubview:OverTimeContent];
        [OverTimeContent mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.OverTimeLabel.mas_right).offset(6);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        OverTimeContent.text = @"2时01分";
        OverTimeContent.font = [UIFont systemFontOfSize:16];
        OverTimeContent.textColor = [UIColor baseColor];
        
        //加班
        UIButton *OverButton = [[UIButton alloc] init];
        self.OverButton = OverButton;
        [_selectView addSubview:OverButton];
        [OverButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(50);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        [OverButton setTitle:@"加班" forState:UIControlStateNormal];
        OverButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [OverButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [OverButton addTarget:self action:@selector(TouchOverButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *overLineV = [[UIView alloc] init];
        self.overLineV = overLineV;
        [_selectView addSubview:overLineV];
        [overLineV mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(2);
            make.centerX.equalTo(OverButton);
            make.top.equalTo(OverButton.mas_bottom).offset(-9);
        }];
        overLineV.backgroundColor = [UIColor baseColor];
        
        //请假
        UIButton *LeaveButton = [[UIButton alloc] init];
        self.LeaveButton = LeaveButton;
        [_selectView addSubview:LeaveButton];
        [LeaveButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(50);
            make.right.mas_equalTo(0);
            make.left.equalTo(OverButton.mas_right);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        [LeaveButton setTitle:@"请假" forState:UIControlStateNormal];
        LeaveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [LeaveButton setTitleColor:[UIColor colorWithHexString:@"#444444"] forState:UIControlStateNormal];
        [LeaveButton addTarget:self action:@selector(TouchLeaveButton:) forControlEvents:UIControlEventTouchUpInside];

        UIView *overLineV2 = [[UIView alloc] init];
        self.overLineV2 = overLineV2;
        [_selectView addSubview:overLineV2];
        [overLineV2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(2);
            make.centerX.equalTo(LeaveButton);
            make.top.equalTo(LeaveButton.mas_bottom).offset(-9);
        }];
        overLineV2.hidden = YES;
        overLineV2.backgroundColor = [UIColor baseColor];
        
        
        //小时工
        UILabel *HourMoney = [[UILabel alloc] init];
        [_selectView addSubview:HourMoney];
        self.HourMoney = HourMoney;
        [HourMoney mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        HourMoney.textColor = [UIColor baseColor];
        HourMoney.text = @"0元";
        HourMoney.font = [UIFont systemFontOfSize:14];
        
        UILabel *HourLabel = [[UILabel alloc] init];
        [_selectView addSubview:HourLabel];
        self.HourLabel = HourLabel;
        [HourLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_equalTo(HourMoney.mas_left).offset(-8);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        HourLabel.text = @"工资:";
        HourLabel.font = [UIFont systemFontOfSize:14];

        //时间选择器
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        self.datePicker = datePicker;
        [_selectView addSubview:datePicker];
        [datePicker mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.OverTimeLabel.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(140);
        }];
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        
        NSDate* Date = [NSString dateFromString:@"2019-01-01 01:00:00"];
        [self.datePicker setDate:Date animated:YES];
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        datePicker.layer.borderWidth = 1;
        datePicker.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;

        UIView *lineView = [[UIView alloc] init];
        [_selectView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(datePicker.mas_bottom);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(7);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        
        //加班班次
        UILabel *OverTypeLabel= [[UILabel alloc] init];
        self.OverTypeLabel = OverTypeLabel;
        [_selectView addSubview:OverTypeLabel];
        [OverTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        OverTypeLabel.font = [UIFont systemFontOfSize:15];
        OverTypeLabel.textColor = [UIColor colorWithHexString:@"#929292"];
        OverTypeLabel.text = @"加班班次";
        
        UIImageView *OverTypeImage = [[UIImageView alloc] init];
        [_selectView addSubview:OverTypeImage];
        [OverTypeImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(OverTypeLabel);
            make.right.mas_equalTo(-12);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(12);
        }];
        OverTypeImage.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
 
        UIButton *OverTypeButton = [[UIButton alloc] init];
        self.OverTypeButton = OverTypeButton;
        [_selectView addSubview:OverTypeButton];
        [OverTypeButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(OverTypeLabel);
            make.left.equalTo(OverTypeLabel.mas_right).offset(8);
            make.right.equalTo(OverTypeImage.mas_left).offset(-8);
            make.height.mas_equalTo(40);
        }];
         [OverTypeButton setTitle:@"早班" forState:UIControlStateNormal];
        [OverTypeButton setTitleColor:[UIColor colorWithHexString:@"#FF444444"] forState:UIControlStateNormal];
        OverTypeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        OverTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [OverTypeButton addTarget:self action:@selector(OverTypeTouch) forControlEvents:UIControlEventTouchUpInside];
        
        UITextField *LeaveTextField =[[UITextField alloc] init];
        self.LeaveTextField = LeaveTextField;
        [_selectView addSubview:LeaveTextField];
        [LeaveTextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(OverTypeLabel);
            make.left.equalTo(OverTypeLabel.mas_right).offset(8);
            make.right.equalTo(OverTypeImage.mas_left).offset(-8);
            make.height.mas_equalTo(40);
        }];
        LeaveTextField.textAlignment = NSTextAlignmentRight;
        LeaveTextField.placeholder = @"0.00元/小时";
        LeaveTextField.keyboardType = UIKeyboardTypeDecimalPad;
        LeaveTextField.inputAccessoryView = self.ToolTextView;
        LeaveTextField.delegate = self;

        UIView *lineView2 = [[UIView alloc] init];
        [_selectView addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(OverTypeLabel.mas_bottom);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        lineView2.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        
        //加班工资倍数
        UILabel *SalaryLabel = [[UILabel alloc] init];
        self.SalaryLabel = SalaryLabel;
        [_selectView addSubview:SalaryLabel];
        [SalaryLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        SalaryLabel.font = [UIFont systemFontOfSize:15];
        SalaryLabel.textColor = [UIColor colorWithHexString:@"#929292"];
        SalaryLabel.text = @"加班工资倍数";
        
        UIImageView *SalaryImage = [[UIImageView alloc] init];
        self.SalaryImage = SalaryImage;
        [_selectView addSubview:SalaryImage];
        [SalaryImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(SalaryLabel);
            make.right.mas_equalTo(-12);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(12);
        }];
        SalaryImage.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
        UIButton *SalaryButton = [[UIButton alloc] init];
        self.SalaryButton = SalaryButton;
        [_selectView addSubview:SalaryButton];
        [SalaryButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(SalaryLabel);
            make.left.equalTo(SalaryLabel.mas_right).offset(8);
            make.right.equalTo(SalaryImage.mas_left).offset(-8);
            make.height.mas_equalTo(40);
        }];
        [SalaryButton setTitle:@"1.50倍(0.00元/小时)" forState:UIControlStateNormal];
        [SalaryButton setTitleColor:[UIColor colorWithHexString:@"#FF444444"] forState:UIControlStateNormal];
        SalaryButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH==320?12:15];
        SalaryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [SalaryButton addTarget:self action:@selector(SalaryTouch) forControlEvents:UIControlEventTouchUpInside];

        UITextField *SalaryTF = [[UITextField alloc] init];
        self.SalaryTF = SalaryTF;
        [_selectView addSubview:SalaryTF];
        [SalaryTF mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(SalaryLabel);
            make.left.equalTo(SalaryLabel.mas_right).offset(8);
            make.right.equalTo(SalaryImage.mas_left).offset(-8);
            make.height.mas_equalTo(40);
        }];
        SalaryTF.textAlignment = NSTextAlignmentRight;
        SalaryTF.keyboardType = UIKeyboardTypeNumberPad;
        SalaryTF.inputAccessoryView = self.ToolTextView;
        SalaryTF.delegate = self;

 
        UIView *lineView3 = [[UIView alloc] init];
        self.lineView3 = lineView3;
        [_selectView addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(SalaryLabel.mas_bottom);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        lineView3.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        
        UITextView *textView = [[UITextView alloc] init];
        self.textView = textView;
        [_selectView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView3.mas_bottom).offset(13);
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(60);
        }];
        textView.backgroundColor = [UIColor colorWithHexString:@"#FFF2F2F2"];
        textView.textColor = [UIColor lightGrayColor];
        textView.text = TEXT;
        textView.delegate = self;
        textView.inputAccessoryView = _KeyBoardView;//键盘上加view
        
        UIButton *cancelButton = [[UIButton alloc]init];
        [_selectView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-20);
        }];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.borderWidth = 1;
        cancelButton.layer.borderColor = [UIColor baseColor].CGColor;
        cancelButton.layer.cornerRadius = 4;
//        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
 
        
        UIButton *saveButton = [[UIButton alloc]init];
        [_selectView addSubview:saveButton];
        //        saveButton.frame = CGRectMake(SCREEN_WIDTH/2, 253-47, SCREEN_WIDTH/2, 47);
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.left.equalTo(cancelButton.mas_right).offset(13);
            make.centerY.equalTo(cancelButton);
            make.height.mas_equalTo(40);
            make.width.equalTo(cancelButton.mas_width);
        }];
        saveButton.backgroundColor = [UIColor baseColor];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        saveButton.layer.cornerRadius = 4;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return _selectView;
}
/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - SCREEN_HEIGHT;
    self.transformY = transformY;
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (firstResponder == self.LeaveTextField || firstResponder == self.SalaryTF) {
        // 3.执行动画
        WEAK_SELF()
        [UIView animateWithDuration:duration animations:^{
                if (transformY < 0) {
                    weakSelf.selectView.lx_y = SCREEN_HEIGHT - weakSelf.selectView.lx_height+transformY+139;
                }else{
                    weakSelf.selectView.lx_y = SCREEN_HEIGHT - weakSelf.selectView.lx_height;
                }
            }];
    }else if (firstResponder == self.textView){
        if (transformY < 0) {
            [self.KeyBoardText becomeFirstResponder];
            if ([self.textView.textColor isEqual:[UIColor blackColor]]) {
                self.KeyBoardText.text = self.textView.text;
            }
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.bgView];
        }else{
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.selectView];
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.durationView.bgView];
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.durationView.selectView];
        }
    }
}

-(LPDurationView *)durationView{
    if (!_durationView) {
        _durationView = [[LPDurationView alloc]init];
    }
    return _durationView;
}

-(void)requestQueryGetOvertimeAccount{
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetPriceName:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPLabourCostModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetYsetMulList{
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"time":self.currentDateString
                          };
    [NetApiManager requestQueryGetYsetMulList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.YsetModel = [LPYsetMulListModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetOvertime{
 

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH时mm分";
    NSDate *date1 = [formatter  dateFromString:self.OverTimeContent.text];
    NSCalendar *calendarone = [NSCalendar currentCalendar];
    NSUInteger unitFlagsone = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponentone = [calendarone components:unitFlagsone fromDate:date1];
    NSInteger hourq = [dateComponentone hour]*60+[dateComponentone minute];
 
    NSString *idStr = @"";
    NSDictionary *dic;
    if ([self.OverButton.currentTitleColor isEqual:[UIColor baseColor]]) {      //加班
        for (LPOverTimeAccountDataRecordListModel *m in self.RecordModelList) {
            if (m.status.integerValue == 1) {       //加班
                idStr = m.id;
            }
        }
        NSString *remarkStr =@"";
        if (![self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
            if (self.textView.text.length>30) {
                remarkStr = [self.textView.text substringToIndex:30];
            }else{
                remarkStr = self.textView.text;
            }
         }
        if (self.WorkHourType == 2) {
            //计算法定节假日
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            dic = @{@"id":idStr,
                    @"status":@(1),
                    @"leaveTime":[NSString stringWithFormat:@"%ld",(long)hourq],
//                    @"moneyType":[LPTools calculationChinaCalendarWithDate:[formatter dateFromString:self.currentDateString]],
                    @"shift":self.OverTypeButton.tag==0?@"":[NSString stringWithFormat:@"%ld",(long)self.OverTypeButton.tag],
                    @"remark":remarkStr,
                    @"type":@(self.WorkHourType),
                    @"time":self.currentDateString,
                    @"monthHours":[NSString stringWithFormat:@"%ld",self.SalaryTF.text.integerValue]
                    };
        }else if (self.WorkHourType == 3){
            dic = @{@"id":idStr,
                    @"status":@(1),
                    @"leaveTime":[NSString stringWithFormat:@"%ld",(long)hourq],
                    @"shift":self.OverTypeButton.tag==0?@"":[NSString stringWithFormat:@"%ld",(long)self.OverTypeButton.tag],
                    @"remark":remarkStr,
                    @"type":@(self.WorkHourType),
                    @"time":self.currentDateString,
                    @"leaveMoney":reviseString(self.model.data[self.SalaryButton.tag].priceMoney),
                    @"hoursId":reviseString(self.model.data[self.SalaryButton.tag].id)
                    };
        } else{
            dic = @{@"id":idStr,
                    @"status":@(1),
                    @"leaveTime":[NSString stringWithFormat:@"%ld",(long)hourq],
                    @"baseSalaryId":self.YsetModel.data.count?self.YsetModel.data[0].id:@"",
                    @"moneyType":[NSString stringWithFormat:@"%ld",(long)self.SalaryButton.tag],
                    @"shift":self.OverTypeButton.tag==0?@"":[NSString stringWithFormat:@"%ld",(long)self.OverTypeButton.tag],
                    @"remark":remarkStr,
                    @"type":@(self.WorkHourType),
                    @"time":self.currentDateString
                    };
        }

    }else{
        for (LPOverTimeAccountDataRecordListModel *m in self.RecordModelList) {
            if (m.status.integerValue == 2) {       //请假
                idStr = m.id;
            }
        }
        NSString *remarkStr =@"";
        if (![self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
            if (self.textView.text.length>30) {
                remarkStr = [self.textView.text substringToIndex:30];
            }else{
                remarkStr = self.textView.text;
            }
        }
        dic = @{@"id":idStr,
                @"status":@(2),
                @"leaveTime":[NSString stringWithFormat:@"%.1ld",(long)hourq],
                @"leaveMoney":[NSString stringWithFormat:@"%.2f",self.LeaveTextField.text.floatValue],
                @"remark":remarkStr,
                @"type":@(self.WorkHourType),
                @"time":self.currentDateString
                };
    }

    WEAK_SELF();
    [NetApiManager requestQueryGetOvertime:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [DSBaActivityView hideActiviTy];
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray  *dataArr = [responseObject[@"data"] componentsSeparatedByString:@"#"];//分隔符逗号
                if ([dataArr[1] integerValue] == 1) {
                    if (self.block) {
                        self.block(1);
                    }
                    [weakSelf hidden];
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"保存失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];

        }

    }];
}

- (CGFloat)calculateRowWidth:(NSString *)string {
     NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    /*计算宽度时要确定高度*/
     CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
     return rect.size.width+8;
 }
  
@end
