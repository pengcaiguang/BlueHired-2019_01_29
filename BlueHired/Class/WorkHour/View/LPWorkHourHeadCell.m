//
//  LPWorkHourHeadCell.m
//  BlueHired
//
//  Created by iMac on 2019/2/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourHeadCell.h"

@implementation LPWorkHourHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.WorkHourType = 3;
    
//    self.HeadVIew.backgroundColor = [UIColor colorWithRed:144/255.0 green:112/255.0 blue:255/255.0 alpha:1.0];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH,214);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(0, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF3CAFFF"].CGColor,
                  (__bridge id)[UIColor colorWithHexString:@"#FF459DFF"].CGColor,
                  (__bridge id)[UIColor colorWithHexString:@"#FF9963FF"].CGColor];
    gl.locations = @[@(0.0f),@(0.3f),@(1.0f)];
    
    [self.BackImageView.layer addSublayer:gl];
    
    self.KQView.layer.cornerRadius = 8;
    self.KQView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
//    self.KQView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.32].CGColor;
//    self.KQView.layer.shadowOffset = CGSizeMake(0,0);
//    self.KQView.layer.shadowOpacity = 1;
//    self.KQView.layer.shadowRadius = 9;
//    self.KQView.layer.cornerRadius = 8;
    self.setMoneyBt.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.15];
    self.setMoneyBt.layer.cornerRadius = 14;
    self.WorkHourView.layer.cornerRadius = 5;
    self.WorkHourView.layer.borderWidth = 0.5;
    self.WorkHourView.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
    
    self.FullTimeView.layer.cornerRadius = 5;
    self.FullTimeView.layer.borderWidth = 0.5;
    self.FullTimeView.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
    
    self.PieceView.layer.cornerRadius = 5;
    self.PieceView.layer.borderWidth = 0.5;
    self.PieceView.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
    
    UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchNoRecordView)];
    self.NoRecordView.userInteractionEnabled = YES;//打开用户交互
    [self.NoRecordView addGestureRecognizer:TapGestureRecognizerimageBg];
    
    
    self.LeftButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [self.LeftButton setTitle:@"切换模式" forState:UIControlStateNormal];
    self.LeftButton.layer.cornerRadius = 14;
    self.LeftButton.contentEdgeInsets = UIEdgeInsetsMake(0,7, 0, 0);
    self.LeftButton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    
}
- (IBAction)TouchDeleteBt:(id)sender {
    if (self.BlockDate) {
        self.BlockDate(4);
    }
}
- (IBAction)TouchUpdateBt:(id)sender {
    if (self.BlockDate) {
        self.BlockDate(3);
    }
}
-(void)TouchNoRecordView{
    if (self.BlockDate) {
        self.BlockDate(3);
    }
}


-(void)setType:(NSInteger)Type{
    _Type = Type;
    if (Type == 0) {    //未记录工时
        self.DeleteBt.hidden = YES;

        self.NoRecordView.hidden = NO;
        self.WorkHourView.hidden = YES;
        self.FullTimeView.hidden = YES;
        self.PieceView.hidden =YES;
        self.HeadVIew_Layout_bottom.constant = 46+12+SCREEN_WIDTH/320*90;
     }else if (Type == 1){       //正式工
         self.DeleteBt.hidden = NO;
        self.NoRecordView.hidden = YES;
        self.WorkHourView.hidden = NO;
        self.FullTimeView.hidden = YES;
         self.PieceView.hidden =YES;
        self.HeadVIew_Layout_bottom.constant = 46+12+185;
    }else if (Type == 2){       //小时工
        self.DeleteBt.hidden = NO;
        self.NoRecordView.hidden = YES;
        self.WorkHourView.hidden = YES;
        self.FullTimeView.hidden = NO;
        self.PieceView.hidden =YES;
        self.HeadVIew_Layout_bottom.constant = 46+12+185;
    }else if (Type == 4){
        self.DeleteBt.hidden = NO;
        self.NoRecordView.hidden = YES;
        self.WorkHourView.hidden = YES;
        self.FullTimeView.hidden = YES;
        self.PieceView.hidden =NO;
        NSInteger Count = _RecordModelList.count>3?3:_RecordModelList.count;
        self.HeadVIew_Layout_bottom.constant = 46+12+39+33+39*Count;
    }
  
}


