//
//  LPReportContentVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/8.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPReportContentVC.h"

static NSString *TEXT = @"请输入内容";


@interface LPReportContentVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) NSString *BtTag;
@end

@implementation LPReportContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"举报";
    self.BtTag = @"";
    _textView.layer.borderColor = [UIColor colorWithHexString:@"#FFE6E6E6"].CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 5;
    _textView.textColor = [UIColor lightGrayColor];
    _textView.text = TEXT;
    _textView.delegate = self;

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

- (IBAction)touchSelectBt:(UIButton *)sender {
    for (UIView *view in self.view.subviews) {
        if (view.tag >= 100 && view.tag < 105) {
            UIButton *selectBt = (UIButton *)view;
            selectBt.selected = NO;
        }
    }
    sender.selected = YES;
    self.BtTag = [sender.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (IBAction)touchSenderBt:(id)sender {
    
    if ([self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
        [self.view showLoadingMeg:@"请输入内容" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.textView.text.length >= 300) {
        [self.view showLoadingMeg:@"内容过长,请输入300字内" time:MESSAGE_SHOW_TIME];
        return;
    }
    if ([self.BtTag isEqualToString:@""]) {
        [self.view showLoadingMeg:@"请选择举报原因" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestReportAdd];
}

-(void)requestReportAdd{
    NSDictionary *dic = @{
                          @"toUserId":self.MoodModel.userId,
                          @"type":[NSString stringWithFormat:@"%@",self.BtTag],
                          @"details":self.textView.text,
                          @"moldId":self.MoodModel.id,
                          @"moldType":@"0"
                          };
    [NetApiManager requestQueryReportAdd:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"举报成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"举报失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
