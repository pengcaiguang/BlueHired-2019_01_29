//
//  LPAddMoodeVC.m
//  BlueHired
//
//  Created by peng on 2018/9/19.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPAddMoodeVC.h"
#import "HXPhotoPicker.h"
#import "LPMoodTypeModel.h"
#import "LPCircleVC.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import "LPMapLocCell.h"
#import "LPMapLoctionModel.h"
#import "LPCircleSearchVC.h"
#import <AVFoundation/AVFoundation.h>

static NSString *LPMapLocCellID = @"LPMapLocCell";

static NSString *placeholder = @"请输入内容\n      温馨提示:禁止发送“色情低俗”、“政治敏感”、“违法暴力”、“虚假广告”等相关内容.一经发现,我们将严肃处理.";
static const CGFloat kPhotoViewMargin = 13.0;

@interface LPAddMoodeVC ()<UIScrollViewDelegate,HXPhotoViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,LPCircleSearchDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;

@property(nonatomic,strong) UIButton *sendButton;
@property(nonatomic,strong) UIButton *selectButton;
@property(nonatomic,strong) UIButton *selectButton2;
@property(nonatomic,strong) UIView *selectView;
@property(nonatomic,strong) UITableView *selectTableView;
@property(nonatomic,strong) UITableView *LocationTableView;
@property(nonatomic,strong) NSMutableArray <LPMapLoctionModel *>*MapArray;

@property(nonatomic,strong) LPMoodTypeModel *moodTypeModel;

@property(nonatomic,strong) NSArray <UIImage *>*imageArray;
@property(nonatomic,strong) NSString *VideoURL;

@property(nonatomic, strong) BMKLocationManager *locationManager;
@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;

@property(nonatomic,strong) NSString *moodDetails;
@property(nonatomic,strong) NSString *moodTypeId;
@property(nonatomic,strong) NSString *moodMap;
@property(nonatomic,strong) NSArray *imageUrlArray;
@property(nonatomic,strong) UIView *bgView;



@end

@implementation LPAddMoodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _MapArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"我的圈子";
    [self setupUI];
//    [self requestMoodType];

    [self initBlock];
//    [self initLocation];
    self.moodMap = @"保密";
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.LocationTableView];
    [self.LocationTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(335);
    }];
    self.LocationTableView.hidden = YES;
    self.bgView.hidden = YES;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:self.completionBlock];

    });
}


-(void)initLocation
{
    _locationManager = [[BMKLocationManager alloc] init];
     _locationManager.delegate = self;
     _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = NO;// YES的话是可以进行后台定位的，但需要项目配置，否则会报错，具体参考开发文档
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
  
}


-(void)initBlock
{
    WEAK_SELF()
     self.completionBlock = ^(BMKLocation *location, BMKLocationNetworkState state, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        
        if (location.location) {//得到定位信息，添加annotation
 
             NSArray *array = [location.rgcData poiList];
            
            [weakSelf.MapArray removeAllObjects];
             LPMapLoctionModel *m1 = [[LPMapLoctionModel alloc] init];
            m1.AddName = @"保密";
            m1.IsSelect = YES;
             LPMapLoctionModel *m2 = [[LPMapLoctionModel alloc] init];
            m2.AddName = location.rgcData.city;
            m2.IsSelect = NO;

            [weakSelf.MapArray addObject:m1];
            [weakSelf.MapArray addObject:m2];
            for (int i = 0; i < array.count; i++) {
                BMKLocationPoi * poi = array[i];
                LPMapLoctionModel *m = [[LPMapLoctionModel alloc] init];
                m.AddName = poi.name;
                m.AddDetail = [NSString stringWithFormat:@"%@%@%@%@%@",location.rgcData.country,location.rgcData.province,location.rgcData.city,location.rgcData.district,location.rgcData.street];
                m.rgcData = location.rgcData;
                m.IsSelect = NO;
                  [weakSelf.MapArray addObject:m];
            }
            
            [weakSelf.LocationTableView reloadData];
 
        }
        
        if (location.rgcData) {
            NSLog(@"rgc = %@",[location.rgcData description]);
        }
        
        NSLog(@"netstate = %d",state);
    };
    
    
}

-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
//    UIView *view2 = [[UIView alloc] init];
//    [scrollView addSubview:view2];
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(113);
//        make.right.mas_equalTo(-50);
//        make.width.mas_equalTo(160);
//        make.height.mas_equalTo(160);
//    }];
//    view2.backgroundColor = [UIColor redColor];
    
    NSLog(@"%f",scrollView.frame.size.width);
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
    
