//
//  LPLendRepulseVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLendRepulseVC.h"

static NSString *TEXT = @"请输入审核拒绝的原因";

@interface LPLendRepulseVC ()<UITextViewDelegate>
@end

@implementation LPLendRepulseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_Type == 1) {
        self.navigationItem.title = @"审核拒绝";
        TEXT = @"请输入审核拒绝的原因";
    }else if (_Type == 2){
        self.navigationItem.title = @"拉黑理由";
        TEXT = @"请输入拉黑理由";
    }
    

    self.textView.layer.cornerRadius = 10;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = TEXT;
    self.textView.delegate = self;
    
    self.clearBt.layer.borderWidth = 1;
    self.clearBt.layer.borderColor = [UIColor baseColor].CGColor;
    self.clearBt.layer.cornerRadius = 24;
    
    self.confirmBt.layer.cornerRadius = 24;

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
- (IBAction)touchClear:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)touchConfirm:(id)sender {
    if (self.textView.text.length == 0 ||
        [self.textView.textColor isEqual:[UIColor lightGrayColor]]) {
        
        if (_Type == 1) {
            [self.view showLoadingMeg:@"请输入拒绝原因" time:MESSAGE_SHOW_TIME];
        }else if (_Type == 2)
        {
            [self.view showLoadingMeg:@"请输入拉黑原因" time:MESSAGE_SHOW_TIME];
        }
        return;
    }
    
    if (self.textView.text.length >= 300 ) {
        
        if (_Type == 1) {
            [self.view showLoadingMeg:@"字数过长,请限定在300字以内" time:MESSAGE_SHOW_TIME];
        }else if (_Type == 2)
        {
            [self.view showLoadingMeg:@"字数过长,请限定在300字以内" time:MESSAGE_SHOW_TIME];
        }
        return;
    }
    
    if (_Type == 1) {
            [self requestQueryUpdateMoneyList];
    }else if (_Type == 2)
    {
            [self requestQueryUpdateWorkOrderList:@"-1" id:_EntryModel.id reason:self.textView.text];
    }

 
}

#pragma mark - request
-(void)requestQueryUpdateMoneyList{
    NSDictionary *dic = @{@"status":@"2",
                          @"reason":self.textView.text,
                          @"id":self.model.id};
    
    [NetApiManager requestQueryUpdateLandMoneyList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                
                [self.view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                self.model.status = @"2";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
                [self.view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryUpdateWorkOrderList:(NSString *)status id:(NSString *) ID  reason:(NSString *) reason{
    NSDictionary *dic = @{@"id":ID,
                          @"reason":reason,
                          @"status":status};
    
    [NetApiManager requestQueryUodateWorkOrderList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                [self.view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                if (self.BlockTL) {
                    self.BlockTL(self.EntryModel);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
