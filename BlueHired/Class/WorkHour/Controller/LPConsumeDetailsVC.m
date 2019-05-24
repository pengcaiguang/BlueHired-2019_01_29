//
//  LPConsumeDetailsVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPConsumeDetailsVC.h"

static NSString *TEXT = @"可以备注您消费的原因，最多30字!";

@interface LPConsumeDetailsVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *SaveBT;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;
@property (weak, nonatomic) IBOutlet UIPickerView *PickerView;
@property (weak, nonatomic) IBOutlet UIView *BackPickerView;
@property (weak, nonatomic) IBOutlet UITextField *TextField;
@property (weak, nonatomic) IBOutlet UITextView *TextView;

@property (nonatomic,assign) NSInteger SelectRow;
@property (nonatomic,assign) NSInteger Select2Row;
@property (nonatomic,strong) NSArray *DataList;

@property (nonatomic,strong) UIView *ToolTextView;

@end

@implementation LPConsumeDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextFieldView];
    self.navigationItem.title = @"消费记录";
    if (self.model) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(butClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
    }
    

    self.SaveBT.layer.cornerRadius = 4;
    self.cancelBT.layer.cornerRadius = 4;
    self.cancelBT.layer.borderWidth = 1;
    self.cancelBT.layer.borderColor= [UIColor baseColor].CGColor;
    self.TextField.layer.cornerRadius = 4;
    self.TextField.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
    self.TextField.layer.borderWidth = 0.5;
    self.TextField.delegate = self;
    self.TextField.inputAccessoryView = self.ToolTextView;

    self.TextView.layer.cornerRadius = 4;
    self.TextView.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
    self.TextView.layer.borderWidth = 0.5;
    self.TextView.textColor = [UIColor lightGrayColor];
    self.TextView.text = TEXT;
    self.TextView.delegate = self;
    self.TextView.inputAccessoryView = self.ToolTextView;
    
    self.PickerView.delegate = self;
    self.PickerView.dataSource = self;
    [self addShadowToView:self.BackPickerView withColor:[UIColor lightGrayColor]];
    
    
    self.DataList = @[@{@"饮食类":@[@"早餐",@"午餐",@"晚餐",@"宵夜",@"聚会",@"零食",@"水果",@"饮料",@"烟酒",@"其他"]},
                      @{@"交通类":@[@"火车",@"飞机",@"打的",@"公交",@"其他"]},
                      @{@"日常类":@[@"租房",@"物业",@"水电",@"其他"]},
                      @{@"购物类":@[@"衣裤鞋帽",@"家具家电",@"书籍杂志",@"日常用品",@"化妆用品",@"手机配件",@"其他"]},
                      @{@"娱乐类":@[@"唱歌",@"电影",@"旅游",@"游戏",@"其他"]},
                      @{@"其他分类":@[@"其他"]}];
    
    
    
    if (self.model) {
        self.SelectRow = self.model.conType.integerValue?self.model.conType.integerValue-1:0;
        [self.PickerView selectRow:self.SelectRow inComponent:0 animated:YES];
        NSArray *arr = [(NSDictionary *)self.DataList[self.SelectRow] allValues][0];
        [self pickerView:self.PickerView didSelectRow:self.SelectRow inComponent:0];
        
        NSArray *NameArr = [self.model.accountName componentsSeparatedByString:@"-"];
        self.Select2Row = [arr indexOfObject:NameArr[1]];
        for (int i =0 ; i <arr.count; i++) {
            if ([NameArr[1] isEqualToString:arr[i]]) {
                self.Select2Row = i;
                break;
            }
        }
        
        [self.PickerView selectRow:self.Select2Row inComponent:1 animated:YES];
        [self pickerView:self.PickerView didSelectRow:self.Select2Row inComponent:1];
        
        self.TextField.text = self.model.accountPrice;
        if (self.model.remark.length) {
            self.TextView.text = self.model.remark;
            self.TextView.textColor = [UIColor blackColor];
        }else{
            self.TextView.textColor = [UIColor lightGrayColor];
            self.TextView.text = TEXT;
        }
        
    }
    
    
    
    
    
}

