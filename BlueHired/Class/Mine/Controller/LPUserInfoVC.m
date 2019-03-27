//
//  LPUserInfoVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPUserInfoVC.h"
#import "LPUserMaterialModel.h"
#import "LPMechanismModel.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface LPUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIView *tableHeaderView;
@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;
@property(nonatomic,strong) UIImageView *headImgView;
@property(nonatomic,strong) UILabel *headIName;

@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *userUrl;

@property(nonatomic,strong) UIButton *maleButton;
@property(nonatomic,strong) UIButton *femaleButton;
@property(nonatomic,strong) NSNumber *userSex;

@property(nonatomic,strong) NSString *birthdate;
@property(nonatomic,strong) UILabel *birthLabel;

@property(nonatomic,strong) UILabel *qingganLabel;
@property(nonatomic,strong) NSString *qinggan;

@property(nonatomic,strong) UILabel *cengzaizhiLabel;
@property(nonatomic,strong) NSString *cengzaizhi;

@property(nonatomic,strong) UILabel *nianxianLabel;
@property(nonatomic,strong) NSString *nianxian;

@property(nonatomic,strong) UILabel *xinziLabel;
@property(nonatomic,strong) NSString *xinzi;

@property(nonatomic,strong) UILabel *lixaingLabel;
@property(nonatomic,strong) NSString *lixaing;

@property(nonatomic,assign) NSInteger selectIndex;

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIPickerView *pickerView;

@property(nonatomic,strong) NSArray *pickerArray;

//@property(nonatomic,strong) NSArray *p1Array;
@property(nonatomic,strong) NSArray *p2Array;
@property(nonatomic,assign) NSInteger select1;

@property(nonatomic,strong) UITextField *userNameTF;

@property(nonatomic,strong) LPUserMaterialModel *userDic;

@property(nonatomic,strong) LPMechanismModel *TypeList;

@end

@implementation LPUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人资料";
    
//    self.userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
//    NSDictionary *dic = [self.userMaterialModel mj_keyValues];
//    self.userDic = [LPUserMaterialModel mj_objectWithKeyValues:dic];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestUserMaterialSelectMechanism];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestUserMaterial];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self requestSaveOrUpdate];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//    if(cell == nil){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"昵称：";
        UITextField *textField = [[UITextField alloc]init];
        textField.frame = CGRectMake(70, 5, SCREEN_WIDTH-140, 34);
        textField.text = self.userMaterialModel.data.user_name;
        textField.textColor = [UIColor colorWithHexString:@"#434343"];
