//
//  LPLendVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLendVC.h"
#import "LPQueryCheckrecordModel.h"

@interface LPLendVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lendMoneyLabel;

@property (weak, nonatomic) IBOutlet UITextField *lendTextField;
@property (weak, nonatomic) IBOutlet UIButton *lendButton;

@property(nonatomic,strong) NSString *lendMoney;



@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UILabel *text3;

@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UILabel *time3;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property(nonatomic,strong) LPQueryCheckrecordModel *model;

@end

@implementation LPLendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"借支";
    
    self.recordView.hidden = YES;
    [self requestQueryIsLend];
}
-(void)setModel:(LPQueryCheckrecordModel *)model{
    _model = model;
    if (model.data.status.integerValue == 0) {
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"add_ record_normal"];
        
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        
        self.text1.text = [NSString stringWithFormat:@"借支金额%@元，我们将在1-3个工作日内完成审核",model.data.lendMoney];

    }else if (model.data.status.integerValue == 1){
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"add_ record_selected"];
        
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time3.text = [NSString convertStringToTime:[model.data.time stringValue]];

        self.text3.text = @"借支金额将在1个工作日内发放至您的工资卡，如遇节假日时间顺延。";
        
        [self.bottomButton setTitle:@"再借一笔" forState:UIControlStateNormal];
    }else if (model.data.status.integerValue == 3){
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"deleteCard"];
        
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time3.text = [NSString convertStringToTime:[model.data.time stringValue]];
        [self.bottomButton setTitle:@"重新申请" forState:UIControlStateNormal];

    }
}

- (IBAction)touchLendButton:(UIButton *)sender {
    if (self.lendTextField.text.integerValue > self.lendMoney.integerValue) {
        [self.view showLoadingMeg:@"输入的金额应不大于借支额度" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestAddLendmoney];
    
}
- (IBAction)touchBottomButton:(UIButton *)sender {
    if (self.model.data.status.integerValue == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.recordView.hidden = YES;
    }
}

#pragma mark - request
-(void)requestQueryIsLend{
    [NetApiManager requestQueryIsLendWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                if (responseObject[@"data"][@"res_code"]) {
                    if ([responseObject[@"data"][@"res_code"] integerValue] == 20012) {
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"data"][@"res_msg"] message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert show];
                    }
                    if ([responseObject[@"data"][@"res_code"] integerValue] == 0) {
                        if (responseObject[@"data"][@"lendMoney"]) {
                            self.lendMoneyLabel.text = [NSString stringWithFormat:@"借支额度：%@",responseObject[@"data"][@"lendMoney"]];
                            self.lendMoney = responseObject[@"data"][@"lendMoney"];
                            [self requestQueryCheckrecord];
                        }
                    }
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryCheckrecord{
    [NetApiManager requestQueryCheckrecordWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.recordView.hidden = NO;
            self.model = [LPQueryCheckrecordModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestAddLendmoney{
    NSDictionary *dic = @{
                          @"lendMoney":self.lendTextField.text
                          };
    [NetApiManager requestAddLendmoneyWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"code"]) {
                if ([responseObject[@"code"] integerValue] == 0){
                    [self.view showLoadingMeg:@"申请成功" time:MESSAGE_SHOW_TIME];
                    [self requestQueryCheckrecord];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
