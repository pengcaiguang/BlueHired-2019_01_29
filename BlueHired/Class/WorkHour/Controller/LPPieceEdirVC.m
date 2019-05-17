//
//  LPPieceEdirVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPPieceEdirVC.h"
#import "LPProListModel.h"
#import "LPLabourCostSetVC.h"

@interface LPPieceEdirVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *PickerView;
@property (weak, nonatomic) IBOutlet UIView *BackPickerView;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *NumberTF;
@property (nonatomic, strong) LPProListModel *Promodel;
@property (nonatomic,assign) NSInteger SelectRow;
@property (nonatomic,strong) UIView *ToolTextView;

@end

@implementation LPPieceEdirVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"计件信息";
    [self setTextFieldView];
    self.PickerView.delegate = self;
    self.PickerView.dataSource = self;
    [self addShadowToView:self.BackPickerView withColor:[UIColor lightGrayColor]];
    self.NumberTF.delegate = self;
    self.NumberTF.inputAccessoryView = self.ToolTextView;

    if (self.model) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(butClick:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
        self.NumberTF.text = reviseString(self.model.productNum);
 
    }else{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新增产品"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(butClick:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestQueryGetProList];
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


- (IBAction)TouchSave:(id)sender {
    if (self.NumberTF.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请输入数量" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestQueryUpdateProList];
}

-(void)butClick:(UIButton *)sender{
    if (self.model) {
        [self requestQueryDeleteProRecord];
    }else{
        LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
        vc.Type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.Promodel.data.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.Promodel.data objectAtIndex:row].productName;
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
        if (self.SelectRow == row) {
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
    self.SelectRow = row;
    //刷新picker，看上面的代理
    [self.PickerView reloadComponent:component];
    //    self.KQWeekLabel.text = self.DataList[row];
    self.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元/件",self.Promodel.data[row].productPrice.floatValue];
}

- (void)setPromodel:(LPProListModel *)Promodel{
    _Promodel = Promodel;
    if (Promodel.data.count) {
        [self.PickerView reloadAllComponents];
        if (self.model) {
            for (int i =0 ; i <Promodel.data.count; i++ ) {
                LPProListDataModel *m = Promodel.data[i];
                if (m.id.integerValue == self.model.productId.integerValue) {
                    self.SelectRow = i;
                    [self.PickerView selectRow:i inComponent:0 animated:YES];
                    [self pickerView:self.PickerView didSelectRow:i inComponent:0];
                    self.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元/件",m.productPrice.floatValue];
                    break;
                }
            }
        }else{
            LPProListDataModel *m = Promodel.data[0];
            self.SelectRow = 0;
            [self.PickerView selectRow:0 inComponent:0 animated:YES];
            [self pickerView:self.PickerView didSelectRow:0 inComponent:0];
            self.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元/件",m.productPrice.floatValue];
        }

    }
}

-(void)requestQueryGetProList{
 
    NSDictionary *dic = @{@"status":@(2)};
    [NetApiManager requestQueryGetProList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
         if (isSuccess) {
             if ([responseObject[@"code"] integerValue] == 0) {
                 self.Promodel = [LPProListModel mj_objectWithKeyValues:responseObject];
             }else{
                 [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
             }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


#pragma mark - request
-(void)requestQueryUpdateProList{
    NSDictionary *dic = @{@"id":self.model.id?self.model.id:@"",
                          @"productId":self.Promodel.data[self.SelectRow].id,
                          @"productNum":[NSString stringWithFormat:@"%ld",self.NumberTF.text.integerValue],
                          @"time":self.currentDateString
                          };
    [NetApiManager requestQueryUpdateProRecord:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    if (self.model.id) {
                        self.model.productId = self.Promodel.data[self.SelectRow].id;
                        self.model.productNum = [NSString stringWithFormat:@"%ld",self.NumberTF.text.integerValue];
                        self.model.productName = self.Promodel.data[self.SelectRow].productName;
                        self.model.productPrice = self.Promodel.data[self.SelectRow].productPrice;
                        self.model.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.productNum.floatValue * self.model.productPrice.floatValue];
                        
                    }else{
                        LPProRecirdDataModel *m = [[LPProRecirdDataModel alloc] init];
                        m.id = responseObject[@"data"];
                        m.productId = self.Promodel.data[self.SelectRow].id;
                        m.productNum = [NSString stringWithFormat:@"%ld",self.NumberTF.text.integerValue];
                        m.productName = self.Promodel.data[self.SelectRow].productName;
                        m.productPrice = self.Promodel.data[self.SelectRow].productPrice;
                        m.totalPrice = [NSString stringWithFormat:@"%.2f",m.productNum.floatValue * m.productPrice.floatValue];
                        [self.listArray addObject:m];
                    }
                    if (self.Block) {
                        self.Block();
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
-(void)requestQueryDeleteProRecord{
    NSDictionary *dic = @{@"id":self.model.id?self.model.id:@"",
                          @"delStatus":@(1)
                          };
    [NetApiManager requestQueryUpdateProRecord:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.listArray removeObject:self.model];
                    if (self.Block) {
                        self.Block();
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
