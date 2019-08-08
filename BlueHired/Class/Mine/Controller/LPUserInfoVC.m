//
//  LPUserInfoVC.m
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPUserInfoVC.h"
#import "LPUserMaterialModel.h"
#import "LPMechanismModel.h"
#import "LPUserInfoCell.h"
#import "LPSalarycCard2VC.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

static NSString* LPUserInfoCellID = @"LPUserInfoCell";

@interface LPUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIView *tableHeaderView;
@property (nonatomic, strong)UIView *tableFooterView;

@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;



@property(nonatomic,strong) NSString *birthdate;

@property(nonatomic,strong) NSString *qinggan;

@property(nonatomic,strong) NSString *cengzaizhi;

@property(nonatomic,strong) NSString *nianxian;

@property(nonatomic,strong) NSString *xinzi;

@property(nonatomic,strong) NSString *lixaing;

@property(nonatomic,assign) NSInteger selectIndex;

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIPickerView *pickerView;

@property(nonatomic,strong) NSArray *pickerArray;

//@property(nonatomic,strong) NSArray *p1Array;
@property(nonatomic,strong) NSArray *p2Array;
@property(nonatomic,assign) NSInteger select1;


@property(nonatomic,strong) LPMechanismModel *TypeList;

@property(nonatomic,strong) NSArray *TitleArr;
@property(nonatomic,strong) NSMutableArray <UIButton *> *HeadBtnList;
@property(nonatomic,strong) NSMutableArray <UILabel *> *HeadLabelList;
@property(nonatomic,strong) UIView *figureView;
@property(nonatomic,strong) NSArray *MoneyTerms;
@property(nonatomic,strong) UILabel *dataComplete;


@end

@implementation LPUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人资料";
    self.TitleArr = @[@[@"头像",@"昵称",@"性别",@"生日",@"情感状况"],
                      @[@"曾任职工作",@"工作年限",@"期望薪资",@"理想岗位"],
                      @[@"实名认证",@"工资卡绑定"]];
    
//    self.userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
//    NSDictionary *dic = [self.userMaterialModel mj_keyValues];
//    self.userDic = [LPUserMaterialModel mj_objectWithKeyValues:dic];
    self.HeadBtnList = [[NSMutableArray alloc] init];
    self.HeadLabelList = [[NSMutableArray alloc] init];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestUserMaterialSelectMechanism];
    [self requestUserMaterial];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)TouchSave:(UIButton *)sender{
    [self requestSaveOrUpdate];
}

-(void)selectUserSex{
    UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *Alert1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.userMaterialModel.data.user_sex = @(1);
        [self.tableview reloadData];
        
    }];
    UIAlertAction *Alert2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.userMaterialModel.data.user_sex = @(2);
        [self.tableview reloadData];
    }];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"取  消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
 
    
    
    [AlertController addAction:Alert1];
    [AlertController addAction:Alert2];
    [AlertController addAction:Cancel];
    
    [self presentViewController:AlertController animated:YES completion:^{}];
}


-(void)TouchMatPlan:(UIButton *)sender{
    if (sender.tag == 100) {
        return;
    }
    NSArray *ArrPlan = @[@"30",@"60",@"80",@"100"];
    NSArray *ArrMoney = @[@"1",@"1",@"2",@"4"];
    [self requestUserMatPlan:ArrMoney[sender.tag] Plan:ArrPlan[sender.tag]];
}