//        textField.delegate = self;
        self.userNameTF = textField;
        [textField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.userName = self.userMaterialModel.data.user_name;
        [cell.contentView addSubview:textField];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"性别";
        UIButton *btn1 = [[UIButton alloc]init];
        btn1.frame = CGRectMake(70, 5, 50, 34);
        [btn1 setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
        [btn1 setTitle:@"男" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:16];
        btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [btn1 addTarget:self action:@selector(touchMaleButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn1];
        self.maleButton = btn1;
        
        UIButton *btn2 = [[UIButton alloc]init];
        btn2.frame = CGRectMake(140, 5, 50, 34);
        [btn2 setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
        [btn2 setTitle:@"女" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:16];
        btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [btn2 addTarget:self action:@selector(touchFemaleButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn2];
        if (self.userMaterialModel.data.user_sex.integerValue == 1) {
            btn1.selected = YES;
        }else if (self.userMaterialModel.data.user_sex.integerValue == 2) {
            btn2.selected = YES;
        }
        self.userSex = self.userMaterialModel.data.user_sex;
        self.femaleButton = btn2;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"生日：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(70, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        label.text = self.userMaterialModel.data.birthday;
        self.birthLabel = label;
        
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"情感状态：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(100, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        if (self.userMaterialModel.data.marry_status.integerValue == 0) {
            label.text = @"保密";
        }else if (self.userMaterialModel.data.marry_status.integerValue == 1){
            label.text = @"未婚";
        }else if (self.userMaterialModel.data.marry_status.integerValue == 2){
            label.text = @"已婚";
        }else if (self.userMaterialModel.data.marry_status.integerValue == 3){
            label.text = @"单身";
        }
        self.qingganLabel = label;
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"曾任职工作：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(120, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        label.text = self.userMaterialModel.data.work_type;
        self.cengzaizhiLabel = label;
    }else if (indexPath.row == 5){
        cell.textLabel.text = @"工作年限：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(100, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
        label.text = [NSString stringWithFormat:@"%@年",self.userMaterialModel.data.work_years.stringValue];
        [cell.contentView addSubview:label];
        self.nianxianLabel = label;
    }else if (indexPath.row == 6){
        cell.textLabel.text = @"期望工资：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(100, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
        label.text = self.userMaterialModel.data.ideal_money;
        [cell.contentView addSubview:label];
        self.xinziLabel = label;
    }else if (indexPath.row == 7){
        cell.textLabel.text = @"理想岗位：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(100, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
        label.text = self.userMaterialModel.data.ideal_post;
        [cell.contentView addSubview:label];
        self.lixaingLabel = label;
    }
    return cell;
}

- (void)fieldTextDidChange:(UITextField *)textField

{
    
    /**
     
     *  最大输入长度,中英文字符都按一个字符计算
     
     */
    
    static int kMaxLength = 11;
    
    
    
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
    
    self.userName = textField.text;

}


-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.length > 0) {
        if (textField.text.length >11) {
            textField.text = [textField.text substringToIndex:11];
        }
        self.userName = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.userNameTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.userNameTF.text.length >= 11) {
            self.userNameTF.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

-(void)touchMaleButton:(UIButton *)button{
    button.selected = YES;
    self.femaleButton.selected = NO;
    self.userSex = @(1);
}
-(void)touchFemaleButton:(UIButton *)button{
    button.selected = YES;
    self.maleButton.selected = NO;
    self.userSex = @(2);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5  || indexPath.row == 6 || indexPath.row == 7) {
        self.selectIndex = indexPath.row;
        [self alertView:indexPath.row];
    }
}

-(void)alertView:(NSInteger)index{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.bgView addGestureRecognizer:tap];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    self.popView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
//    [self.popView addSubview:label];
    
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
    
    if (index == 2) {
        label.text = @"生日(年/月/日)";
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString=self.userMaterialModel.data.birthday;
        [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        NSDate *birthdaydate =[dateFormat dateFromString:dateString];
        self.birthdate = birthdaydate ? dateString : [dateFormat stringFromDate:[NSDate date]];
        datePicker.date = birthdaydate ? birthdaydate : [NSDate date];
        datePicker.maximumDate = [NSDate date];
        [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.popView addSubview:datePicker];
    }else if (index == 3 || index == 5 || index == 6){
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self.popView addSubview:pickerView];
        self.pickerView = pickerView;
        
        if (index == 3) {
            label.text = @"情感状态";
            self.pickerArray = @[@"单身",@"已婚",@"未婚",@"保密"];
            self.qinggan = self.pickerArray[0];
        }else if (index == 5){
            label.text = @"工作年限";
            self.pickerArray = @[@"1年",@"2年",@"3年",@"4年",@"5年",@"6+年"];
            self.nianxian = self.pickerArray[0];
        }else if (index == 6){
            label.text = @"期望薪资(月薪，单位：千元)";
            self.pickerArray = @[@"3k~4k",@"4k~5k",@"5k~6k",@"6k~7k",@"7k~8k",@"8k~9k",@"9k~10k",@"10+k"];
            self.xinzi = self.pickerArray[0];
        }
        [self.pickerView reloadAllComponents];
    }else if (index == 4 || index == 7){
        if (index == 4) {
            label.text = @"曾在职工作";
        }else{
            label.text = @"理想岗位";
        }
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self.popView addSubview:pickerView];
        self.pickerView = pickerView;
//        self.p1Array = @[@{@"服装厂":@[@"普工",@"服装新手",@"服装大师"]},
//                         @{@"电子厂":@[@"普工",@"司机",@"叉车工",@"仓管员"]},
//                         @{@"纺织厂":@[@"普工",@"纺织新手",@"纺织大师"]},
//                         @{@"鞋厂":@[@"普工",@"运动鞋工",@"休闲鞋工",@"皮鞋工"]},
//                         @{@"挖掘厂":@[@"普工",@"挖掘大师"]},
//                         @{@"食品厂":@[@"普工",@"吃货",@"吃货大师"]}];
        if (index == 4) {
            self.cengzaizhi = [NSString stringWithFormat:@"%@-%@",self.TypeList.data[0].mechanismTypeName,self.TypeList.data[0].workTypeList[0].workTypeName ];
        }else{
            self.lixaing = [NSString stringWithFormat:@"%@-%@",self.TypeList.data[0].mechanismTypeName,self.TypeList.data[0].workTypeList[0].workTypeName ];
        }
        [self.pickerView reloadAllComponents];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        nil;
    }];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.selectIndex == 4 || self.selectIndex == 7) {
        return 2;
    }else{
        return 1;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.selectIndex == 4 || self.selectIndex == 7) {
        if (component == 0) {
            return self.TypeList.data.count;
        }else{
//            return ((NSArray *)((NSDictionary *)self.p1Array[self.select1]).allValues[0]).count;
            return self.TypeList.data[self.select1].workTypeList.count;
        }
    }else{
        return [self.pickerArray count];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    if (self.selectIndex == 4 || self.selectIndex == 7) {
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 20)];
        text.textAlignment = NSTextAlignmentCenter;
