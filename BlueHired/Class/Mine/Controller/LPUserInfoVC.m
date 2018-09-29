//
//  LPUserInfoVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPUserInfoVC.h"
#import "LPUserMaterialModel.h"

@interface LPUserInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIView *tableHeaderView;
@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;


@property(nonatomic,strong) UIButton *maleButton;
@property(nonatomic,strong) UIButton *femaleButton;
@property(nonatomic,strong) UILabel *birthLabel;

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) NSString *birthdate;

@end

@implementation LPUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人资料";
    
    self.userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"昵称：";
        UITextField *textField = [[UITextField alloc]init];
        textField.frame = CGRectMake(70, 5, SCREEN_WIDTH-140, 34);
        textField.text = self.userMaterialModel.data.user_name;
        [cell.contentView addSubview:textField];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"性别";
        UIButton *btn1 = [[UIButton alloc]init];
        btn1.frame = CGRectMake(70, 5, 50, 34);
        [btn1 setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
        [btn1 setTitle:@"男" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
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
        btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [btn2 addTarget:self action:@selector(touchFemaleButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn2];
        self.femaleButton = btn2;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"生日：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(70, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        [cell.contentView addSubview:label];
        self.birthLabel = label;
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"情感状态：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"曾任职工作：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 5){
        cell.textLabel.text = @"工作年限：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 6){
        cell.textLabel.text = @"期望工资：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 7){
        cell.textLabel.text = @"理想岗位：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)touchMaleButton:(UIButton *)button{
    button.selected = YES;
    self.femaleButton.selected = NO;
}
-(void)touchFemaleButton:(UIButton *)button{
    button.selected = YES;
    self.maleButton.selected = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.bgView.backgroundColor = [UIColor lightGrayColor];
        self.bgView.alpha = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
        [self.bgView addGestureRecognizer:tap];
        
        self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
        self.popView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3-30, SCREEN_WIDTH/2, 20)];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:cancelButton];
        
        UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-30, SCREEN_WIDTH/2, 20)];
        //        confirmButton.backgroundColor = [UIColor redColor];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmBirthday) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:confirmButton];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, SCREEN_HEIGHT/3-60)];
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
        
        [UIView animateWithDuration:0.5 animations:^{
            self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
            self.bgView.alpha = 0.3;
        } completion:^(BOOL finished) {
            nil;
        }];
    }
}
-(void)confirmBirthday{
    self.birthLabel.text = self.birthdate;
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
