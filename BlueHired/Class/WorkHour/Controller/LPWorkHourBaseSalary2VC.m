//
//  LPWorkHourBaseSalary2VC.m
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourBaseSalary2VC.h"
#import "LPBaseSalaryModel.h"

@interface LPWorkHourBaseSalary2VC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TextField;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UIView *DateBgView;

@property (weak, nonatomic) IBOutlet UIButton *SaveBT;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;

@property(nonatomic,strong) LPBaseSalaryModel *model;
@property (nonatomic,strong) UIView *ToolTextView;

@end

@implementation LPWorkHourBaseSalary2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextFieldView];

    [self addShadowToView:self.DateBgView withColor:[UIColor lightGrayColor]];
    self.navigationItem.title = @"企业底薪设置";
    self.DateLabel.text = [DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    self.DatePicker.date = [NSDate date];
    self.DatePicker.maximumDate = [NSDate date];
    self.TextField.delegate = self;
    self.TextField.inputAccessoryView = self.ToolTextView;

    [self requestQueryGetHoursWorkBaseSalary];
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


#pragma mark - 编辑view
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




- (IBAction)ChangedDatePicker:(UIDatePicker *)sender {
    self.DateLabel.text = [DataTimeTool stringFromDate:sender.date DateFormat:@"yyyy-MM-dd"];
}


- (IBAction)SaveTouch:(UIButton *)sender {
        if ([self.TextField.text isEqualToString:@""]) {
            [self.view showLoadingMeg:@"请设置企业底薪" time:2.0];
            return;
        }
        [self requestQueryUpdateBaseSalary];
}
- (IBAction)cancelTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setModel:(LPBaseSalaryModel *)model
{
    _model = model;
    if (model.data.count) {
        self.TextField.text = reviseString(model.data[0].salary);
        NSArray *dateArr = [model.data[0].beginTime componentsSeparatedByString:@"#"];
        self.DateLabel.text = dateArr[0];
        self.DatePicker.date = [DataTimeTool dateFromString:dateArr[0] DateFormat:@"yyyy-MM-dd"];
    }
}


#pragma mark - request
-(void)requestQueryUpdateBaseSalary{
    NSDictionary *dic;
        
        dic = @{
                @"id":self.model.data.count?self.model.data[0].id:@"",
                @"salary":[NSString stringWithFormat:@"%.2f",self.TextField.text.floatValue],
                @"beginTime":self.DateLabel.text,
                @"type":@(self.WorkHourType),
                };
 
    [NetApiManager requestQueryUpdateBaseSalary:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1){
                    [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
 
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"保存失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];

        }
        
    }];
}

-(void)requestQueryGetHoursWorkBaseSalary{
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"status":@(1),
                          };
    [NetApiManager requestQueryGetHoursWorkBaseSalary:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPBaseSalaryModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
