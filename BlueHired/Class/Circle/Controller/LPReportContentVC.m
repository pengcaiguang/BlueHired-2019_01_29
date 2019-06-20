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

@property (nonatomic,strong) UIView *ToolTextView;

@end

@implementation LPReportContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"举报";
    [self setTextFieldView];

    self.BtTag = @"";
    _textView.layer.borderColor = [UIColor colorWithHexString:@"#FFE6E6E6"].CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 5;
    _textView.textColor = [UIColor lightGrayColor];
    _textView.text = TEXT;
    _textView.delegate = self;
    _textView.inputAccessoryView = self.ToolTextView;

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
