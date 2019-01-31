//
//  LPSalarycCardBindPhoneVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalarycCardBindPhoneVC.h"
#import "LPUserMaterialModel.h"
#import "LPSalarycCardChangePasswordVC.h"
#import "LPSalarycCardBindVC.h"

@interface LPSalarycCardBindPhoneVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property(nonatomic,strong) NSString *token;

@end

@implementation LPSalarycCardBindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工资卡绑定";
    self.textField.delegate = self;
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",kUserDefaultsValue(@"PHONEUSERSAVE")];
}

-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.getCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)getCode:(UIButton *)sender {
    [self requestSendCode];
}
- (IBAction)submit:(UIButton *)sender {
    [self requestMateCode];
}
#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.textField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.textField.text.length >= 6) {
            self.textField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}
#pragma mark - request
-(void)requestSendCode{
    NSDictionary *dic = @{
                          @"i":@(5),
                          @"phone":kUserDefaultsValue(@"PHONEUSERSAVE"),
                          };
    [NetApiManager requestSendCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    self.token = responseObject[@"data"];
                }
                [self.view showLoadingMeg:@"验证码发送成功" time:MESSAGE_SHOW_TIME];
                [self openCountdown];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestMateCode{
    NSDictionary *dic = @{
                          @"i":@(5),
                          @"phone":kUserDefaultsValue(@"PHONEUSERSAVE"),
                          @"code":self.textField.text,
                          @"token":self.token?self.token:@""
                          };
    [NetApiManager requestMateCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (self.type == 1)
                {
//                    LPSalarycCardChangePasswordVC  *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    LPSalarycCardChangePasswordVC *vc = [[LPSalarycCardChangePasswordVC alloc] init];
                    vc.times = 1;
//                    [self.navigationController pushViewController:vc animated:NO ];
                    NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                    for (UIViewController *vc in naviVCsArr) {
                        if ([vc isKindOfClass:[self class]]) {
                            [naviVCsArr removeObject:vc];
                            break;
                        }
                    }
                    [naviVCsArr addObject:vc];
//                    self.navigationController.viewControllers = naviVCsArr;
                    [self.navigationController  setViewControllers:naviVCsArr animated:YES];
                    

                }
                else if (self.type == 2)
                {
                    LPSalarycCardChangePasswordVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//                    vc.ispass = YES;
                    vc.times = 1;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"验证失败" time:MESSAGE_SHOW_TIME];
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
