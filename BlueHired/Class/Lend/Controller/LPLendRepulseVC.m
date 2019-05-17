//
//  LPLendRepulseVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLendRepulseVC.h"
#import "LPCustomPickerView.h"

static NSString *TEXT = @"请输入审核拒绝的原因";

@interface LPLendRepulseVC ()<UITextViewDelegate>
@property(nonatomic,strong) LPCustomPickerView *CustomPicker;
@property(nonatomic,strong) UIButton *Vbutton;
@property(nonatomic,strong) NSArray *DayArr;

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
 

@end

@implementation LPLendRepulseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_Type == 1) {
        self.navigationItem.title = @"审核拒绝";
        TEXT = @"请输入审核拒绝的原因";
        [self setUI];
        self.DayArr = @[@"不限制",@"1天",@"2天",@"3天",@"4天",@"5天",@"6天",@"7天",];
    }else if (_Type == 2){
        self.navigationItem.title = @"拉黑理由";
        TEXT = @"请输入拉黑理由";
    }
    

    self.textView.layer.cornerRadius = 10;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = TEXT;
    self.textView.delegate = self;
    
//    self.clearBt.layer.borderWidth = 1;
//    self.clearBt.layer.borderColor = [UIColor baseColor].CGColor;
//    self.clearBt.layer.cornerRadius = 24;
    
    self.confirmBt.layer.cornerRadius = 4;

}

-(void)setUI{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.textView.mas_bottom).offset(12);
        make.right.mas_offset(-16);
        make.left.mas_offset(16);
        make.height.mas_equalTo(40);
    }];
    view.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
    view.layer.borderWidth = 1;
    
    UILabel *Vtitle = [[UILabel alloc] init];
    [view addSubview:Vtitle];
    [Vtitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(13);
        make.top.mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    Vtitle.text = @"限制借支时间:";
    Vtitle.textColor = [UIColor colorWithHexString:@"#666666"];
    Vtitle.font = [UIFont systemFontOfSize:14];
    
    UIImageView *Vimage = [[UIImageView alloc] init];
    [view addSubview:Vimage];
    [Vimage mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_offset(-13);
        make.width.mas_offset(22);
        make.height.mas_equalTo(13);
        make.centerY.equalTo(view);
    }];
    Vimage.image = [UIImage imageNamed:@"WorkHourTopArrows"];
    
    UIButton *Vbutton = [[UIButton alloc] init];
    [view addSubview:Vbutton];
    self.Vbutton = Vbutton;
    [Vbutton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(Vimage.mas_left).offset(-12);
        make.left.equalTo(Vtitle.mas_right).offset(8);
        make.height.mas_offset(40);
        make.centerY.equalTo(view);
    }];
    Vbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [Vbutton setTitle:@"不限制" forState:UIControlStateNormal];
    [Vbutton setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
    Vbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [Vbutton addTarget:self action:@selector(TouchVbutton:) forControlEvents:UIControlEventTouchUpInside];
//    Vbutton.backgroundColor = [UIColor redColor];
    
    UILabel *TitleLabel = [[UILabel alloc] init];
    [self.view addSubview:TitleLabel];
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(13);
        make.right.mas_offset(-13);
        make.top.equalTo(view.mas_bottom).offset(11);
    }];
    TitleLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];
    TitleLabel.numberOfLines = 0;
    TitleLabel.font = [UIFont systemFontOfSize:13];
    TitleLabel.text = @"提示：选择限制借支时间后，该用户在限制时间内便不可以再申请进行借支";
    
}
-(LPCustomPickerView *)CustomPicker{
    if (!_CustomPicker) {
        _CustomPicker = [[LPCustomPickerView alloc]init];
    }
    return _CustomPicker;
}

-(void)TouchVbutton:(UIButton *)sender{
     self.CustomPicker.typeArray =  self.DayArr;
    WEAK_SELF()
    self.CustomPicker.block = ^(NSInteger index) {
        sender.tag = index;
        NSLog(@"%@",weakSelf.DayArr[index]);
        [sender setTitle:weakSelf.DayArr[index] forState:UIControlStateNormal];
    };
    self.CustomPicker.hidden = NO;
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
    NSDictionary *dic;
    if (self.Vbutton.tag == 0) {
        dic = @{@"status":@"2",
                @"reason":self.textView.text,
                @"id":self.model.id};
    }else{
        dic = @{@"status":@"2",
                @"reason":self.textView.text,
                @"day":[NSString stringWithFormat:@"%ld",(long)self.Vbutton.tag],
                @"id":self.model.id};
    }
    
    [NetApiManager requestQueryUpdateLandMoneyList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
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
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
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
            if ([responseObject[@"code"] integerValue] == 0) {
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
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
