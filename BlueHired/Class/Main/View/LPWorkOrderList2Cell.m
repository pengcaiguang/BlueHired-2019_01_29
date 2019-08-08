//
//  LPWorkOrderList2Cell.m
//  BlueHired
//
//  Created by iMac on 2019/5/9.
//  Copyright © 2019 lanpin. All rights reserved.
//
#import "LPWorkorderListModel.h"
#import "LPInCommentsVC.h"
#import "LPWorkOrderList2Cell.h"
#import "LPWorkDetailVC.h"

@implementation LPWorkOrderList2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectButton.layer.cornerRadius = LENGTH_SIZE(12);
    self.selectButton.layer.borderWidth = LENGTH_SIZE(1);
    self.selectButton.layer.borderColor = [UIColor baseColor].CGColor;
    
    self.ShareButton.layer.cornerRadius = LENGTH_SIZE(12);
    self.ShareButton.layer.borderWidth = LENGTH_SIZE(1);
    self.ShareButton.layer.borderColor = [UIColor baseColor].CGColor;
    
    self.CommentButton.layer.cornerRadius = LENGTH_SIZE(12);
    self.CommentButton.layer.borderWidth = LENGTH_SIZE(1);
    self.CommentButton.layer.borderColor = [UIColor baseColor].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CellSelect:)];
    [self.TopView addGestureRecognizer:tap];
    
}

-(void)CellSelect:(UITapGestureRecognizer *)Tap{
    LPWorklistDataWorkListModel *m = [[LPWorklistDataWorkListModel alloc] init];
    m.id = self.model.workId;
    m.isApply = self.model.isApply;

    LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.workListModel = m;
    vc.isWorkOrder = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
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
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",reviseString(model.workMoney)];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    }
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@",model.workTypeName];
    self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人 / 已报名%@人",model.maxNumber,model.applyNumber ? model.applyNumber : @"0"];

    if (model.recruitStatus.integerValue == 1) {
        self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人",model.maxNumber];
        self.isWorkers.hidden = NO;
    }else{
 
        self.isWorkers.hidden = YES;
    }
    
    self.isApplyLabel.hidden = YES;
 
    self.ShareButton.hidden = YES;
    self.CommentButton.hidden = YES;

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
        
        if (model.remarkStatus.integerValue == 0) {
            self.CommentButton.hidden = YES;
        }else if (model.remarkStatus.integerValue == 1 || model.remarkStatus.integerValue == 2){
            [self.CommentButton setTitle:@"  评价  " forState:UIControlStateNormal];
            self.CommentButton.hidden = NO;
        }else if (model.remarkStatus.integerValue == 3 || model.remarkStatus.integerValue == 4){
            [self.CommentButton setTitle:@" 我的评价 " forState:UIControlStateNormal];
            self.CommentButton.hidden = NO;
        }
            
        self.statusLabel.text = @"面试状态：入职成功";

        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
        
    }else{
        self.statusLabel.text = @"面试状态：面试预约中";
        [self.selectButton setTitle:@"取消报名" forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor baseColor].CGColor;
        self.ShareButton.hidden = NO;
        
    }
  
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.statusLabel.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fabf48"] range:[self.statusLabel.text rangeOfString:@"面试预约中"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5353"] range:[self.statusLabel.text rangeOfString:@"面试失败"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5353"] range:[self.statusLabel.text rangeOfString:@"放弃入职"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5353"] range:[self.statusLabel.text rangeOfString:@"已招满"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#3cafff"] range:[self.statusLabel.text rangeOfString:@"面试通过"]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#3cafff"] range:[self.statusLabel.text rangeOfString:@"入职成功"]];

    
    self.statusLabel.attributedText = string;
    
    if (([model.status integerValue] == 1 ||
         [model.status integerValue] == 4 ||
         [model.status integerValue] == 5 ) && model.reMoney.floatValue > 0.0 ) {
        self.interviewTimeLabel.text = [NSString stringWithFormat:@"返费金额：%@元/月",[LPTools isNullToString:model.reMoney]];

        NSMutableAttributedString *reMoneyStr = [[NSMutableAttributedString alloc] initWithString:self.interviewTimeLabel.text];
        [reMoneyStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"#3cafff"]
                           range:[self.interviewTimeLabel.text rangeOfString:[NSString stringWithFormat:@"%@元/月",[LPTools isNullToString:model.reMoney]]]];
        self.interviewTimeLabel.attributedText = reMoneyStr;

        self.recruitAddressLabel.text = [NSString stringWithFormat:@"返费时间：%@个月",[LPTools isNullToString:model.reTime]];
        NSMutableAttributedString *reTimeStr = [[NSMutableAttributedString alloc] initWithString:self.recruitAddressLabel.text];
        [reTimeStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#3cafff"]
                          range:[self.recruitAddressLabel.text rangeOfString:[NSString stringWithFormat:@"%@个月",[LPTools isNullToString:model.reTime]]]];
        self.recruitAddressLabel.attributedText = reTimeStr;
 
        self.NavBtn.hidden = YES;
        
    }else{
        self.interviewTimeLabel.text = [NSString stringWithFormat:@"面试时间：%@",[LPTools isNullToString:model.interviewTime]];
        self.recruitAddressLabel.text = [NSString stringWithFormat:@"面试地点：%@",[LPTools isNullToString:model.recruitAddress]];
        
        NSMutableAttributedString *reMoneyStr = [[NSMutableAttributedString alloc] initWithString:self.interviewTimeLabel.text];
        NSMutableAttributedString *reTimeStr = [[NSMutableAttributedString alloc] initWithString:self.recruitAddressLabel.text];

        self.interviewTimeLabel.attributedText = reMoneyStr;
        self.recruitAddressLabel.attributedText = reTimeStr;
        self.NavBtn.hidden = NO;

    }


    if (model.teacherList.count == 0) {
        self.teacherNameLabel.text = [NSString stringWithFormat:@"驻厂老师：-"];
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻厂老师：-"];
        self.LayoutConstrain_BG_Height.constant = LENGTH_SIZE(123-23.0*2);
        self.teacherNameLabel.hidden = YES;
        self.teacherTelLabel.hidden = YES;

    }else if (model.teacherList.count == 1){
        self.teacherNameLabel.text = [NSString stringWithFormat:@"驻厂老师：%@  %@",
                                      [LPTools isNullToString:model.teacherList[0].teacherName],
                                      [LPTools isNullToString:model.teacherList[0].teacherTel]];
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻厂老师：-"];
        self.LayoutConstrain_BG_Height.constant = LENGTH_SIZE(123-23.0);
        self.teacherNameLabel.hidden = NO;
        self.teacherTelLabel.hidden = YES;
        
    }else if (model.teacherList.count >1){
        self.teacherNameLabel.text = [NSString stringWithFormat:@"驻厂老师：%@  %@",
                                      [LPTools isNullToString:model.teacherList[0].teacherName],
                                      [LPTools isNullToString:model.teacherList[0].teacherTel]];
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻厂老师：%@  %@",
                                     [LPTools isNullToString:model.teacherList[1].teacherName],
                                     [LPTools isNullToString:model.teacherList[1].teacherTel]];
        
        self.LayoutConstrain_BG_Height.constant = LENGTH_SIZE(123);
        self.teacherNameLabel.hidden = NO;
        self.teacherTelLabel.hidden = NO;
        
    }
    
    if (model.restTime.length>0) {
        self.restTimeTitle.text = @"有效时间：";
        self.restTime.text = [LPTools isNullToString:model.restTime];
        CGFloat RestH = [LPTools calculateRowHeight:self.restTime.text fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(99)];
        
        self.LayoutConstrain_RestTitle_Height.constant = LENGTH_SIZE(11)+RestH;
        
    }else{
        self.restTimeTitle.text = @"";
        self.restTime.text = @"";
        self.LayoutConstrain_RestTitle_Height.constant = LENGTH_SIZE(11);
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"报名时间: %@",[NSString convertStringToTime:model.time]];
}


