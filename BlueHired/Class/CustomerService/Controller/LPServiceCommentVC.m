//
//  LPServiceCommentVC.m
//  BlueHired
//
//  Created by iMac on 2019/11/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPServiceCommentVC.h"

@interface LPServiceCommentVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation LPServiceCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"客服评价";
    self.textView.layer.cornerRadius = LENGTH_SIZE(2);
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.textView.layer.borderWidth = LENGTH_SIZE(1);
    self.textView.delegate = self;

}


- (void)textViewDidChange:(UITextView *)textField{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 300;
    
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


- (IBAction)TouchSelectBtn:(UIButton *)sender {
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.btn4.selected = NO;

    sender.selected = YES;
    self.selectBtn = sender;
}

- (IBAction)TouchSaveBtn:(UIButton *)sender {
    if (self.selectBtn == nil) {
        [self.view showLoadingMeg:@"请选择满意度" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self commit];
  
}
- (void)commit
{

        if ([self.messageModel.message.ext objectForKey:kMesssageExtWeChat]) {
            NSDictionary *weichat = [self.messageModel.message.ext objectForKey:kMesssageExtWeChat];
            if ([weichat objectForKey:kMesssageExtWeChat_ctrlArgs]) {
                NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMesssageExtWeChat_ctrlArgs]];
                ControlType *type = [[ControlType alloc] initWithValue:@"enquiry"];
                ControlArguments *arguments = [ControlArguments new];
                arguments.sessionId = [ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_serviceSessionId];
                arguments.inviteId = [ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_inviteId];
                arguments.detail = self.textView.text;
                arguments.summary = [NSString stringWithFormat:@"%ld",self.selectBtn.tag - 1000 ];
                
                HDMessage *message = [HDMessage createTxtSendMessageWithContent:@"" to:self.conversation.conversationId];

                HDControlMessage *hCtrl = [HDControlMessage new];
                hCtrl.type = type;
                hCtrl.arguments = arguments;
                [message addCompositeContent:hCtrl];
                
                [[HDClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HDMessage *aMessage, HDError *aError) {
                    if (!aError) {
                        [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"评价成功" time:MESSAGE_SHOW_TIME];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        [self.conversation removeMessageWithMessageId:self.messageModel.messageId error:nil];
                        if (self.block) {
                            self.block(@"", 0);
                        }
                    } else {
                        [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"评价失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                    }
                    [self.conversation removeMessageWithMessageId:aMessage.messageId error:nil];
                }];
                
                
                
            }
        }
    
    
    
}

@end
