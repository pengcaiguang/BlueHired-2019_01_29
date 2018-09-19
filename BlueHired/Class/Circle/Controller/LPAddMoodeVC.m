//
//  LPAddMoodeVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/19.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPAddMoodeVC.h"
#import "HXPhotoPicker.h"
#import "LPMoodTypeModel.h"

static NSString *placeholder = @"请输入帖子内容";
static const CGFloat kPhotoViewMargin = 13.0;

@interface LPAddMoodeVC ()<UIScrollViewDelegate,HXPhotoViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;

@property(nonatomic,strong) UIButton *sendButton;
@property(nonatomic,strong) UIButton *selectButton;
@property(nonatomic,strong) UIView *selectView;
@property(nonatomic,strong) UITableView *selectTableView;

@property(nonatomic,strong) LPMoodTypeModel *moodTypeModel;


@property(nonatomic,strong) NSString *moodDetails;

@end

@implementation LPAddMoodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的圈子";
    [self setupUI];
    [self requestMoodType];
}
-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UITextView *textView = [[UITextView alloc]init];
    [self.scrollView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(160);
    }];
    textView.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.textColor = [UIColor lightGrayColor];
    textView.text = placeholder;
    textView.font = [UIFont systemFontOfSize:14];
    textView.delegate = self;
    
    
    UIView *v1 = [[UIView alloc]init];
    [self.scrollView addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(textView.mas_bottom).offset(30);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(18);
    }];
    v1.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    
    UILabel *label1 = [[UILabel alloc]init];
    [self.scrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_right).offset(7);
        make.centerY.equalTo(v1);
    }];
    label1.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"板块选择";
    
    UIButton *selectButton = [[UIButton alloc]init];
    [self.scrollView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(9);
        make.right.mas_equalTo(-13);
        make.centerY.equalTo(label1);
        make.height.mas_equalTo(35);
    }];
    [selectButton setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
    selectButton.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    selectButton.layer.borderWidth = 0.5;
    [selectButton addTarget:self action:@selector(touchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [label1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.selectButton = selectButton;
    
    UIImageView *img = [[UIImageView alloc]init];
    [selectButton addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(selectButton);
        make.size.mas_equalTo(CGSizeMake(18, 10));
    }];
    img.image = [UIImage imageNamed:@"select_moodtype"];
    
    UIView *v2 = [[UIView alloc]init];
    [self.scrollView addSubview:v2];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(v1.mas_bottom).offset(40);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(18);
    }];
    v2.backgroundColor = [UIColor colorWithHexString:@"#FFDD3C"];
    
    UILabel *label2 = [[UILabel alloc]init];
    [self.scrollView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v2.mas_right).offset(7);
        make.centerY.equalTo(v2);
    }];
    label2.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    label2.font = [UIFont systemFontOfSize:16];
    label2.text = @"添加图片";
    
    
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.lineCount = 3;
    photoView.delegate = self;
    //    photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.width.mas_equalTo(width - kPhotoViewMargin * 2);
    }];
    [self.photoView refreshView];
    
    UIButton *sendButton = [[UIButton alloc]init];
    [self.scrollView addSubview:sendButton];
    
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 24;
    sendButton.backgroundColor = [UIColor baseColor];
    self.sendButton = sendButton;
}
#pragma mark - setter
-(void)setMoodTypeModel:(LPMoodTypeModel *)moodTypeModel{
    _moodTypeModel = moodTypeModel;
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame{
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin + 92);
    [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(CGRectGetMaxY(photoView.frame)+44);
        make.height.mas_equalTo(48);
    }];
}
-(void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    [self.toolManager getSelectedImageList:allList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
        if (imageList.count > 0) {
            [self requestUploadImages:imageList];
        }
    } failed:^{

    }];
}

#pragma mark - target
-(void)touchSelectButton:(UIButton *)button{
    if (button.isSelected) {
        [self hiddenSelect];
        return;
    }
    
    [self.view endEditing:YES];
    self.selectView.hidden = NO;
    self.selectTableView.hidden = NO;
    button.selected = YES;
    
    CGRect rect = [self.view convertRect:self.selectButton.frame fromView:self.scrollView];
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(rect.origin.y+35);
//        make.bottom.mas_equalTo(0);
    }];
    
    CGFloat h = 0;
    if ((self.moodTypeModel.data.count-1) * 44 > self.view.frame.size.height - rect.origin.y-35) {
        h = self.view.frame.size.height - rect.origin.y-35;
    }else{
        h = (self.moodTypeModel.data.count-1) * 44;
    }
    [self.view addSubview:self.selectTableView];
    [self.selectTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(rect.origin.y+35);
        make.height.mas_equalTo(h);
    }];
}
-(void)hiddenSelect{
    self.selectView.hidden = YES;
    self.selectTableView.hidden = YES;
    self.selectButton.selected = NO;
}
#pragma mark - textView
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.textColor isEqual:[UIColor lightGrayColor]] && [textView.text isEqualToString:placeholder]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    [self hiddenSelect];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length ==0) {
        textView.text = placeholder;
        textView.textColor = [UIColor lightGrayColor];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    self.moodDetails = textView.text;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moodTypeModel.data.count-1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"%@",self.moodTypeModel.data[indexPath.row+1].labelName];
    [cell.contentView addSubview:label];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenSelect];
    [self.selectButton setTitle:self.moodTypeModel.data[indexPath.row+1].labelName forState:UIControlStateNormal];
}

#pragma mark - request
-(void)requestAddMood{
    [NetApiManager requestAddMoodWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestMoodType{
    [NetApiManager requestMoodTypeWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.moodTypeModel = [LPMoodTypeModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestUploadImages:(NSArray <UIImage *>*)imageArray{
    for (UIImage *image in imageArray) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"--%ld",data.length);
    }
    
    NSMutableArray *mu = [NSMutableArray array];
    for (int i = 0; i< imageArray.count; i++) {
        [mu addObject:[self getNowTimeTimestamp3]];
    }
//    [NetApiManager avartarChangeWithParamDict:nil singleImage:imageArray[0] singleImageName:@"file" withHandle:^(BOOL isSuccess, id responseObject) {
//        NSLog(@"%@",responseObject);
//        if (isSuccess) {
//
//        }else{
//            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
//        }
//    }];
    
    [NetApiManager requestPublishArticle:nil imageArray:imageArray imageNameArray:[mu copy] response:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

 - (NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}
#pragma mark - lazy
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 6; //
//        _manager.configuration.videoMaxNum = 1;  //
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
-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        _selectView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSelect)];
        _selectView.userInteractionEnabled = YES;
        [_selectView addGestureRecognizer:tap];
    }
    return _selectView;
}
-(UITableView *)selectTableView{
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc]init];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.tableFooterView = [[UIView alloc]init];
        _selectTableView.rowHeight = UITableViewAutomaticDimension;
        _selectTableView.estimatedRowHeight = 100;
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _selectTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _selectTableView;
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