//    //v1
//    UIImageView *v1 = [[UIImageView alloc]init];
//    [self.scrollView addSubview:v1];
//    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(13);
//        make.top.equalTo(textView.mas_bottom).offset(30);
//        make.width.mas_equalTo(21);
//        make.height.mas_equalTo(21);
//    }];
//    v1.image = [UIImage imageNamed:@"板块标签"];
//
//
//    UIView *L1 = [[UIView alloc]init];
//    [self.scrollView addSubview:L1];
//    [L1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.equalTo(v1.mas_bottom).offset(10);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(0.5);
//    }];
//
//    UILabel *label1 = [[UILabel alloc]init];
//    [self.scrollView addSubview:label1];
//    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(v1.mas_right).offset(7);
//        make.centerY.equalTo(v1);
//    }];
//    label1.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
//    label1.font = [UIFont systemFontOfSize:16];
//    label1.text = @"板块选择";
//
//    UIButton *selectButton = [[UIButton alloc]init];
//    [self.scrollView addSubview:selectButton];
//    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(label1.mas_right).offset(9);
//        make.right.mas_equalTo(-35);
//        make.centerY.equalTo(label1);
//        make.height.mas_equalTo(35);
//    }];
//    [selectButton setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
//    selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
////    selectButton.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
////    selectButton.layer.borderWidth = 0.5;
//    [selectButton addTarget:self action:@selector(touchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
//    [label1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//
//    self.selectButton = selectButton;
//
//    UIImageView *img = [[UIImageView alloc]init];
//    [self.scrollView addSubview:img];
//    [img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-8);
//        make.centerY.equalTo(selectButton);
//        make.size.mas_equalTo(CGSizeMake(18, 10));
//    }];
//    img.image = [UIImage imageNamed:@"select_moodtype"];
//
    //v3
    UIImageView *v3 = [[UIImageView alloc]init];
    [self.scrollView addSubview:v3];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
