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


static const CGFloat kPhotoViewMargin = 13.0;

@interface LPBusinessReviewWageVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HXPhotoViewDelegate,HXAlbumListViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableHeaderView;


@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIPickerView *pickerView;

@property(nonatomic,strong) NSArray *pickerArray;

@property(nonatomic,strong) NSArray *p1Array;
@property(nonatomic,strong) NSArray *p2Array;
@property(nonatomic,assign) NSInteger select1;

@property(nonatomic,strong) UILabel *cengzaizhiLabel;
@property(nonatomic,strong) NSString *cengzaizhi;

@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;
@property(nonatomic,assign) NSInteger month;

@property(nonatomic,strong) UILabel *xinziLabel;
@property(nonatomic,strong) UITextField *yinfaTF;
@property(nonatomic,strong) UITextField *shifaTF;

@property(nonatomic,assign) NSInteger selectIndex;


@property (weak, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property(nonatomic,strong) NSArray <UIImage *>*imageArray;
@property(nonatomic,strong) NSArray *imageUrlArray;

@property(nonatomic,strong) UIImageView *headImgView;
@property(nonatomic,strong) NSString *userUrl;



@end

@implementation LPBusinessReviewWageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.title = @"晒工资";
    self.userUrl = @"";
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:currentDate].integerValue;
    
//    self.tableview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);

    }];
    
    
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 256, SCREEN_WIDTH - kPhotoViewMargin * 2, 100)];
    headImgView.backgroundColor = [UIColor clearColor];
    headImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    headImgView.layer.borderWidth = 0.5;
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    headImgView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 130)/2+30,256+ 35, 100, 30)];
    label.text = @"工资单上传";
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 130)/2,256+ 35, 30, 30)];
    imageview.image = [UIImage imageNamed:@"NoImage"];
    [self.view addSubview:label];
    [self.view addSubview:imageview];
    [self.view addSubview:headImgView];

    headImgView.layer.masksToBounds = YES;
    headImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuchHeadImgView)];
    [headImgView addGestureRecognizer:tap];
    self.headImgView = headImgView;
    
    [self setLogoutButton];
    
    
    
    _photoView = [HXPhotoView photoManager:self.manager];
    _photoView.lineCount = 3;
    _photoView.delegate = self;
    //    photoView.showAddCell = NO;
    _photoView.backgroundColor = [UIColor whiteColor];

    
    
    
}