#pragma mark - TableViewDelegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 4;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LENGTH_SIZE(60);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIView *lineV = [[UIView alloc] init];
    [view addSubview:lineV];
    [lineV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(10));
    }];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(10));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.height.mas_offset(LENGTH_SIZE(50));
    }];
    label.textColor = [UIColor baseColor];
    label.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    if (section == 0) {
        label.text = @"基本资料";
    }else if (section == 1){
        label.text = @"工作经历";
    }else if (section == 2){
        label.text = @"实名信息";
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return LENGTH_SIZE(60);
    }
    return LENGTH_SIZE(48);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LPUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPUserInfoCellID];
    cell.TitleLabel.text = self.TitleArr[indexPath.section][indexPath.row];
    cell.ContentLabel.hidden = NO;
    cell.ArrowsImage.hidden = NO;
    cell.NameTF.hidden = YES;
    cell.UserImage.hidden = YES;
    
    cell.ContentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.ContentLabel.layer.borderColor = [UIColor clearColor].CGColor;
    cell.ContentLabel.layer.borderWidth = 0;
    cell.ContentLabel.layer.cornerRadius = LENGTH_SIZE(0);
    cell.ContentLabel.font = FONT_SIZE(16);
    cell.Model = self.userMaterialModel.data;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {       //头像
            cell.ContentLabel.hidden = YES;
            cell.ArrowsImage.hidden = YES;
            cell.UserImage.hidden = NO;
            [cell.UserImage sd_setImageWithURL:[NSURL URLWithString:self.userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"avatar"]];
        }else if (indexPath.row == 1){      //昵称
            cell.ContentLabel.hidden = YES;
            cell.ArrowsImage.hidden = YES;
            cell.NameTF.hidden = NO;
            cell.NameTF.text = self.userMaterialModel.data.user_name;
        }else if (indexPath.row == 2){
            if (self.userMaterialModel.data.user_sex.integerValue == 0) {
                cell.ContentLabel.text = @"";
            }else if (self.userMaterialModel.data.user_sex.integerValue == 1){
                cell.ContentLabel.text = @"男";
            }else if (self.userMaterialModel.data.user_sex.integerValue == 2){
                cell.ContentLabel.text = @"女";
            }
        }else if (indexPath.row == 3){
            cell.ContentLabel.text = self.userMaterialModel.data.birthday;
        }else if (indexPath.row == 4){
            if (self.userMaterialModel.data.marry_status.integerValue == 0) {
                cell.ContentLabel.text = @"保密";
            }else if (self.userMaterialModel.data.marry_status.integerValue == 1){
                cell.ContentLabel.text = @"未婚";
            }else if (self.userMaterialModel.data.marry_status.integerValue == 2){
                cell.ContentLabel.text = @"已婚";
            }else if (self.userMaterialModel.data.marry_status.integerValue == 3){
                cell.ContentLabel.text = @"单身";
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.ContentLabel.text = self.userMaterialModel.data.work_type;
        }else if (indexPath.row == 1){
            if (self.userMaterialModel.data.work_years.integerValue == 6) {
                cell.ContentLabel.text = [NSString stringWithFormat:@"%ld+年",(long)self.userMaterialModel.data.work_years.integerValue];
            }else{
                cell.ContentLabel.text = [NSString stringWithFormat:@"%ld年",(long)self.userMaterialModel.data.work_years.integerValue];
            }
        }else if (indexPath.row == 2){
            cell.ContentLabel.text = self.userMaterialModel.data.ideal_money;
        }else if (indexPath.row == 3){
            cell.ContentLabel.text = self.userMaterialModel.data.ideal_post;
        }
    }else if (indexPath.section == 2){
        cell.ArrowsImage.hidden = YES;
        cell.ContentLabel.textColor = [UIColor baseColor];
        cell.ContentLabel.layer.borderColor = [UIColor baseColor].CGColor;
        cell.ContentLabel.layer.borderWidth = 1;
        cell.ContentLabel.layer.cornerRadius = LENGTH_SIZE(12);
        cell.ContentLabel.font = FONT_SIZE(14);
        
        if (indexPath.row == 0) {
            if (self.userMaterialModel.data.isReal.integerValue == 0) {
                cell.ContentLabel.text = @"   去实名   ";
            }else{
                cell.ContentLabel.text = @"   已实名   ";
            }

        }else if (indexPath.row == 1){

            if (self.userMaterialModel.data.isBank.integerValue == 0) {
                cell.ContentLabel.text = @"   去绑定   ";
            }else{
                cell.ContentLabel.text = @"   已绑定   ";
            }
        }
    }
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self tuchHeadImgView];
        }else if (indexPath.row == 2){
            [self selectUserSex];
        }else if (indexPath.row == 3){
            [self alertView:2];
        }else if (indexPath.row == 4){
            [self alertView:3];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self alertView:4];
        }else if (indexPath.row == 1){
            [self alertView:5];
        }else if (indexPath.row == 2){
            [self alertView:6];
        }else if (indexPath.row == 3){
            [self alertView:7];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0 && self.userMaterialModel.data.isReal.integerValue == 0) {
            LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1 && self.userMaterialModel.data.isBank.integerValue == 0){
            LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

-(void)alertView:(NSInteger)index{
    self.selectIndex = index;
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
 
        if (component == 0) {
            text.text = self.TypeList.data[row].mechanismTypeName;
        }else{
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
        self.userMaterialModel.data.birthday = self.birthdate;
    }else if(self.selectIndex == 3){
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
        self.userMaterialModel.data.marry_status = qin;
    }else if(self.selectIndex == 4){
        self.userMaterialModel.data.work_type = self.cengzaizhi;
    }else if(self.selectIndex == 5){
        self.userMaterialModel.data.work_years = [NSNumber numberWithInteger:[self.nianxian substringToIndex:self.nianxian.length-1].integerValue];
    }else if(self.selectIndex == 6){
        self.userMaterialModel.data.ideal_money = self.xinzi;
    }else if(self.selectIndex == 7){
        self.userMaterialModel.data.ideal_post = self.lixaing;
    }
    [self removeView];
    [self.tableview reloadData];
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

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
    NSArray *ArrPlan = @[@"30",@"60",@"80",@"100"];

    self.dataComplete.text = [NSString stringWithFormat:@"完善度：%@%%",userMaterialModel.data.dataComplete];
    
    //进度
    self.figureView.backgroundColor = [UIColor colorWithHexString:@"#0096FF"];
    
    CGFloat ViewWidth = (SCREEN_WIDTH - LENGTH_SIZE(36)) * userMaterialModel.data.dataComplete.integerValue / 100;
    
    [self.figureView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(ViewWidth);
    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,ViewWidth,LENGTH_SIZE(12));
    gl.startPoint = CGPointMake(0, 1);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#49F9FF"].CGColor,
                  (__bridge id)[UIColor colorWithHexString:@"#1FA3FF"].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.figureView.layer addSublayer:gl];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableHeaderView layoutIfNeeded];
    }];
    
    for (NSInteger i = 0 ; i < 4 ; i++) {
        NSString *Plan = ArrPlan[i];
        UIButton *btn = self.HeadBtnList[i];
        NSString *Terms =self.MoneyTerms[i];
        
        UILabel *label = self.HeadLabelList[i];
        
        if (userMaterialModel.data.dataComplete.integerValue < Plan.integerValue) {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(LENGTH_SIZE(18) + (SCREEN_WIDTH-LENGTH_SIZE(36))*Terms.floatValue - LENGTH_SIZE(10));
                make.width.height.mas_offset(LENGTH_SIZE(20));
            }];
            btn.tag = 100;
            label.hidden = YES;
        }else{
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(LENGTH_SIZE(18) + (SCREEN_WIDTH-LENGTH_SIZE(36))*Terms.floatValue - LENGTH_SIZE(15));
                make.width.height.mas_offset(LENGTH_SIZE(30));
            }];
            btn.tag = i;
            label.hidden = NO;
        }
    }
    
    
    for (LPUserMaterialPlanDataModel *Plan in userMaterialModel.data.userMaterialPlanList) {
        NSInteger index = [ArrPlan indexOfObject:Plan.plan];

        UILabel *label = self.HeadLabelList[index];
        label.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
        label.font = FONT_SIZE(11);
        label.text = @"已领取";
        
        NSString *Terms =self.MoneyTerms[index];
        UIButton *btn = self.HeadBtnList[index];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(18) + (SCREEN_WIDTH-LENGTH_SIZE(36))*Terms.floatValue - LENGTH_SIZE(10));
            make.width.height.mas_offset(LENGTH_SIZE(20));
        }];
        btn.tag = 100;
    }
    
  

}