//        make.top.equalTo(v1.mas_bottom).offset(20);
        make.top.equalTo(textView.mas_bottom).offset(30);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(21);
    }];
    v3.image = [UIImage imageNamed:@"区域与板块-1"];
    
    UIView *L3 = [[UIView alloc]init];
    [self.scrollView addSubview:L3];
    [L3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(v3.mas_bottom).offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    [self.scrollView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v3.mas_right).offset(7);
        make.centerY.equalTo(v3);
    }];
    label3.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    label3.font = [UIFont systemFontOfSize:16];
    label3.text = @"所在位置";
    
    UIButton *selectButton2 = [[UIButton alloc]init];
    [self.scrollView addSubview:selectButton2];
    [selectButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right).offset(9);
        make.right.mas_equalTo(-35);
        make.centerY.equalTo(label3);
        make.height.mas_equalTo(40);
    }];
    [selectButton2 setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
    selectButton2.titleLabel.font = [UIFont systemFontOfSize:13];
//    selectButton2.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
//    selectButton2.layer.borderWidth = 0.5;
    [selectButton2 addTarget:self action:@selector(touchSelectButton2:) forControlEvents:UIControlEventTouchUpInside];
    [label3 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [selectButton2 setTitle:@"保密" forState:UIControlStateNormal];
    selectButton2.titleLabel.lineBreakMode = 0;
    selectButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.selectButton2 = selectButton2;
    
    UIImageView *img2 = [[UIImageView alloc]init];
    [self.scrollView addSubview:img2];
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(selectButton2);
        make.size.mas_equalTo(CGSizeMake(18, 10));
    }];
    img2.image = [UIImage imageNamed:@"select_moodtype"];
    
    
    //v
    UIImageView *v2 = [[UIImageView alloc]init];
    [self.scrollView addSubview:v2];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(v3.mas_bottom).offset(20);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(21);
    }];
    v2.image = [UIImage imageNamed:@"添加图片(2)"];
    
    UIView *L2 = [[UIView alloc]init];
    [self.scrollView addSubview:L2];
    [L2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(v2.mas_bottom).offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    L2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
//    L1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    L3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];

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
    [photoView.collectionView reloadData];
    [self.photoView refreshView];
    
    UIButton *sendButton = [[UIButton alloc]init];
    [self.scrollView addSubview:sendButton];
    
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 24;
    sendButton.backgroundColor = [UIColor baseColor];
    [sendButton addTarget:self action:@selector(touchSendButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton = sendButton;
}
#pragma mark - setter
-(void)setMoodTypeModel:(LPMoodTypeModel *)moodTypeModel{
    _moodTypeModel = moodTypeModel;
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame{
    NSSLog(@"%f",CGRectGetMaxY(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin + 192);
    [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(CGRectGetMaxY(photoView.frame)+44);
        make.height.mas_equalTo(48);
    }];
}
-(void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
//    [self.toolManager writeSelectModelListToTempPathWithList:allList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL)  {
//        if (photoURL.count > 0) {
//            NSMutableArray *Image = [[NSMutableArray alloc] init];
//
//            self.imageArray = imageList;
//        }
//    } failed:^{
//
//    }];
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld       ",allList.count,photos.count,videos.count);
    if (photos.count) {
        self.sendButton.enabled = NO;
        [self.toolManager getSelectedImageList:photos requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
            self.sendButton.enabled = YES;
            if (imageList.count > 0) {
                self.imageArray = imageList;
            }
        } failed:^{
            
        }];
    }else{
        self.sendButton.enabled = NO;
        [self.toolManager writeSelectModelListToTempPathWithList:videos requestType:0 success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            self.VideoURL = @"";
            self.sendButton.enabled = YES;
            if (videoURL.count) {
                self.VideoURL = [videoURL[0] absoluteString];
                NSSLog(@"视频地址:%@       ",self.VideoURL);
            }
            
        } failed:^{
            
        }];
    }

    
    
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
    self.LocationTableView.hidden = YES;
    self.selectButton2.selected = NO;
    self.bgView.hidden = YES;
    
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


-(void)touchSelectButton2:(UIButton *)button{
    
    
//    if ([CLLocationManager locationServicesEnabled] &&
//        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse   ||
//         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
//            //定位功能可用
//            [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:self.completionBlock];
//        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
//            //定位不能用
//            [LPTools AlertMessageView:@"请打开定位功能"];
//            return;
//        }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
//            [LPTools AlertMessageView:@"请打开定位功能"];
//            return;
//        }
    
    
    LPCircleSearchVC *vc = [[LPCircleSearchVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    return;
//
//    if (button.isSelected) {
//        [self hiddenSelect];
//        return;
//    }
//
//     if (self.MapArray.count == 0) {
//        [self.view showLoadingMeg:@"无法获取您当前的位置信息,请换个地方试试" time:MESSAGE_SHOW_TIME];
//        return;
//    }
//
//    self.bgView.hidden = NO;
//    self.selectButton2.selected = YES;
//    self.LocationTableView.hidden = NO;
//    [self.LocationTableView reloadData];
}

#pragma mark - setter
-(void)LPCircleSearchBack:(AMapPOI *)poi{
    NSString *str =@"";
    if (![[LPTools isNullToString:poi.city] isEqualToString:@""]) {
        NSString *citystr = [poi.city substringFromIndex:poi.city.length-1];
        if ([citystr isEqualToString:@"市"]) {
            str= [NSString stringWithFormat:@"%@·%@",[LPTools isNullToString:[poi.city substringToIndex:poi.city.length-1]],poi.name];
        }else{
            str= [NSString stringWithFormat:@"%@·%@",[LPTools isNullToString:poi.city],poi.name];
        }
    }else{
        str = poi.name;
    }
    
    
    
     self.moodMap = str;
     [self.selectButton2 setTitle:str forState:UIControlStateNormal];
 }

-(void)hiddenSelect{
    self.selectView.hidden = YES;
    self.selectTableView.hidden = YES;
    self.selectButton.selected = NO;
    self.LocationTableView.hidden = YES;
    self.selectButton2.selected = NO;
    self.bgView.hidden = YES;
}
-(void)touchSendButton:(UIButton *)button{
  
    if (self.moodDetails.length == 0) {
        [self.view showLoadingMeg:@"请输入内容" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.moodDetails.length >= 600) {
        [self.view showLoadingMeg:@"字数过长,请限定在600字以内" time:MESSAGE_SHOW_TIME];
        return;
    }
    
//    if (!self.moodTypeId) {
//        [self.view showLoadingMeg:@"请选择板块" time:MESSAGE_SHOW_TIME];
//        return;
//    }
    [DSBaActivityView showActiviTy];
    NSSLog(@"发送圈子:%@       ",self.VideoURL);

    if (kArrayIsEmpty(self.imageArray) && self.VideoURL.length == 0) {
        [self requestAddMood];
    }else{
        if (self.VideoURL.length) {
            [self requestUploadVideo];
        }else{
            [self requestUploadImages];
        }
    }
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
    if (tableView == self.LocationTableView) {
        return self.MapArray.count;
    }
    return self.moodTypeModel.data.count-1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    if (tableView == self.LocationTableView) {
        LPMapLocCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMapLocCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(cell == nil){
            cell = [[LPMapLocCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMapLocCellID];
        }
        LPMapLoctionModel *model = self.MapArray[indexPath.row];
        cell.AddName.text = model.AddName;
        cell.AddDetail.text = model.AddDetail;
        cell.SelectBt.hidden = !model.IsSelect;
        
        return cell;
    }
    
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
    
    if (tableView == self.LocationTableView) {
        [self hiddenSelect];
        LPMapLoctionModel *model = self.MapArray[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",[LPTools isNullToString:model.rgcData.city],[LPTools isNullToString:model.rgcData.district],model.AddName];
         self.moodMap = str;
        
        [self.selectButton2 setTitle:str forState:UIControlStateNormal];
        return;
    }
    
    [self hiddenSelect];
    self.moodTypeId = self.moodTypeModel.data[indexPath.row+1].id.stringValue;
    [self.selectButton setTitle:self.moodTypeModel.data[indexPath.row+1].labelName forState:UIControlStateNormal];
}

#pragma mark - request
-(void)requestAddMood{
    NSString *string = @"";
    if (self.imageUrlArray) {
        string = [self.imageUrlArray componentsJoinedByString:@";"];
    }
    NSDictionary *dic = @{
                          @"moodDetails":self.moodDetails,
                          @"moodTypeId":self.moodTypeId ? self.moodTypeId : @"",
                          @"moodUrl":string,
                          @"address":self.moodMap,
                          @"versionType":@"2.1"
                          };
    [NetApiManager requestAddMoodWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [DSBaActivityView hideActiviTy];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1 ||[responseObject[@"data"] integerValue] == 2) {
                    if ([responseObject[@"data"] integerValue] == 2) {
                        [LPTools AlertCircleView:@""];
                    }
                    [self.view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LPCircleVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                        vc.isSenderBack = 4;
                        [self.navigationController popToViewController:vc animated:YES];
                        
                    });
                }else{
                    [self.view showLoadingMeg:@"发送失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                if ([responseObject[@"code"] integerValue] == 10045) {
                    [LPTools AlertMessageView:responseObject[@"msg"]];
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestMoodType{
    [NetApiManager requestMoodTypeWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.moodTypeModel = [LPMoodTypeModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestUploadVideo{
    [NetApiManager requestPublishVideo:nil VideoUrl:self.VideoURL response:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                self.imageUrlArray = responseObject[@"data"];
                [self requestAddMood];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestUploadImages{
    [NetApiManager requestPublishArticle:nil imageArray:self.imageArray imageNameArray:nil response:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                self.imageUrlArray = responseObject[@"data"];
                [self requestAddMood];
            }
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
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        //        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 9; //
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.videoMaximumDuration = 10;
        _manager.configuration.videoMinimumSelectDuration = 0;
        _manager.configuration.videoMaximumSelectDuration = 10;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.videoCanEdit = YES;
        _manager.configuration.changeAlbumListContentView = NO;
 
//        _manager.configuration.replaceVideoEditViewController = YES;
        
         //        _manager.configuration.selectTogether = NO;
        [_manager preloadData];
        HXWeakSelf
        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
            
            // 这里拿使用系统相机做例子
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = (id)weakSelf;
            imagePickerController.allowsEditing = NO;
            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
            NSArray *arrMediaTypes;
            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
            }else {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
            }
            [imagePickerController setMediaTypes:arrMediaTypes];
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            //设置最长摄像时间
            [imagePickerController setVideoMaximumDuration:60.f];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        };

        
        
        
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
-(UITableView *)LocationTableView{
    if (!_LocationTableView) {
        _LocationTableView = [[UITableView alloc]init];
        _LocationTableView.delegate = self;
        _LocationTableView.dataSource = self;
        _LocationTableView.tableFooterView = [[UIView alloc]init];
        _LocationTableView.rowHeight = UITableViewAutomaticDimension;
        _LocationTableView.estimatedRowHeight = 100;
        _LocationTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _LocationTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_LocationTableView registerNib:[UINib nibWithNibName:LPMapLocCellID bundle:nil] forCellReuseIdentifier:LPMapLocCellID];

    }
    return _LocationTableView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        _bgView.alpha = 0.5;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSelect)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
//yasuo
- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}


@end