//        NSMutableArray *a = [NSMutableArray array];
//        for (NSDictionary *dic in self.p1Array) {
//            [a addObject:[dic allKeys][0]];
//        }
        if (component == 0) {
//            text.text = a[row];
            text.text = self.TypeList.data[row].mechanismTypeName;
        }else{
//            NSArray *arr = [(NSDictionary *)self.p1Array[self.select1] allValues][0];
//            text.text = arr[row];
            text.text = self.TypeList.data[self.select1].workTypeList[row].workTypeName;
        }
        [view addSubview:text];
    }else{
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = [self.pickerArray objectAtIndex:row];
        [view addSubview:text];
    }
    //隐藏上下直线
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
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

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     if (self.selectIndex == 3) {
        self.qinggan = self.pickerArray[row];
    }else if (self.selectIndex == 4 || self.selectIndex == 7){
        if (component == 0) {
            self.select1 = [pickerView selectedRowInComponent:0];
            [pickerView reloadComponent:1];
        }
        //获取选中的省会
//        NSString *s = [self.p1Array[self.select1] allKeys][0];
        NSString *s = self.TypeList.data[self.select1].mechanismTypeName;
        //获取选中的城市
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
//        NSString *cityName = [self.p1Array[self.select1] allValues][0][cityIndex];
        NSString *cityName = self.TypeList.data[self.select1].workTypeList[cityIndex].workTypeName;
        if (self.selectIndex == 4) {
            self.cengzaizhi = [NSString stringWithFormat:@"%@-%@",s,cityName];
        }else{
            self.lixaing = [NSString stringWithFormat:@"%@-%@",s,cityName];
        }
        
    }else if (self.selectIndex == 5){
        self.nianxian = self.pickerArray[row];
    }else if (self.selectIndex == 6){
        self.xinzi = self.pickerArray[row];
    }
}