-(void)setLogoutButton{
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(-60);
    }];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor baseColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(touchLogoutButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchLogoutButton
{
    if (self.yinfaTF.text.length == 0)
    {
        [self.view showLoadingMeg:@"请输入应发工资" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.shifaTF.text.length == 0)
    {
        [self.view showLoadingMeg:@"请输入实发工资" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    NSString *str =[self.xinziLabel.text stringByReplacingOccurrencesOfString:@"月份" withString:@""];
    
    NSDictionary *dic = @{
                          @"idealMoney":[LPTools isNullToString:self.yinfaTF.text],
                          @"payrollUrl":[LPTools isNullToString:self.userUrl],
                          @"post":[LPTools isNullToString:self.cengzaizhiLabel.text],
                          @"realMoney":[LPTools isNullToString:self.shifaTF.text],
                          @"salaryMonth":[LPTools isNullToString:str],
                          @"mechanismId":self.mechanismlistDataModel.id
                          };
    
    
    [NetApiManager requestQueryBusinessWageParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue]== 1)
            {
                [self.view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
//        _tableview.tableFooterView = [[UIView alloc]init];
//        _tableview.rowHeight = UITableViewAutomaticDimension;
//        _tableview.estimatedRowHeight = 0.0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellEditingStyleNone;
        _tableview.estimatedSectionHeaderHeight = 0;
        
    }
    return _tableview;
}

-(UIView *)tableHeaderView{
    if (!_tableHeaderView){
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        
    }
    return _tableHeaderView;
}


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
    }
    return _manager;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0;
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
        cell.textLabel.text = @"企业名称：";
        UITextField *textField = [[UITextField alloc]init];
        textField.frame = CGRectMake(120, 5, SCREEN_WIDTH-130, 34);
        textField.text = self.mechanismlistDataModel.mechanismName;
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [UIColor colorWithHexString:@"#434343"];
        textField.enabled = NO;
//        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//        self.userName = self.userMaterialModel.data.user_name;
        [cell.contentView addSubview:textField];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"您的岗位：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(110, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
//        label.text = self.userMaterialModel.data.work_type;
        self.cengzaizhiLabel = label;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"薪资月份：";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(100, 5, SCREEN_WIDTH-140, 34);
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:16];
//        label.text = self.userMaterialModel.data.ideal_money;
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        self.xinziLabel = label;
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"应发工资：";
        UITextField *textField = [[UITextField alloc]init];
        textField.frame = CGRectMake(120, 5, SCREEN_WIDTH-140, 34);
        textField.textAlignment = NSTextAlignmentRight;
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.textColor = [UIColor colorWithHexString:@"#434343"];
        //        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        //        self.userName = self.userMaterialModel.data.user_name;
        self.yinfaTF = textField;
        [cell.contentView addSubview:textField];
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"实发工资：";
        UITextField *textField = [[UITextField alloc]init];
        textField.frame = CGRectMake(120, 5, SCREEN_WIDTH-140, 34);
        textField.textAlignment = NSTextAlignmentRight;
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.textColor = [UIColor colorWithHexString:@"#434343"];
        //        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        //        self.userName = self.userMaterialModel.data.user_name;
        self.shifaTF = textField;
        [cell.contentView addSubview:textField];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor colorWithHexString:@"#FFC1C1C1"];
    [cell.contentView addSubview:view];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1 ) {
        self.selectIndex = indexPath.row;
        [self alertView:indexPath.row];
    }
    else if (indexPath.row == 2)
    {
        [self chooseMonth];
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
    
    if (index == 1 ){
        
        label.text = @"您的岗位";
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
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
        self.cengzaizhi = [NSString stringWithFormat:@"%@-%@",[(NSDictionary *)self.p1Array[0] allKeys][0],[(NSDictionary *)self.p1Array[0] allValues][0][0]];
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
        return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
        if (component == 0) {
            return self.p1Array.count;
        }else{
            return ((NSArray *)((NSDictionary *)self.p1Array[self.select1]).allValues[0]).count;
        }
 
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    
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
        if (component == 0) {
            self.select1 = [pickerView selectedRowInComponent:0];
            [pickerView reloadComponent:1];
        }
    
        NSString *s = [self.p1Array[self.select1] allKeys][0];
    
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
        NSString *cityName = [self.p1Array[self.select1] allValues][0][cityIndex];
        self.cengzaizhi = [NSString stringWithFormat:@"%@-%@",s,cityName];
    
}

-(void)confirmBirthday{
   
    if(self.selectIndex == 1){
        self.cengzaizhiLabel.text = self.cengzaizhi;
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

-(UIView *)monthView{
    if (!_monthView) {
        _monthView = [[UIView alloc]init];
        [self.view addSubview:_monthView];
        [_monthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(200);
        }];
        _monthView.backgroundColor = [UIColor blackColor];
        _monthView.alpha = 0.5;
        _monthView.userInteractionEnabled = YES;
        _monthView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(monthViewHidden)];
        [_monthView addGestureRecognizer:tap];
        
        
        self.monthBackView = [[UIView alloc]init];
        [self.view addSubview:self.monthBackView];
        [self.monthBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(48);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
        self.monthBackView.hidden = YES;
        self.monthBackView.backgroundColor = [UIColor whiteColor];
        
        self.monthButtonArray = [NSMutableArray array];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请选择月份";
        [self.monthBackView addSubview:label];
        
        for (int i = 0; i < 12; i++) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, floor(i/4)*51+30, SCREEN_WIDTH/4, 51);
            view.backgroundColor = [UIColor whiteColor];
            [self.monthBackView addSubview:view];
            
            UIButton *button = [[UIButton alloc]init];
            [view addSubview:button];
            button.frame = CGRectMake((SCREEN_WIDTH/4-41)/2, 5, 41, 41);
            button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20.5;
            button.tag = i;
            [self.monthButtonArray addObject:button];
            [button addTarget:self action:@selector(touchMonthButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.monthButtonArray[self.month-1].selected = YES;
        self.monthButtonArray[self.month-1].backgroundColor = [UIColor baseColor];
        
    }
    return _monthView;
    
}

-(void)chooseMonth{
    self.monthView.hidden = !self.monthView.isHidden;
    self.monthBackView.hidden = !self.monthBackView.isHidden;
}
-(void)monthViewHidden{
    self.monthView.hidden = YES;
    self.monthBackView.hidden = YES;
}
-(void)touchMonthButton:(UIButton *)button{

    _xinziLabel.text = [NSString stringWithFormat:@"%@月份",button.currentTitle];

    for (UIButton *button in self.monthButtonArray) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    button.selected = YES;
    button.backgroundColor = [UIColor baseColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self monthViewHidden];
    });
//    [self requestGetOnWork];
    
}


-(void)tuchHeadImgView{
    
    
    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
    nav.supportRotation = self.manager.configuration.supportRotation;
    [self  presentViewController:nav animated:YES completion:nil];
//    [_photoView directGoPhotoViewController];
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
//                                                                             message:nil
//                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction * _Nonnull action) {
//
//#if (TARGET_IPHONE_SIMULATOR)
//
//#else
//                                                          [self takePhoto];
//#endif
//
//                                                      }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选择"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction * _Nonnull action) {
//                                                          [self choosePhoto];
//                                                      }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
//                                                        style:UIAlertActionStyleCancel
//                                                      handler:^(UIAlertAction * _Nonnull action) {
//
//                                                      }]];
//    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - < HXAlbumListViewControllerDelegate >
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllImage:(NSArray<UIImage *> *)imageList {
//    self.imageList = [NSMutableArray arrayWithArray:imageList];
//    if ([self.delegate respondsToSelector:@selector(photoView:imageChangeComplete:)]) {
//        [self.delegate photoView:self imageChangeComplete:imageList];
//    }
//    if (self.imageChangeCompleteBlock) {
//        self.imageChangeCompleteBlock(imageList);
//    }
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    [self.toolManager getSelectedImageList:allList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
        if (imageList.count > 0) {
            [self performSelector:@selector(saveImage:)  withObject:imageList[0] afterDelay:0.5];
        }
    } failed:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)takePhoto{
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

- (void)saveImage:(UIImage *)image {

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
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