- (IBAction)ToMap:(id)sender {
 
    NSDecimalNumber *XNumber = [NSDecimalNumber decimalNumberWithString:_model.x];
    NSDecimalNumber *YNumber = [NSDecimalNumber decimalNumberWithString:_model.y];
 
    CLLocationCoordinate2D pt2 = {[XNumber doubleValue],[YNumber doubleValue]};
    
      self.coordinate = [self GCJ02FromBD09:pt2];
    
    [self ToNavMap];
}
- (IBAction)TouchComment:(UIButton *)sender {
    LPInCommentsVC *vc = [[LPInCommentsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;

    if (self.model.remarkStatus.integerValue == 1 || self.model.remarkStatus.integerValue == 2) {
        vc.Type = 1;
    }else if (self.model.remarkStatus.integerValue == 3){
        vc.Type = 2;
    }else if (self.model.remarkStatus.integerValue == 4){
        vc.Type = 3;
    }
    
    vc.model = self.model;
    vc.workOrderId = self.model.id.integerValue;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];

}

- (IBAction)touchSelectButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(buttonClick:workId:)]) {
        NSInteger index;
        if ([self.model.status integerValue] == 1 ||
            [self.model.status integerValue] == 2 ||
            [self.model.status integerValue] == 3 ||
            [self.model.status integerValue] == 4 ||
            [self.model.status integerValue] == 5){
            index = [self.model.status integerValue] == 1 ? 2 : 0 ;//删除
            [self.delegate buttonClick:index workId:self.model];
        }else{
            index = 1;//取消
            [self.delegate buttonClick:index workId:self.model];
        }
    }
}

- (IBAction)Touchshare:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@referral?interviewId=%ld",
                     BaseRequestWeiXiURLTWO,
                     self.model.id.integerValue];
    NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [LPTools ClickShare:encodedUrl Title:[NSString stringWithFormat:@"您的好友在蓝聘报名了%@，快来替他点赞加油，帮他获取更多返费吧！",_model.mechanismName]];
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