#pragma mark - request
-(void)requestSaveOrUpdate{
    NSDictionary *dic = [self.userMaterialModel.data mj_keyValues];
    
    NSString *string = [NSString stringWithFormat:@"userMaterial/saveOrUpdate?userSex=%@&userName=%@&userUrl=%@",
                        self.userMaterialModel.data.user_sex,
                        self.userMaterialModel.data.user_name,
                        self.userMaterialModel.data.user_url];
    [NetApiManager requestSaveOrUpdateWithParam:string withParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"个人资料保存失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
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
            if ([responseObject[@"code"] integerValue] == 0) {
                self.userMaterialModel = [LPUserMaterialModel mj_objectWithKeyValues:responseObject];
                
                [self.tableview reloadData];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//获取职位
-(void)requestUserMaterialSelectMechanism{
    NSDictionary *dic = @{};
    [NetApiManager requestUserMaterialSelectMechanism:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
               self.TypeList = [LPMechanismModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//获取职位
-(void)requestUserMatPlan:(NSString *) Money Plan:(NSString *) plan{
    NSDictionary *dic = @{
                          @"money":Money,
                          @"plan":plan
                          };
    [NetApiManager requestUserMatPlan:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0 ) {
                    LPUserMaterialPlanDataModel *PlanModel = [[LPUserMaterialPlanDataModel alloc] init];
                    PlanModel.money = Money;
                    PlanModel.plan = plan;
                    if (self.userMaterialModel.data.userMaterialPlanList.count == 0) {
                        self.userMaterialModel.data.userMaterialPlanList = [[NSMutableArray alloc] init];
                    }
                    [self.userMaterialModel.data.userMaterialPlanList addObject:PlanModel];
                    [LPTools AlertUserInfoView:@""];
                
                    [self setUserMaterialModel:self.userMaterialModel];
                }else{
                    [self.view showLoadingMeg:@"领取失败" time:MESSAGE_SHOW_TIME];
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
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.tableFooterView = self.tableFooterView;
        [_tableview registerNib:[UINib nibWithNibName:LPUserInfoCellID bundle:nil] forCellReuseIdentifier:LPUserInfoCellID];
    }
    return _tableview;
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *dataComplete = [[UILabel alloc] init];
        self.dataComplete = dataComplete;
        [_tableHeaderView addSubview:dataComplete];
        [dataComplete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(13));
            make.top.mas_offset(LENGTH_SIZE(13));
        }];
        dataComplete.textColor = [UIColor baseColor];
        dataComplete.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        dataComplete.text = @"完善度：0%";
        
        UIImageView *calibrationImage = [[UIImageView alloc] init];
        [_tableHeaderView addSubview:calibrationImage];
        [calibrationImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(18));
            make.right.mas_offset(LENGTH_SIZE(-18));
            make.bottom.mas_offset(LENGTH_SIZE(-13));
            make.height.mas_offset(LENGTH_SIZE(8));
        }];
        calibrationImage.image = [UIImage imageNamed:@"bar_figure"];
        
        UIImageView *backImage = [[UIImageView alloc] init];
        [_tableHeaderView addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(18));
            make.right.mas_offset(LENGTH_SIZE(-18));
            make.bottom.equalTo(calibrationImage.mas_top).offset(LENGTH_SIZE(-7));
            make.height.mas_offset(LENGTH_SIZE(12));
        }];
        backImage.image = [UIImage imageNamed:@"bar_bg"];
        backImage.clipsToBounds = YES;
        backImage.layer.cornerRadius = LENGTH_SIZE(6);
        
        UIView *FigureView = [[UIView alloc] init];
        self.figureView = FigureView;
        [backImage addSubview:FigureView];
        [FigureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(LENGTH_SIZE(0));
            make.height.mas_offset(LENGTH_SIZE(12));
            make.width.mas_offset(0);
        }];
        
        self.MoneyTerms = @[@"0.3",@"0.6",@"0.8",@"0.965"];
        NSArray *ImageTerms = @[@"gold_1",@"gold_1",@"gold_2",@"gold_4"];

        for (NSInteger i = 0 ; i < 4 ; i++) {
            NSString *Terms = self.MoneyTerms[i];
            
            UIButton *btn = [[UIButton alloc] init];
            [_tableHeaderView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(backImage.mas_top).offset(LENGTH_SIZE(-4));
                make.left.mas_offset(LENGTH_SIZE(18) + (SCREEN_WIDTH-LENGTH_SIZE(36))*Terms.floatValue - LENGTH_SIZE(15));
                make.width.height.mas_offset(LENGTH_SIZE(30));
            }];
            [btn setImage:[UIImage imageNamed:ImageTerms[i]] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(TouchMatPlan:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *Label = [[UILabel alloc] init];
            [_tableHeaderView addSubview:Label];
            [Label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(btn.mas_top).offset(0);
                make.centerX.equalTo(btn);
            }];
            Label.text = @"点击领取";
            Label.textColor = [UIColor colorWithHexString:@"#FFB033"];
            Label.font = FONT_SIZE(12);
            
            [self.HeadBtnList addObject:btn];
            [self.HeadLabelList addObject:Label];
            
        }
        
    }
    
    return _tableHeaderView;
}

-(UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(118))];
        UIButton *saveBtn = [[UIButton alloc] init];
        [_tableFooterView addSubview:saveBtn];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(29));
            make.left.mas_offset(LENGTH_SIZE(18));
            make.right.mas_offset(LENGTH_SIZE(-18));
            make.height.mas_offset(LENGTH_SIZE(48));
        }];
        saveBtn.backgroundColor = [UIColor baseColor];
        saveBtn.layer.cornerRadius = 6;
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(TouchSave:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableFooterView;
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
                self.userMaterialModel.data.user_url = responseObject[@"data"];
                [self.tableview reloadData];
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