-(void)confirmBirthday{
    if (self.selectIndex == 2) {
        self.birthLabel.text = self.birthdate;
        self.userDic.data.birthday = self.birthdate;
    }else if(self.selectIndex == 3){
        self.qingganLabel.text = self.qinggan;
        //0保密1未婚 2已婚 3单身
        NSNumber *qin;
        if ([self.qinggan isEqualToString:@"保密"]) {
            qin = [NSNumber numberWithInteger:0];
        }else if ([self.qinggan isEqualToString:@"未婚"]){
            qin = [NSNumber numberWithInteger:1];
        }else if ([self.qinggan isEqualToString:@"已婚"]){
            qin = [NSNumber numberWithInteger:2];
        }else if ([self.qinggan isEqualToString:@"单身"]){
            qin = [NSNumber numberWithInteger:3];
        }
        self.userDic.data.marry_status = qin;
    }else if(self.selectIndex == 4){
        self.cengzaizhiLabel.text = self.cengzaizhi;
        self.userDic.data.work_type = self.cengzaizhi;
    }else if(self.selectIndex == 5){
        self.nianxianLabel.text = self.nianxian;
        self.userDic.data.work_years = [NSNumber numberWithInteger:[self.nianxian substringToIndex:self.nianxian.length-1].integerValue];
    }else if(self.selectIndex == 6){
        self.xinziLabel.text = self.xinzi;
        self.userDic.data.ideal_money = self.xinzi;
    }else if(self.selectIndex == 7){
        self.lixaingLabel.text = self.lixaing;
        self.userDic.data.ideal_post = self.lixaing;
    }
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
-(void)dateChange:(UIDatePicker *)datePicker{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:datePicker.date];
    self.birthdate = dateString;
}
#pragma mark - request
-(void)requestSaveOrUpdate{
    NSDictionary *dic = [self.userDic.data mj_keyValues];
    
    NSString *string = [NSString stringWithFormat:@"userMaterial/saveOrUpdate?userSex=%@&userName=%@&userUrl=%@",self.userSex,self.userName,self.userUrl];
    [NetApiManager requestSaveOrUpdateWithParam:string withParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestUserMaterial{
    NSString *string = kUserDefaultsValue(LOGINID);
    NSDictionary *dic = @{
                          @"id":string
                          };
    [NetApiManager requestUserMaterialWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        if (isSuccess) {
            self.userMaterialModel = [LPUserMaterialModel mj_objectWithKeyValues:responseObject];
            NSDictionary *dic = [self.userMaterialModel mj_keyValues];
            self.userDic = [LPUserMaterialModel mj_objectWithKeyValues:dic];
            self.userUrl = self.userMaterialModel.data.user_url;
            self.userSex = self.userMaterialModel.data.user_sex;
            self.userName = self.userMaterialModel.data.user_name;
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"mine_headimg_placeholder"]];
            self.headIName.text = self.userMaterialModel.data.user_name;

            [self.tableview reloadData];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestUserMaterialSelectMechanism{
    NSDictionary *dic = @{};
    [NetApiManager requestUserMaterialSelectMechanism:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.TypeList = [LPMechanismModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableview.tableHeaderView = self.tableHeaderView;

    }
    return _tableview;
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 138.0);
//        _tableHeaderView.backgroundColor = [UIColor baseColor];
        
        UIImageView *BgImage = [[UIImageView alloc] initWithFrame:_tableHeaderView.frame];
        BgImage.image = [UIImage imageNamed:@"UserInfoBGImage"];

        [_tableHeaderView addSubview:BgImage];

        
        UIImageView *headImgView = [[UIImageView alloc]init];
        [_tableHeaderView addSubview:headImgView];
        [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.equalTo(self.tableHeaderView);
            make.size.mas_equalTo(CGSizeMake(72, 72));
        }];
        [headImgView sd_setImageWithURL:[NSURL URLWithString:self.userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"mine_headimg_placeholder"]];
        headImgView.layer.masksToBounds = YES;
        headImgView.layer.cornerRadius = 36;
        headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        headImgView.layer.borderWidth = 2.0;
        headImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuchHeadImgView)];
        [headImgView addGestureRecognizer:tap];
        self.headImgView = headImgView;
        
        UILabel *label = [[UILabel alloc]init];
        [_tableHeaderView addSubview:label];
        self.headIName = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headImgView.mas_bottom).offset(10);
            make.centerX.equalTo(headImgView);
        }];
        label.text = self.userMaterialModel.data.user_name;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        
    }
    
    return _tableHeaderView;
}

-(void)setTypeList:(LPMechanismModel *)TypeList{
    _TypeList = TypeList;
    
}

-(void)tuchHeadImgView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
#if (TARGET_IPHONE_SIMULATOR)
                                                          
#else
                                                          [self takePhoto];
#endif
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self choosePhoto];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {

                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
-(void)takePhoto{
    
//#if (TARGET_IPHONE_SIMULATOR)
//
//#else
//    [self startDevice];
//#endif
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请进入设置-隐私-相机-中打开相机权限"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)choosePhoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}


- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *headImage = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    [self updateHeadImage:headImage];
}
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - updateImage
-(void)updateHeadImage:(UIImage *)image{
    [NetApiManager avartarChangeWithParamDict:nil singleImage:image singleImageName:@"file" withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                self.userUrl = responseObject[@"data"];
                [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userUrl] placeholderImage:[UIImage imageNamed:@"mine_headimg_placeholder"]];
                [self requestSaveOrUpdate];
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
