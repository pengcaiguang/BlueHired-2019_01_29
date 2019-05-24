//
//  LPHoursNumderVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHoursNumderVC.h"
#import "CustomDataPickView.h"
#import "LPMonthHoursModel.h"

@interface LPHoursNumderVC ()<CustomDataPickViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *SaveBT;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;

@property (nonatomic, strong) LPMonthHoursModel *model;
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic, strong) CustomDataPickView *customDataPickView;
@property (weak, nonatomic) IBOutlet UILabel *KQLabel;
@property (weak, nonatomic) IBOutlet UITextField *TextFirld;

@property (nonatomic,strong) UIView *ToolTextView;

@end

@implementation LPHoursNumderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextFieldView];

    
    self.navigationItem.title = @"每月工作小时数";
    
    self.SaveBT.layer.cornerRadius = 4;
    self.cancelBT.layer.cornerRadius = 4;
    self.cancelBT.layer.borderWidth = 1;
    self.cancelBT.layer.borderColor= [UIColor baseColor].CGColor;
    
    self.currentDateString = [DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM"];
    
    self.TextFirld.delegate = self;
    self.TextFirld.inputAccessoryView = self.ToolTextView;

    CustomDataPickView *customDataPickView = [[CustomDataPickView alloc]initWithFrame:CGRectMake(0, 41, Screen_Width, 231)];
    [self.view addSubview:customDataPickView];
    self.customDataPickView = customDataPickView;
    customDataPickView.minimumDate = [DataTimeTool dateFromString:@"2000-1-1" DateFormat:@"yyyy-MM-dd"];
    customDataPickView.maximumDate = [DataTimeTool dateFromString:@"2100-12-1" DateFormat:@"yyyy-MM-dd"];
    customDataPickView.defaultSelectDate = [NSDate new];
    customDataPickView.type = CustomDataPickViewTypeYearMonth;
    customDataPickView.delegate = self;
    [customDataPickView show];
    
    [self addShadowToView:customDataPickView withColor:[UIColor lightGrayColor]];
    [self requestQueryGetMonthHours:@""];

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

//CustomDataPickViewTypeYearMonth 回调
- (void)pickViewScroollCallBack_year:(NSString *)year month:(NSString *)month day:(NSString *)day{
    self.currentDateString = [NSString stringWithFormat:@"%@-%.2ld",year,(long)month.integerValue];
    [self requestQueryGetMonthHours:self.currentDateString];
}

- (IBAction)SaveTouch:(UIButton *)sender {
    if (self.TextFirld.text.integerValue == 0) {
        [self.view showLoadingMeg:@"请输入工作小时数" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestQueryUpdateMonthHours];
}
- (IBAction)cancelTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setModel:(LPMonthHoursModel *)model
{
    _model = model;
    if (model.data) {
        self.customDataPickView.defaultSelectDate = [DataTimeTool dateFromString:model.data.month DateFormat:@"yyyy-MM"];
        [self.customDataPickView show];
        self.TextFirld.text  = reviseString(model.data.workHours);
     
        self.KQLabel.text = [model.data.period stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.KQLabel.text = [self.KQLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
        self.currentDateString = model.data.month;
    }
}

#pragma mark - request
-(void)requestQueryGetMonthHours:(NSString *) Time{
    
    NSDictionary *dic = @{@"time":Time
                          };
    [NetApiManager requestQueryGetMonthHours:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPMonthHoursModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryUpdateMonthHours{
    NSDictionary *dic = @{@"month":self.currentDateString,
                          @"workHours":[NSString stringWithFormat:@"%ld",self.TextFirld.text.integerValue],
                          @"id":self.model.data.id?self.model.data.id:@""
                          };
    [NetApiManager requestQueryUpdateMonthHours:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                //            self.model = [LPMonthHoursModel mj_objectWithKeyValues:responseObject];
                if ([responseObject[@"data"] integerValue] == 1) {
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

@end
