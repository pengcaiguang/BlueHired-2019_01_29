//
//  LPUserInfoVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPUserInfoVC.h"
#import "LPUserMaterialModel.h"

@interface LPUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIView *tableHeaderView;
@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;

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

@property(nonatomic,strong) NSArray *p1Array;
@property(nonatomic,strong) NSArray *p2Array;
@property(nonatomic,assign) NSInteger select1;

@property(nonatomic,strong) LPUserMaterialModel *userDic;

@end

@implementation LPUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人资料";
    
    self.userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
    NSDictionary *dic = [self.userMaterialModel mj_keyValues];
    self.userDic = [LPUserMaterialModel mj_objectWithKeyValues:dic];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self requestUserMaterial];
}
-(void)viewWillDisappear:(BOOL)animated{
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
    [self.popView addSubview:label];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3-30, SCREEN_WIDTH/2, 20)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-30, SCREEN_WIDTH/2, 20)];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBirthday) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:confirmButton];
    
    if (index == 2) {
        label.text = @"生日(年/月/日)";
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-60)];
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
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-60)];
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
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-60)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self.popView addSubview:pickerView];
        self.pickerView = pickerView;
        self.p1Array = @[@{@"服装厂":@[@"普工",@"服装新手",@"服装大师"]},
                         @{@"电子厂":@[@"普工",@"司机",@"叉车工",@"仓管员"]},
                         @{@"纺织厂":@[@"普工",@"纺织新手",@"纺织大师"]},
                         @{@"鞋厂":@[@"普工",@"运动鞋工",@"休闲鞋工",@"皮鞋工"]},
                         @{@"挖掘厂":@[@"普工",@"挖掘大师"]},
                         @{@"食品厂":@[@"普工",@"吃货",@"吃货大师"]}];
        if (index == 4) {
            self.cengzaizhi = [NSString stringWithFormat:@"%@-%@",[(NSDictionary *)self.p1Array[0] allKeys][0],[(NSDictionary *)self.p1Array[0] allValues][0][0]];
        }else{
            self.lixaing = [NSString stringWithFormat:@"%@-%@",[(NSDictionary *)self.p1Array[0] allKeys][0],[(NSDictionary *)self.p1Array[0] allValues][0][0]];
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
            return self.p1Array.count;
        }else{
            return ((NSArray *)((NSDictionary *)self.p1Array[self.select1]).allValues[0]).count;
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
        NSMutableArray *a = [NSMutableArray array];
        for (NSDictionary *dic in self.p1Array) {
            [a addObject:[dic allKeys][0]];
        }
        if (component == 0) {
            text.text = a[row];
        }else{
            NSArray *arr = [(NSDictionary *)self.p1Array[self.select1] allValues][0];
            text.text = arr[row];
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
    NSLog(@"HANG%@",[self.pickerArray objectAtIndex:row]);
    if (self.selectIndex == 3) {
        self.qinggan = self.pickerArray[row];
    }else if (self.selectIndex == 4 || self.selectIndex == 7){
        if (component == 0) {
            self.select1 = [pickerView selectedRowInComponent:0];
            [pickerView reloadComponent:1];
        }
        //获取选中的省会
        NSString *s = [self.p1Array[self.select1] allKeys][0];
        //获取选中的城市
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
        NSString *cityName = [self.p1Array[self.select1] allValues][0][cityIndex];
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
            [self.tableview reloadData];
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
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 138.0/360.0*SCREEN_WIDTH);
        _tableHeaderView.backgroundColor = [UIColor baseColor];
        
        UIImageView *headImgView = [[UIImageView alloc]init];
        [_tableHeaderView addSubview:headImgView];
        [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.equalTo(self.tableHeaderView);
            make.size.mas_equalTo(CGSizeMake(72, 72));
        }];
        [headImgView sd_setImageWithURL:[NSURL URLWithString:self.userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"mine_headimg_placeholder"]];
        self.userUrl = self.userMaterialModel.data.user_url;
        headImgView.layer.masksToBounds = YES;
        headImgView.layer.cornerRadius = 36;
        headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        headImgView.layer.borderWidth = 2.0;
        
        
        UILabel *label = [[UILabel alloc]init];
        [_tableHeaderView addSubview:label];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
