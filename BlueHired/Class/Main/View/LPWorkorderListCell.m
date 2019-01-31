//
//  LPWorkorderListCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkorderListCell.h"
 
@implementation LPWorkorderListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LPWorkorderListDataModel *)model{
    _model = model;

    self.mechanismNameLabel.text = model.mechanismName;
    self.timeLabel.text = [NSString convertStringToTime:model.time];
    
    if ([model.status integerValue] == 1 ) {//1 通过
        self.statusLabel.text = @"入职状态：面试通过";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }else if ([model.status integerValue] == 2){//2。失败
        self.statusLabel.text = @"入职状态：面试失败";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }else if ([model.status integerValue] == 3){//3。招满
        self.statusLabel.text = @"入职状态：已经招满";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }
    else if ([model.status integerValue] == 4){//3。招满
        self.statusLabel.text = @"入职状态：放弃入职";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }
    else if ([model.status integerValue] == 5){//3。招满
        self.statusLabel.text = @"入职状态：入职成功";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }else{
        self.statusLabel.text = @"入职状态：预约中";
        self.titleBgView.backgroundColor = [UIColor baseColor];
        [self.selectButton setTitle:@"取消报名" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor baseColor];
    }
    
    
    self.interviewTimeLabel.text = [NSString stringWithFormat:@"面试时间：%@",model.interviewTime];
    self.workNameLabel.text = [NSString stringWithFormat:@"应聘岗位：%@",model.workName];
    self.teacherNameLabel.text = [NSString stringWithFormat:@"驻厂老师：%@",model.teacherList.count?model.teacherList[0].teacherName:@""];
    
    if (model.teacherList.count > 1) {
        self.teacherNameLabel.text = [NSString stringWithFormat:@"驻厂老师：%@ -%@",model.teacherList.count?model.teacherList[0].teacherName:@"",model.teacherList[0].teacherTel];
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻厂老师：%@ -%@",model.teacherList.count>1?model.teacherList[1].teacherName:@"",model.teacherList[1].teacherTel];
    }else{
        self.teacherTelLabel.text = [NSString stringWithFormat:@"联系方式：%@",model.teacherList.count?model.teacherList[0].teacherTel:@""];
    }
    
    if (model.teacherList.count == 0) {
        self.teacherNameHeight.constant = 0;
        self.teacherNameViewHeight.constant = 0;
        self.teacherTelHeight.constant = 0;
        self.teacherTelViewHeight.constant = 0;
    }else{
        self.teacherNameHeight.constant = 39;
        self.teacherNameViewHeight.constant = 1;
        self.teacherTelHeight.constant = 39;
        self.teacherTelViewHeight.constant = 1;
    }
    
    self.recruitAddressLabel.text = [NSString stringWithFormat:@"面试地点：%@",model.recruitAddress];
    
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
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",self.coordinate.latitude,self.coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [[self viewController] presentViewController:alertController animated:YES completion:nil];

}

//获取控制器

- (UIViewController *)viewController

{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
 }
 return nil;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
