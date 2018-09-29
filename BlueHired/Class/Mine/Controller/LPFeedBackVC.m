//
//  LPFeedBackVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPFeedBackVC.h"

static NSString *TEXT = @"请输入遇到的问题或建议...";

@interface LPFeedBackVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation LPFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = TEXT;
    self.textView.delegate = self;
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.textColor isEqual:[UIColor lightGrayColor]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = TEXT;
    }
}

- (IBAction)touchSubmitButton:(UIButton *)sender {
    
    if (self.textView.text.length <= 0 || [self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
        [self.view showLoadingMeg:@"请输入意见" time:MESSAGE_SHOW_TIME];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    
    NSDictionary *dic = @{
                          @"appVersion": app_build,
                          @"details": self.textView.text,
                          @"model": [NSString getDeviceName],
                          @"resolution": [NSString stringWithFormat:@"%.0fx%.0f",width,height],
                          @"sysVersion": [[UIDevice currentDevice] systemVersion]
                          };
    [NetApiManager requestProblemAddWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self.view showLoadingMeg:@"提交成功" time:MESSAGE_SHOW_TIME];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"提交失败" time:MESSAGE_SHOW_TIME];
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
