//
//  LPBusinessReviewWageVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/10.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBusinessReviewWageVC.h"
#import "HXPhotoPicker.h"
#import "LPTools.h"
#import "LPMechanismModel.h"
//#import "ZMCusCommentView.h"



@interface LPBusinessReviewWageVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HXPhotoViewDelegate,HXAlbumListViewControllerDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIPickerView *pickerView;

@property(nonatomic,strong) NSArray *pickerArray;


@property(nonatomic,assign) NSInteger select1;




@property(nonatomic,assign) NSInteger selectIndex;


@property (weak, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property(nonatomic,strong) NSArray <UIImage *>*imageArray;
@property(nonatomic,strong) NSArray *imageUrlArray;

@property(nonatomic,strong) UIImageView *headImgView;
@property(nonatomic,strong) NSString *userUrl;

@property (nonatomic,strong) UIView *ToolTextView;

@property(nonatomic,strong) NSArray *TypeList;

@property (weak, nonatomic) IBOutlet UILabel *MechanisNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PostLabel;
@property (weak, nonatomic) IBOutlet UILabel *MonthLabel;
@property (weak, nonatomic) IBOutlet UITextField *idealMoneyTF;
@property (weak, nonatomic) IBOutlet UITextField *salaryMonthTF;



@end

@implementation LPBusinessReviewWageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.title = @"晒工资";
    self.userUrl = @"";
    [self setTextFieldView];
 
    self.idealMoneyTF.delegate = self;
    self.salaryMonthTF.delegate = self;
    self.idealMoneyTF.inputAccessoryView = self.ToolTextView;
    self.salaryMonthTF.inputAccessoryView = self.ToolTextView;

    self.MechanisNameLabel.text = self.mechanismlistDataModel.mechanismName;
 
    
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.lineCount = 1;
    photoView.delegate = self;
    photoView.addImageName = @"upload";
    //    photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoView];
    self.photoView = photoView;
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.top.equalTo(self.salaryMonthTF.mas_bottom).offset(LENGTH_SIZE(16));
        make.width.height.mas_equalTo(LENGTH_SIZE(114));
    }];
    [self.photoView refreshView];
    [self requestQueryGetMechanismTypeList];

    
    
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



- (IBAction)TouchButtonAlert:(id)sender {
    [self TouchTextCancel:nil];
    [self alertView];
//    [[ZMCusCommentManager shareManager] showCommentWithSourceId:nil];

}

- (IBAction)touchButtonMonth:(id)sender {
    [self TouchTextCancel:nil];
    NSComparisonResult sCOM= [[NSDate date] compare:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]];
    
    if (sCOM == NSOrderedAscending) {
        
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"系统时间不对,请前往设置修改时间" message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alert show];
        return;
    }
    
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWith:[NSDate date]
                                                                            minDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]
                                                                            maxDate:[NSDate date]
                                                                           Response:^(NSString *str) {
                                                                               NSLog(@"str = %@", str);
                                                                               NSString *Month = [DataTimeTool getDataTime:str DateFormat:@"yyyy年MM月" oldDateFormat:@"yyyy-MM"];
                                                                               self.MonthLabel.text = Month;
                                                                               self.MonthLabel.textColor = [UIColor colorWithHexString:@"#333333"];
                                                                           }];
    [datePickerView show];
}

- (IBAction)TouchLogoutButton:(id)sender {
    
    if ([self.PostLabel.text isEqualToString:@"请选择岗位"]) {
        [self.view showLoadingMeg:@"请选择您的岗位" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if ([self.MonthLabel.text isEqualToString:@"请选择薪资月份"]) {
        [self.view showLoadingMeg:@"请选择薪资月份" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.idealMoneyTF.text.floatValue == 0)
    {
        [self.view showLoadingMeg:@"请输入应发工资" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.salaryMonthTF.text.floatValue == 0)
    {
        [self.view showLoadingMeg:@"请输入实发工资" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    
    NSDictionary *dic = @{
                          @"idealMoney":[LPTools isNullToString:self.idealMoneyTF.text],
                          @"payrollUrl":self.userUrl,
                          @"post":[LPTools isNullToString:self.PostLabel.text],
                          @"realMoney":[LPTools isNullToString:self.salaryMonthTF.text],
                          @"salaryMonth":self.MonthLabel.text,
                          @"mechanismId":self.mechanismlistDataModel.id
                          };
    
    
    [NetApiManager requestQueryBusinessWageParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue]== 1)
                {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"提交成功，等待系统审核！" time:MESSAGE_SHOW_TIME];
                         [self.navigationController popViewControllerAnimated:YES];
                 }else{
                    [self.view showLoadingMeg:@"发送失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


#pragma mark lazy
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 1; //
//                _manager.configuration.videoMaxNum = 1;  //
        //        _manager.configuration.maxNum = 6;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoCanEdit = NO;
        //        _manager.configuration.selectTogether = NO;
        _manager.configuration.changeAlbumListContentView = NO;
        [_manager preloadData];
    }
    return _manager;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}


-(void)alertView{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.bgView addGestureRecognizer:tap];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    self.popView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
  
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,  10, SCREEN_WIDTH/2, 20)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);

    [self.popView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,  10, SCREEN_WIDTH/2, 20)];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBirthday) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self.popView addSubview:confirmButton];
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.popView addSubview:pickerView];
    self.pickerView = pickerView;
    [self.pickerView reloadAllComponents];
    
    [pickerView selectRow:self.select1 inComponent:0 animated:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        nil;
    }];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
        return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.TypeList.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = self.TypeList[row];
        [view addSubview:text];
  
//    //隐藏上下直线
//    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
//    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    return view;
}
//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [self.pickerArray objectAtIndex:row];
    return str;
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [self.pickerArray objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
}


-(void)confirmBirthday{
    self.select1 = [self.pickerView selectedRowInComponent:0];

    self.PostLabel.text = self.TypeList[self.select1];
    self.PostLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self removeView];
}

-(void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self.bgView removeFromSuperview];
        
    }];
}

#pragma mark - HXPhotoViewDelegate

-(void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
 
        [self.toolManager getSelectedImageList:photos requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
            self.userUrl= @"";
            if (imageList.count > 0) {
                 [self updateHeadImage:imageList[0]];
             }
        } failed:^{
            
        }];
 
 
}


#pragma mark - updateImage
-(void)updateHeadImage:(UIImage *)image{
    [NetApiManager avartarChangeWithParamDict:nil singleImage:image singleImageName:@"file" withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                self.userUrl = responseObject[@"data"];
                [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userUrl] placeholderImage:[UIImage imageNamed:@"mine_headimg_placeholder"]];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetMechanismTypeList{
    NSDictionary *dic = @{@"mechanismId":self.mechanismlistDataModel.id};
    [NetApiManager requestQueryGetMechanismTypeList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.TypeList = [responseObject[@"data"] mj_JSONObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