/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 4;
    theView.layer.masksToBounds = NO;
    
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


#pragma mark - tagter
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    //匹配以0开头的数字
    NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
    //匹配两位小数、整数
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7? YES : NO;
}
#pragma mark - TextViewDelegate

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


//当编辑时动态判断是否超过规定字数，这里限制30字
- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.TextView) {
        //        if (textView.text.length > 30) {
        //            textView.text = [textView.text substringToIndex:30];
        //        }
        /**
         *  最大输入长度,中英文字符都按一个字符计算
         */
        static int kMaxLength = 30;
        
        NSString *toBeString = textView.text;
        // 获取键盘输入模式
        NSString *lang = [textView.textInputMode primaryLanguage];
        // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
        // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮选择部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > kMaxLength) {
                    // 截取子串
                    textView.text = [toBeString substringToIndex:kMaxLength];
                }
            } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        } else {
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }
    
}


//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1) {
        return ((NSArray *)((NSDictionary *)self.DataList[self.SelectRow]).allValues[0]).count;
    }
    return self.DataList.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 1) {
        NSArray *arr = [(NSDictionary *)self.DataList[self.SelectRow] allValues][0];
        return arr[row];
    }
    NSMutableArray *a = [NSMutableArray array];
    for (NSDictionary *dic in self.DataList) {
        [a addObject:[dic allKeys][0]];
    }
    return a[row];
}
// 给pickerview设置字体大小和颜色等
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        if (self.SelectRow == row &&component == 0) {
            pickerLabel.textColor = [UIColor baseColor];
        }
        if (self.Select2Row == row &&component == 1) {
            pickerLabel.textColor = [UIColor baseColor];
        }
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    return pickerLabel;
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.SelectRow = row;
        self.Select2Row = 0;
        [self.PickerView selectRow:self.Select2Row inComponent:1 animated:NO];
        [self pickerView:self.PickerView didSelectRow:self.Select2Row inComponent:1];
        [self.PickerView reloadAllComponents];
    }else if (component == 1){
        self.Select2Row = row;
        [self.PickerView reloadAllComponents];
    }
    //刷新picker，看上面的代理
}


- (IBAction)SaveTouch:(UIButton *)sender {
    if (self.TextField.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请输入消费金额" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestQueryUpdateAccount];
}
- (IBAction)cancelTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)butClick{
    [self requestQueryDeleteAccount];
}
#pragma mark - request
-(void)requestQueryDeleteAccount{
    NSDictionary *dic = @{@"id":self.model.id,
                          @"delStatus":@"1"
                        };
    [NetApiManager requestQueryUpdateAccount:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    if (self.block) {
                        self.block(0);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
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
    
-(void)requestQueryUpdateAccount{
    NSMutableArray *a = [NSMutableArray array];
    for (NSDictionary *dic in self.DataList) {
        [a addObject:[dic allKeys][0]];
    }
    NSArray *arr = [(NSDictionary *)self.DataList[self.SelectRow] allValues][0];
 
    NSString *accName = [NSString stringWithFormat:@"%@-%@",a[self.SelectRow],arr[self.Select2Row]];
    
    NSDictionary *dic;
    if (self.model) {       //修改
        dic = @{@"id":self.model.id,
                @"accountName":accName,
                @"accountPrice":[NSString stringWithFormat:@"%@",self.TextField.text],
                @"remark":[self.TextView.textColor isEqual:[UIColor lightGrayColor]]?@"":self.TextView.text,
                @"conType":[NSString stringWithFormat:@"%ld",self.SelectRow+1],
                @"time":self.currentDateString 
                };
    }else{
        dic = @{
                @"accountName":accName,
                @"accountPrice":[NSString stringWithFormat:@"%@",self.TextField.text],
                @"remark":[self.TextView.textColor isEqual:[UIColor lightGrayColor]]?@"":self.TextView.text,
                @"conType":[NSString stringWithFormat:@"%ld",self.SelectRow+1],
                @"time":self.currentDateString
                };
    }
    
    [NetApiManager requestQueryUpdateAccount:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    if (self.block) {
                        self.block(0);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
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

@end
