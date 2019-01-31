//
//  LPDimissionVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPDimissionFirmVC.h"
#import "LPUserMaterialModel.h"

static NSString *NORMALSTRING = @"请输入离职原因及想要离职的日期";

@interface LPDimissionFirmVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property(nonatomic,assign) NSInteger type;

@end

@implementation LPDimissionFirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"离职通知";
    
    self.backButton.layer.borderColor = [UIColor baseColor].CGColor;
    self.backButton.layer.borderWidth = 0.5;
    
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = NORMALSTRING;
    self.textView.delegate = self;
    
    LPUserMaterialModel *userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
    if (userMaterialModel.data.workStatus) {
        if ([userMaterialModel.data.workStatus integerValue] != 1) { //0待业1在职2入职中
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"你尚未入职，暂不支持离职通知" message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
        }else{
            [self requestGetNotice];
        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.textColor isEqual:[UIColor lightGrayColor]] || [textView.text isEqualToString:NORMALSTRING]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        textView.text = NORMALSTRING;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)touchSubmitButton:(id)sender {
    if (self.textView.text.length <= 0 || [self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
        [self.view showLoadingMeg:@"请输入离职原因内容" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.textView.text.length>=288) {
        [self.view showLoadingMeg:@"字数过长,请限定在288字以内" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    self.type = 1;
    [self requestAddDimission];
}
- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchCancelButton:(id)sender {
    self.type = 2;
    [self requestAddDimission];
}

-(void)requestGetNotice{
    [NetApiManager requestGetNoticeWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                if (responseObject[@"data"][@"isNotice"]) {
                    if ([responseObject[@"data"][@"isNotice"] integerValue] == 1){
                        self.detailsLabel.hidden = NO;
                        self.cancelButton.hidden = NO;
                        
                        self.textView.hidden = YES;
                        self.submitButton.hidden = YES;
                        self.backButton.hidden = YES;
                        self.textLabel.hidden = YES;
                        
                        if (responseObject[@"data"][@"details"]){
                            self.detailsLabel.text = responseObject[@"data"][@"details"];
                        }
                    }else{
                        self.detailsLabel.hidden = YES;
                        self.cancelButton.hidden = YES;
                        
                        self.textView.hidden = NO;
                        self.submitButton.hidden = NO;
                        self.backButton.hidden = NO;
                        self.textLabel.hidden = NO;
                    }
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestAddDimission{
    NSDictionary *dic = @{
                          @"reason":self.type == 1 ? self.textView.text : @"",
                          @"type":@(self.type)
                          };
    NSLog(@"内容长度。%lu",(unsigned long)self.textView.text.length);
    [NetApiManager requestAddDimissionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (self.type == 1) {
                    [self.view showLoadingMeg:@"提交成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [self.view showLoadingMeg:@"取消成功" time:MESSAGE_SHOW_TIME];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
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
