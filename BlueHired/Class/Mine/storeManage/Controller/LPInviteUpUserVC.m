//
//  LPInviteUpUserVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPInviteUpUserVC.h"

@interface LPInviteUpUserVC ()

@end

@implementation LPInviteUpUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请店员";
    
    [self.textTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

 }

-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length >=11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (IBAction)touchBt:(id)sender {
    if (self.textTF.text.length != 11) {
        [self.view showLoadingMeg:@"请输入正确的手机号码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    [self requestQueryinviteshopUser];
}

-(void)requestQueryinviteshopUser{
    NSDictionary *dic = @{@"shopNum":[LPTools isNullToString:_Assistantmodel.data.shopNum],
                          @"userName":[LPTools isNullToString:_Assistantmodel.data.userName],
                          @"userTel":_textTF.text,
                          };
    [NetApiManager requestQueryinviteshopUser:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
          if (isSuccess) {
              if ([responseObject[@"code"] integerValue] ==0 && [responseObject[@"data"] integerValue] ==1 ) {
                  [self.view showLoadingMeg:@"邀请成功" time:MESSAGE_SHOW_TIME];
                  [self.navigationController popViewControllerAnimated:YES];
              }else{
                  [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
              }
                            
         }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
