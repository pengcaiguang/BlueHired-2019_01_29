//
//  LPRecruitmentVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRecruitmentVC.h"
#import "LPWork_ListModel.h"
#import "LPRecruitRequireVC.h"
#import "LPRecruitCell.h"
static NSString *LPRecruitCellID = @"LPRecruitCell";

@interface LPRecruitmentVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

//view1
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *GCName1;
@property (weak, nonatomic) IBOutlet UILabel *Post1;
@property (weak, nonatomic) IBOutlet UILabel *WorkType1;
@property (weak, nonatomic) IBOutlet UITextField *number1;
@property (weak, nonatomic) IBOutlet UIButton *statueBt1;
@property (weak, nonatomic) IBOutlet UIButton *statueBt2;
@property (weak, nonatomic) IBOutlet UIButton *startDate1;
@property (weak, nonatomic) IBOutlet UIButton *endDate1;

//view2
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *GCName2;
@property (weak, nonatomic) IBOutlet UILabel *Post2;
@property (weak, nonatomic) IBOutlet UILabel *WorkType2;
@property (weak, nonatomic) IBOutlet UITextField *number2;
@property (weak, nonatomic) IBOutlet UIButton *statueBt3;
@property (weak, nonatomic) IBOutlet UIButton *statueBt4;
@property (weak, nonatomic) IBOutlet UIButton *startDate2;
@property (weak, nonatomic) IBOutlet UIButton *endDate2;

@property(nonatomic,copy) LPWork_ListDataModel *model1;
@property(nonatomic,strong) LPWork_ListDataModel *model2;

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPWork_ListModel *model;
@end

@implementation LPRecruitmentVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.title = @"招聘管理";
    [self requestQueryWorkList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isBack) {
        self.isBack = NO;
        for (LPWork_ListDataModel *m in _model.data) {
            if (m.id.integerValue == self.ModelID) {
                m.workDemand = self.dataList.workDemand;
                m.workSalary = self.dataList.workSalary;
                m.eatSleep = self.dataList.eatSleep;
                m.workTime = self.dataList.workTime;
                m.workKnow = self.dataList.workKnow;
                m.remarks = self.dataList.remarks;
                break;
            }
        }
    }
}

-(void)initView
{
   
    [_image1 sd_setImageWithURL:[NSURL URLWithString:_model1.mechanismLogo] placeholderImage:[UIImage imageNamed:@"mechanismLogo"]];
    _GCName1.text = _model1.mechanismName;
    _Post1.text= _model1.workTypeName;
    _WorkType1.text = _model1.postName;
    _number1.text = _model1.maxNumber;
    NSArray *dateArr = [_model1.interviewTime componentsSeparatedByString:@"-"];
    if (dateArr.count==2) {
        [_startDate1 setTitle:dateArr[0] forState:UIControlStateNormal];
        [_endDate1 setTitle:dateArr[1] forState:UIControlStateNormal];
    }
    if (_model1.status.integerValue == 0) {
        _statueBt1.selected = YES;
        _statueBt2.selected = NO;
    }else{
        _statueBt1.selected = NO;
        _statueBt2.selected = YES;
    }
    
    //第二个view
    [_image2 sd_setImageWithURL:[NSURL URLWithString:_model2.mechanismLogo] placeholderImage:[UIImage imageNamed:@"mechanismLogo"]];
    _GCName2.text = _model2.mechanismName;
    _Post2.text= _model2.workTypeName;
    _WorkType2.text = _model2.postName;
    _number2.text = _model2.maxNumber;
    NSArray *dateArr2= [_model2.interviewTime componentsSeparatedByString:@"-"];
    if (dateArr.count==2) {
        [_startDate2 setTitle:dateArr2[0] forState:UIControlStateNormal];
        [_endDate2 setTitle:dateArr2[1] forState:UIControlStateNormal];
    }
    if (_model2.status.integerValue == 0) {
        _statueBt3.selected = YES;
        _statueBt4.selected = NO;
    }else{
        _statueBt3.selected = NO;
        _statueBt4.selected = YES;
    }
}

#pragma mark - touch

- (IBAction)TouchSenderBt:(id)sender {
    
}
- (IBAction)touchStatueBt:(UIButton *)sender {
    if (sender == _statueBt1 ||sender == _statueBt2 ) {
        _statueBt2.selected = NO;
        _statueBt1.selected = NO;
        sender.selected = YES;
    }else if (sender == _statueBt3 ||sender == _statueBt4 ){
        _statueBt3.selected = NO;
        _statueBt4.selected = NO;
        sender.selected = YES;
    }
}

- (IBAction)touchSelectDate:(UIButton *)sender {
    if (_startDate1 == sender) {
        [self alertView:1];
    }else if (_endDate1 == sender){
        [self alertView:2];
    }else if (_startDate2 == sender){
        [self alertView:3];
    }else if (_endDate2 == sender){
        [self alertView:4];
    }
}

- (IBAction)touchToRequire:(UIButton *)sender {
    LPRecruitRequireVC *vc = [[LPRecruitRequireVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(NSInteger)index{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.bgView addGestureRecognizer:tap];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    self.popView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.popView addSubview:label];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3-30, SCREEN_WIDTH/2, 20)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-30, SCREEN_WIDTH/2, 20)];
    confirmButton.tag = index;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBirthday:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:confirmButton];
    
        label.text = @"面试时间";
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-60)];
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        _datePicker.calendar = [NSCalendar currentCalendar];
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//        _datePicker.locale = [NSLocale systemLocale];
        _datePicker.date = [NSDate date];
//        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.popView addSubview:_datePicker];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        nil;
    }];
}
-(void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self.bgView removeFromSuperview];
        
    }];
}

-(void)confirmBirthday:(UIButton *)sender{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    
    if (sender.tag == 1) {
        [_startDate1 setTitle:dateString forState:UIControlStateNormal];
    }else if (sender.tag == 2){
        [_endDate1 setTitle:dateString forState:UIControlStateNormal];
    }else if (sender.tag == 3){
        [_startDate2 setTitle:dateString forState:UIControlStateNormal];
    }else if (sender.tag == 4){
        [_endDate2 setTitle:dateString forState:UIControlStateNormal];
    }
    
    [self removeView];
}


-(BOOL)textField:( UITextField  *)textField shouldChangeCharactersInRange:(NSRange )range replacementString:( NSString  *)string
{
    if (_number1 == textField || _number2 == textField) {
        if (textField.text.length >= 5) {
            textField.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    return YES;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.data.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPRecruitCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRecruitCellID];
    if(cell == nil){
        cell = [[LPRecruitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPRecruitCellID];
    }
    cell.model = _model.data[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPRecruitCellID bundle:nil] forCellReuseIdentifier:LPRecruitCellID];
        
    }
    return _tableview;
}

#pragma mark - request
-(void)requestQueryWorkList{
    [NetApiManager requestQueryWorkList:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPWork_ListModel mj_objectWithKeyValues:responseObject];
            [self.tableview reloadData];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
