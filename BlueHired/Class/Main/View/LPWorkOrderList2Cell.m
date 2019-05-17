//
//  LPWorkOrderList2Cell.m
//  BlueHired
//
//  Created by iMac on 2019/5/9.
//  Copyright © 2019 lanpin. All rights reserved.
//
#import "LPWorkorderListModel.h"

#import "LPWorkOrderList2Cell.h"

@implementation LPWorkOrderList2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectButton.layer.cornerRadius = 12.0;
    self.selectButton.layer.borderWidth = 1;
    self.selectButton.layer.borderColor = [UIColor baseColor].CGColor;
    
    self.ShareButton.layer.cornerRadius = 12.0;
    self.ShareButton.layer.borderWidth = 1;
    self.ShareButton.layer.borderColor = [UIColor baseColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPWorkorderListDataModel *)model{
    _model = model;
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.mechanismNameLabel.text = model.mechanismName;
    if ([model.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",model.workMoney];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    }
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@",model.workTypeName];
    self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人 / 已报名:%@人",model.maxNumber,model.applyNumber ? model.applyNumber : @"0"];

    if (model.status.integerValue == 1) {
        self.isWorkers.hidden = NO;
    }else{
        self.isWorkers.hidden = YES;
    }
    
    self.isApplyLabel.hidden = YES;
 
    
    if ([model.status integerValue] == 1 ) {//1 通过
        self.statusLabel.text = @"入职状态：面试通过";
        [self.selectButton setTitle:@"放弃入职" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor baseColor].CGColor;
        
    }else if ([model.status integerValue] == 2){//2。失败
        self.statusLabel.text = @"面试状态：面试失败";
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;

    }else if ([model.status integerValue] == 3){//3。招满
        self.statusLabel.text = @"面试状态：已招满";
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
        
    }else if ([model.status integerValue] == 4){//3。招满
        self.statusLabel.text = @"面试状态：放弃入职";
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
        
    }else if ([model.status integerValue] == 5){//3。招满
        self.statusLabel.text = @"面试状态：入职成功";
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
        
    }else{
        self.statusLabel.text = @"面试状态：面试预约中";
        [self.selectButton setTitle:@"取消报名" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor baseColor].CGColor;
    }
  
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.statusLabel.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fabf48"] range:[self.statusLabel.text rangeOfString:@"面试预约中"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5353"] range:[self.statusLabel.text rangeOfString:@"面试失败"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5353"] range:[self.statusLabel.text rangeOfString:@"放弃入职"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5353"] range:[self.statusLabel.text rangeOfString:@"已招满"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#3cafff"] range:[self.statusLabel.text rangeOfString:@"面试通过"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#3cafff"] range:[self.statusLabel.text rangeOfString:@"入职成功"]];

    
    self.statusLabel.attributedText = string;
    
    self.interviewTimeLabel.text = [NSString stringWithFormat:@"面试时间：%@",model.interviewTime];
    self.recruitAddressLabel.text = [NSString stringWithFormat:@"面试地点：%@",model.recruitAddress];

    if (model.teacherList.count == 0) {
        self.teacherNameLabel.text = [NSString stringWithFormat:@"驻场老师：-"];
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻场老师：-"];
    }else if (model.teacherList.count == 1){
        self.teacherNameLabel.text = [NSString stringWithFormat:@"驻厂老师：%@  %@",model.teacherList[0].teacherName,model.teacherList[0].teacherTel];
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻场老师：-"];
    }else if (model.teacherList.count >1){
        self.teacherNameLabel.text = [NSString stringWithFormat:@"驻厂老师：%@  %@",model.teacherList[0].teacherName,model.teacherList[0].teacherTel];
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻厂老师：%@  %@",model.teacherList[1].teacherName,model.teacherList[1].teacherTel];
    }
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"报名时间: %@",[NSString convertStringToTime:model.time]];
}


- (IBAction)ToMap:(id)sender {
    //    CLLocationCoordinate2D pt2 = {23.122012,113.26753};
    
    NSDecimalNumber *XNumber = [NSDecimalNumber decimalNumberWithString:_model.x];
    NSDecimalNumber *YNumber = [NSDecimalNumber decimalNumberWithString:_model.y];
    
    
    CLLocationCoordinate2D pt2 = {[XNumber doubleValue],[YNumber doubleValue]};
    
    BMKLocationCoordinateType srctype = BMKLocationCoordinateTypeWGS84;
    BMKLocationCoordinateType destype = BMKLocationCoordinateTypeBMK09MC;
    CLLocationCoordinate2D cood=[BMKLocationManager BMKLocationCoordinateConvert:pt2 SrcType:destype DesType:srctype];
    
    self.coordinate = [self GCJ02FromBD09:pt2];
    
    [self ToNavMap];
}

- (IBAction)touchSelectButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(buttonClick:workId:)]) {
        NSInteger index;
        if ([self.model.status integerValue] == 1 ||
            [self.model.status integerValue] == 2 ||
            [self.model.status integerValue] == 3 ||
            [self.model.status integerValue] == 4 ||
            [self.model.status integerValue] == 5){
            index = 0;//删除
            [self.delegate buttonClick:index workId:self.model.id.integerValue];
        }else{
            index = 1;//取消
            [self.delegate buttonClick:index workId:self.model.workId.integerValue];
        }
    }
}

- (IBAction)Touchshare:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@bluehired/recruitmentlist_detail.html?id=%@",BaseRequestWeiXiURL,self.model.mechanismId];
    
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [LPTools ClickShare:encodedUrl Title:_model.mechanismName];
}



-(void)ToNavMap
{
    
    
    //系统版本高于8.0，使用UIAlertController
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2&dname=%@",self.coordinate.latitude,self.coordinate.longitude,self.model.recruitAddress]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02&title=%@",self.coordinate.latitude,self.coordinate.longitude,self.model.recruitAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 腾讯地图");
            
            NSString *urlsting =[[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&to=%@&type=drive&tocoord=%f,%f&coord_type=1&referer={ios.blackfish.XHY}",self.model.recruitAddress,self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [[UIWindow visibleViewController] presentViewController:alertController animated:YES completion:nil];
    
}


-(CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}


@end