- (void)setModel:(LPMonthWageDataModel *)Model{
    _Model = Model;
    
    if (self.WorkHourType == 4) {
        self.NoRecordView.image = [UIImage imageNamed:@"workHourrecord_icon2"];
    }else{
        self.NoRecordView.image = [UIImage imageNamed:@"workHourrecord_icon"];
    }

    
    if (!Model.monthSalary) {
        self.setMoneyBt.hidden = NO;
        self.BaseSalaryLabel.hidden = YES;
        self.BaseTitleyLabel.hidden = YES;
    }else{
        self.setMoneyBt.hidden = YES;
        self.BaseSalaryLabel.hidden = NO;
        self.BaseTitleyLabel.hidden = NO;
    }
    
    _wageLabel.text = [NSString stringWithFormat:@"%.2f",Model.monthWage.floatValue];
    _BaseSalaryLabel.text = [NSString stringWithFormat:@"%.2f",Model.monthSalary.floatValue];
    _periodLabel.text = [Model.period stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    _periodLabel.text = [_periodLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"-"];
    _BaseTitleyLabel.text = @"企业底薪(元)";

    if (self.WorkHourType == 1) {
        [self.setMoneyBt setTitle:@"设置底薪" forState:UIControlStateNormal];
        self.MoneysLabelTitle.text = @"加班总工资(元)";
        self.hoursLabelTitle.text = @"加班总时长(小时)";
//        _MoneysLabel.text = reviseString(Model.moneys);
        _MoneysLabel.text = [NSString stringWithFormat:@"%.2f",Model.moneys.floatValue];
//        _hoursLabel.text = reviseString(Model.hours);
        _hoursLabel.text = [NSString stringWithFormat:@"%.2f",Model.hours.floatValue];
    }else if (self.WorkHourType == 2){
        [self.setMoneyBt setTitle:@"设置底薪" forState:UIControlStateNormal];
        self.MoneysLabelTitle.text = @"当月已工作时间(小时)";
        self.hoursLabelTitle.text = @"加班总时长 / 加班总收入";
//        _MoneysLabel.text = reviseString(Model.overtimeHours);
         _MoneysLabel.text =  [NSString stringWithFormat:@"%.2f",Model.overtimeHours.floatValue];
        _hoursLabel.text = [NSString stringWithFormat:@"%.2f小时/%.2f元",Model.hours.floatValue, Model.moneys.floatValue];
    }else if (self.WorkHourType == 3){
        [self.setMoneyBt setTitle:@"设置工价" forState:UIControlStateNormal];
        self.MoneysLabelTitle.text = @"当月总工时(小时)";
        self.hoursLabelTitle.text = @"当月工作天数(天)";
        _MoneysLabel.text = [NSString stringWithFormat:@"%.2f",Model.hours.floatValue];
        _hoursLabel.text = [NSString stringWithFormat:@"%ld",(long)Model.days.integerValue];
        _BaseTitleyLabel.text = @"工价(元/小时)";
    }else if (self.WorkHourType == 4){
        [self.setMoneyBt setTitle:@"设置底薪" forState:UIControlStateNormal];
        self.MoneysLabelTitle.text = @"计件总工资(元)";
        self.hoursLabelTitle.text = @"产品总件数(件)";
        _MoneysLabel.text = [NSString stringWithFormat:@"%.2f",Model.moneys.floatValue];
        _hoursLabel.text = [NSString stringWithFormat:@"%ld",(long)Model.productNum.integerValue];
    }
}

- (void)setRecordModelList:(NSArray<LPOverTimeAccountDataRecordListModel *> *)RecordModelList{
    _RecordModelList = RecordModelList;
    if (RecordModelList.count == 0) {
        self.Type = 0;
        
    }else{
        if (self.WorkHourType == 3) {
            self.Type = 2;
            
            for (LPOverTimeAccountDataRecordListModel *m in RecordModelList) {
                if (m.status.integerValue == 1) {       //加班
                _FullTimeLabel1.text = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue ];
                _FullTimeLabel2.text = [NSString stringWithFormat:@"%.2f元/小时",m.leaveMoney.floatValue];
                _FullTimeLabel3.text = [NSString stringWithFormat:@"%.2f元",m.hours.floatValue*m.leaveMoney.floatValue];
                }
            }
        }else if (self.WorkHourType == 4){
            self.Type = 4;
            NSInteger Count = RecordModelList.count>3?3:RecordModelList.count;
            self.FullTimeTitle.text = RecordModelList.count>3?@"更多计件信息":@"编辑计件信息";
            for (int i =0; i <Count; i++) {
                LPOverTimeAccountDataRecordListModel *m = RecordModelList[i];
                UILabel *Label1 = [self.PieceView viewWithTag:1001+i];
                UILabel *Label2 = [self.PieceView viewWithTag:2001+i];
                UILabel *Label3 = [self.PieceView viewWithTag:3001+i];
                Label1.text = m.productName; 
                Label2.text = [NSString stringWithFormat:@"%.2f",m.productPrice.floatValue];
                Label3.text = [NSString stringWithFormat:@"%ld",(long)m.productNum.integerValue];
            }
            self.LayoutConstraint_Piece.constant = 39+33+39*Count;
            self.HeadVIew_Layout_bottom.constant = 46+12+39+33+39*Count;
            

        }else{
            self.Type = 1;
            _overLabel1.text = @"0.00小时";
            _overLabel2.text = @"0.00倍";
            _overLabel3.text = @"0.00元";
            _leaveLabel1.text = @"0.00小时";
            _leaveLabel2.text = @"0.00元";
            _leaveLabel3.text = @"0.00元";
            for (LPOverTimeAccountDataRecordListModel *m in RecordModelList) {
                NSArray  *MulRoMoney = [m.mulAmount componentsSeparatedByString:@"#"];//分隔符逗号
                NSString *mulStr = MulRoMoney[0];
                NSString *MoneyStr = MulRoMoney[1];
                
                if (m.status.integerValue == 1) {       //加班
                    if (self.WorkHourType == 2) {
                        _overLabelTitle2.text = @"工作总时间";
                        
                        _overLabel1.text = [NSString stringWithFormat:@"%.2f小时",m.workHours.floatValue ];
                        _overLabel2.text = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue];
                        _overLabel3.text = [NSString stringWithFormat:@"%.2f元",m.workMoney.floatValue];
                    }else{
                        _overLabelTitle2.text = @"加班工资倍数";
                        _overLabel1.text = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue ];
                        _overLabel2.text = [NSString stringWithFormat:@"%.2f倍",mulStr.floatValue];
                        _overLabel3.text = [NSString stringWithFormat:@"%.2f元",m.hours.floatValue*MoneyStr.floatValue];
                    }
                }else if (m.status.integerValue == 2){  //2为请假
                    _leaveLabel1.text = [NSString stringWithFormat:@"%.2f小时",m.hours.floatValue];
                    _leaveLabel2.text = [NSString stringWithFormat:@"%.2f元",m.leaveMoney.floatValue];
                    _leaveLabel3.text = [NSString stringWithFormat:@"%.2f元",m.hours.floatValue*m.leaveMoney.floatValue];
                    
                }
            }
        }
        
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)DateLeftTouch:(id)sender {
    if (self.BlockDate) {
        self.BlockDate(1);
    }
}
- (IBAction)DateTouch:(id)sender {
    if (self.BlockDate) {
        self.BlockDate(6);
    }
}
- (IBAction)DateRightTouch:(id)sender {
    if (self.BlockDate) {
        self.BlockDate(2);
    }
}
- (IBAction)SetMoneyTouch:(id)sender {
    if (self.BlockDate) {
        self.BlockDate(5);
    }
}
- (IBAction)LetfTouch:(id)sender {
    if (self.BlockDate) {
        self.BlockDate(7);
    }
}

- (void)setIsPush:(BOOL)isPush{
    _isPush = isPush;
    self.LeftButton.hidden = !isPush;
 }

@end
