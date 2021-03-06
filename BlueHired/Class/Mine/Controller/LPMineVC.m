//
//  LPMineVC.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMineVC.h"

#import "LPMine2Cell.h"
#import "LPMineCardCell.h"
#import "LPLoginVC.h"
#import "LPUserMaterialModel.h"
#import "LPChangePhoneVC.h"
#import "LPChangePasswordVC.h"
#import "LPSalarycCardVC.h"
#import "LPCustomerServiceVC.h"
#import "LPMineBillCell.h"
#import "LPActivityVC.h"
#import "LPCollectionVC.h"
#import "LPInfoVC.h"
#import "LPAccountManageVC.h"
#import "LPIntegralDrawDatelis.h"
#import "LPIntegralDrawVC.h"
#import "LPSalaryBreakdownVC.h"
#import "LPAddressBookVC.h"
#import <Contacts/Contacts.h>
#import "LPEmployeeManageVC.h"
#import "LPScoreStore.h"
#import "LPHXCustomerServiceVC.h"

static NSString *LPMineCellID = @"LPMine2Cell";
static NSString *LPMineBillCellID = @"LPMineBillCell";
static NSString *LPMineCardCellID = @"LPMineCardCell";

@interface LPMineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Headtableview;

@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;
@property(nonatomic,assign) BOOL signin;
@property(nonatomic,strong) UIButton *MessageBt;
@property(nonatomic,strong) NSArray *RecordArr;

@end

@implementation LPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFF2F2F2"];

    [self.view addSubview:self.Headtableview];
    [self.Headtableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (IS_iPhoneX) {
            make.height.mas_equalTo(LENGTH_SIZE(200)+10+24);
            make.top.mas_equalTo(0);
        }else{
            make.height.mas_equalTo(LENGTH_SIZE(200)+10);
            make.top.mas_equalTo(0);
        }
//        make.bottom.mas_equalTo(0);
    }];
    
    
    [self.view addSubview:self.tableview];
    self.tableview.clipsToBounds = YES;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.Headtableview.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    
    NSLog(@"%@",[NSString isIdentityCard:@"350823199402161018"]?@"1":@"0");

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

//    kUserDefaultsSave(@"0", kLoginStatus);
    if (AlreadyLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self requestUserMaterial];
        [self requestQueryInfounreadNum];
        [self requestQueryGetBillRecordList];

        });
        
        [self requestSelectCurIsSign];
        self.tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            [self requestQueryInfounreadNum];
            [self requestUserMaterial];
            [self requestSelectCurIsSign];
            [self requestQueryGetBillRecordList];
        }];
    }else{
        self.tableview.mj_header = nil;
        self.RecordArr = [NSArray new];
        self.userMaterialModel = nil;
        [self.MessageBt setTitle:@"" forState:UIControlStateNormal];
        self.MessageBt.backgroundColor = [UIColor clearColor];
//        [self.tableview reloadData];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
 

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
    [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
    kUserDefaultsSave(userMaterialModel.data.role, USERDATA);
//    kUserDefaultsSave(@"21", USERDATA);
    [self.tableview reloadData];
    [self.Headtableview reloadData];

}
-(void)setSignin:(BOOL)signin{
    _signin = signin;
//    [self.tableview reloadData];
    [self.Headtableview reloadData];
//    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.Headtableview) {
        return 1;
    }
    if (self.RecordArr.count) {
        return 4;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.Headtableview) {
        return IS_iPhoneX ? LENGTH_SIZE(200.0) +24.0 : LENGTH_SIZE(200.0);
    }else{
        if (self.RecordArr.count) {
            if (indexPath.section == 0) {
                return LENGTH_SIZE(117);
            }else if (indexPath.section == 1) {
                return LENGTH_SIZE(40);
            }else if (indexPath.section == 2){
                return LENGTH_SIZE(160);
            }else{
                return LENGTH_SIZE(50);
            }
        }else{
            if (indexPath.section == 0) {
                return LENGTH_SIZE(117);
            }else if (indexPath.section == 1) {
                //            if (kUserDefaultsValue(USERDATA).integerValue == 1 || kUserDefaultsValue(USERDATA).integerValue == 2){
                //                return 86;
                //            }else{
                return LENGTH_SIZE(172);
                //            }
            }else{
                return LENGTH_SIZE(50);
            }
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.Headtableview) {
        return 1;
    }
    
    if (self.RecordArr.count) {
        if (section == 0 || section == 1|| section == 2) {
            return 1;
        }else{
            return 8;
        }
    }
    
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return 8;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
//    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

// 重新绘制cell边框
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.RecordArr.count) {
        if (tableView == self.tableview &&( indexPath.section == 3 )) {
            [self CustomtableView:tableView willDisplay:cell IndexPath:indexPath];
        }
    }else{
        if (tableView == self.tableview && indexPath.section == 2) {
            [self CustomtableView:tableView willDisplay:cell IndexPath:indexPath];
        }
    }
    
}

-(void)CustomtableView:(UITableView *)tableView willDisplay:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        // 圆角弧度半径
        CGFloat cornerRadius = 4.f;
        // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
        cell.backgroundColor = UIColor.clearColor;
        
        // 创建一个shapeLayer
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
        // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
        CGMutablePathRef pathRef = CGPathCreateMutable();
        // 获取cell的size
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        // CGRectGetMinY：返回对象顶点坐标
        // CGRectGetMaxY：返回对象底点坐标
        // CGRectGetMinX：返回对象左边缘坐标
        // CGRectGetMaxX：返回对象右边缘坐标
        
        // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
        BOOL addLine = NO;
        // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        if (indexPath.row == 0) {
            // 初始起点为cell的左下角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            // 初始起点为cell的左上角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            // 添加cell的rectangle信息到path中（不包括圆角）
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
        layer.path = pathRef;
        backgroundLayer.path = pathRef;
        // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
        CFRelease(pathRef);
        // 按照shape layer的path填充颜色，类似于渲染render
        // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        layer.fillColor = [UIColor whiteColor].CGColor;
        // 添加分隔线图层
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
            // 分隔线颜色取自于原来tableview的分隔线颜色
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        
        // view大小与cell一致
        UIView *roundView = [[UIView alloc] initWithFrame:bounds];
        // 添加自定义圆角后的图层到roundView中
        [roundView.layer insertSublayer:layer atIndex:0];
        roundView.backgroundColor = UIColor.clearColor;
        //cell的背景view
        //cell.selectedBackgroundView = roundView;
        cell.backgroundView = roundView;
        
        //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
        backgroundLayer.fillColor = tableView.separatorColor.CGColor;
        [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
        selectedBackgroundView.backgroundColor = UIColor.clearColor;
        cell.selectedBackgroundView = selectedBackgroundView;
        
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView == self.Headtableview) {
        LPMine2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineCellID];
        if(cell == nil){
            cell = [[LPMine2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineCellID];
        }
        cell.userMaterialModel = self.userMaterialModel;
        cell.signin = self.signin;
        self.MessageBt = cell.MessageButton;
        return cell;
    }
 
    if (self.RecordArr.count) {
        if (indexPath.section == 0) {
            LPMineBillCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineBillCellID];
            if(cell == nil){
                cell = [[LPMineBillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineBillCellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userMaterialModel = self.userMaterialModel;
            return cell;
        }
        if (indexPath.section == 1) {
            static NSString *rid=@"Rcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if(cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
                UIImageView *Image = [[UIImageView alloc] init];
                [cell.contentView addSubview:Image];
                [Image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.left.mas_offset(LENGTH_SIZE(12));
                    make.width.height.mas_offset(LENGTH_SIZE(27));
                }];
                Image.tag = 1000;
                Image.contentMode=UIViewContentModeScaleAspectFit;

                UILabel *label = [[UILabel alloc] init];
                [cell.contentView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.left.mas_offset(LENGTH_SIZE(12+27+8));
                }];
                label.textColor = [UIColor baseColor];
                label.font = FONT_SIZE(14);
                label.tag = 2000;
                
            }
            cell.layer.cornerRadius = 4.0;
            cell.layer.masksToBounds = YES;
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel *textLabel = [cell.contentView viewWithTag:2000];
            UIImageView *ImageView = [cell.contentView viewWithTag:1000];
           
            
            ImageView.image = [UIImage imageNamed:@"notice"];
            textLabel.text = [NSString stringWithFormat:@"%@工资已到账，待领取 >>",self.RecordArr[0]];
            
 
            return cell;
        } else if (indexPath.section == 2) {
            LPMineCardCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineCardCellID];
            if(cell == nil){
                cell = [[LPMineCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineCardCellID];
            }
            cell.indexPath = indexPath;
            cell.userMaterialModel = self.userMaterialModel;
            cell.RecordArr = self.RecordArr;
            [cell awakeFromNib];
            return cell;
        } else {
            
            static NSString *rid=@"cell";
                   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                   if(cell == nil){
                       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
                       UIImageView *Image = [[UIImageView alloc] init];
                       [cell.contentView addSubview:Image];
                       [Image mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.centerY.equalTo(cell.contentView);
                           make.left.mas_offset(LENGTH_SIZE(15));
                           make.width.height.mas_offset(LENGTH_SIZE(21));
                       }];
                       Image.tag = 1000;
                       Image.contentMode=UIViewContentModeScaleAspectFit;

                       UILabel *label = [[UILabel alloc] init];
                       [cell.contentView addSubview:label];
                       [label mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.centerY.equalTo(cell.contentView);
                           make.left.mas_offset(LENGTH_SIZE(15+21+8));
                       }];
                       label.textColor = [UIColor colorWithHexString:@"#444444"];
                       label.font = FONT_SIZE(15);
                       label.tag = 2000;
                   }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *textLabel = [cell.contentView viewWithTag:2000];
            UIImageView *ImageView = [cell.contentView viewWithTag:1000];
            
          
                if (indexPath.row == 0) {
                    ImageView.image = [UIImage imageNamed:@"c_00"];
                    textLabel.text = @"员工归属管理";
                }else if (indexPath.row == 1) {
                    ImageView.image = [UIImage imageNamed:@"salaryCard_img"];
                    textLabel.text = @"工资卡管理";
                }else if (indexPath.row == 2) {
                    ImageView.image = [UIImage imageNamed:@"changePassword_img"];
                    textLabel.text = @"账号管理";
                }else if (indexPath.row == 3){
                    ImageView.image = [UIImage imageNamed:@"c_activity"];
                    textLabel.text = @"通讯录好友";
                }else if (indexPath.row == 4) {
                    ImageView.image = [UIImage imageNamed:@"ActivityCenterImage"];
                    textLabel.text = @"活动中心";
                }else if (indexPath.row == 5) {
                    ImageView.image = [UIImage imageNamed:@"c_integral"];
                    textLabel.text = @"幸运积分";
                }else if (indexPath.row == 6) {
                    ImageView.image = [UIImage imageNamed:@"collectionCenter_img"];
                    textLabel.text = @"收藏中心";
                }else if (indexPath.row == 7){
                    ImageView.image = [UIImage imageNamed:@"customerService_img"];
                    textLabel.text = @"专属客服";
                }
            
 
            return cell;

        }
        
    }else{
        if (indexPath.section == 0) {
            LPMineBillCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineBillCellID];
            if(cell == nil){
                cell = [[LPMineBillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineBillCellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userMaterialModel = self.userMaterialModel;
            return cell;
        } else if (indexPath.section == 1) {
            LPMineCardCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineCardCellID];
            if(cell == nil){
                cell = [[LPMineCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineCardCellID];
            }
            cell.indexPath = indexPath;
            cell.userMaterialModel = self.userMaterialModel;
            cell.RecordArr = self.RecordArr;
            [cell awakeFromNib];
            return cell;
        } else {
            static NSString *rid=@"cell";
                   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                   if(cell == nil){
                       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
                       UIImageView *Image = [[UIImageView alloc] init];
                       [cell.contentView addSubview:Image];
                       [Image mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.centerY.equalTo(cell.contentView);
                           make.left.mas_offset(LENGTH_SIZE(15));
                           make.width.height.mas_offset(LENGTH_SIZE(21));
                       }];
                       Image.tag = 1000;
                       Image.contentMode=UIViewContentModeScaleAspectFit;

                       UILabel *label = [[UILabel alloc] init];
                       [cell.contentView addSubview:label];
                       [label mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.centerY.equalTo(cell.contentView);
                           make.left.mas_offset(LENGTH_SIZE(15+21+8));
                       }];
                       label.textColor = [UIColor colorWithHexString:@"#444444"];
                       label.font = FONT_SIZE(15);
                       label.tag = 2000;
                   }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *textLabel = [cell.contentView viewWithTag:2000];
            UIImageView *ImageView = [cell.contentView viewWithTag:1000];

                if (indexPath.row == 0) {
                    ImageView.image = [UIImage imageNamed:@"c_00"];
                    textLabel.text = @"员工归属管理";
                }else if (indexPath.row == 1) {
                    ImageView.image = [UIImage imageNamed:@"salaryCard_img"];
                    textLabel.text = @"工资卡管理";
                }else if (indexPath.row == 2) {
                    ImageView.image = [UIImage imageNamed:@"changePassword_img"];
                    textLabel.text = @"账号管理";
                }else if (indexPath.row == 3){
                    ImageView.image = [UIImage imageNamed:@"c_activity"];
                    textLabel.text = @"通讯录好友";
                }else if (indexPath.row == 4) {
                    ImageView.image = [UIImage imageNamed:@"ActivityCenterImage"];
                    textLabel.text = @"活动中心";
                }else if (indexPath.row == 5) {
                    ImageView.image = [UIImage imageNamed:@"c_integral"];
                    textLabel.text = @"幸运积分";
                }else if (indexPath.row == 6) {
                    ImageView.image = [UIImage imageNamed:@"collectionCenter_img"];
                    textLabel.text = @"收藏中心";
                }else if (indexPath.row == 7){
                    ImageView.image = [UIImage imageNamed:@"customerService_img"];
                    textLabel.text = @"专属客服";
                }
 
                  return cell;
        }
        
        
  
    }
    
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (AlreadyLogin && self.RecordArr.count && indexPath.section == 1 && indexPath.row == 0) {
        LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.RecordDate = self.RecordArr[0];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
    
    if ( AlreadyLogin ) {
        if (indexPath.section == 2 || indexPath.section == 3) {
                if (indexPath.row == 0) {
                    LPEmployeeManageVC *vc = [[LPEmployeeManageVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (indexPath.row == 1) {//工资卡管理
                    LPSalarycCardVC *vc = [[LPSalarycCardVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (indexPath.row == 2) {//账号管理
                    LPAccountManageVC *vc = [[LPAccountManageVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (indexPath.row == 3){ //通讯录好友
                    [self  requestContactAuthorAfterSystemVersion9];
                }else if (indexPath.row == 4){//活动中心
                    LPActivityVC *vc = [[LPActivityVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (indexPath.row == 5){//幸运积分
                    LPIntegralDrawVC *vc = [[LPIntegralDrawVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (indexPath.row == 6){//收藏
                    LPCollectionVC *vc = [[LPCollectionVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{//客服
                    LPHXCustomerServiceVC *vc = [[LPHXCustomerServiceVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
         }
    }else{
        [LoginUtils validationLogin:self];
    }
}

//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        WEAK_SELF()
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"授权失败");
                    [weakSelf showAlertViewAboutNotAuthorAccessContact];
                }else {
                    NSLog(@"成功授权");
                    LPAddressBookVC *vc = [[LPAddressBookVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            });
            
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        LPAddressBookVC *vc = [[LPAddressBookVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [alertController addAction:CancelAction];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - request
-(void)requestUserMaterial{
    NSString *string = kUserDefaultsValue(LOGINID);
    NSDictionary *dic = @{
                          @"id":string
                          };
    [NetApiManager requestUserMaterialWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
//        [self.tableview.mj_header endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                if (!responseObject[@"code"]) {
                    [LPTools UserDefaulatsRemove];
                }
                self.userMaterialModel = [LPUserMaterialModel mj_objectWithKeyValues:responseObject];
            }else{              //返回不成功,清空
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
             }
        }else{
//            [LPTools UserDefaulatsRemove];
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestSelectCurIsSign{
    [NetApiManager requestSelectCurIsSignWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (!ISNIL(responseObject[@"data"])) {
                    if ([responseObject[@"data"] integerValue] == 0) {
                        self.signin = NO;
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        self.signin = YES;
                    }
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



-(void)requestQueryInfounreadNum{
    NSDictionary *dic = @{@"type":@(1)
                          };
    [NetApiManager requestQueryUnreadNumWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSInteger num = [responseObject[@"data"] integerValue];
                if (num == 0) {
                    [self.MessageBt setTitle:@"" forState:UIControlStateNormal];
                    self.MessageBt.backgroundColor = [UIColor clearColor];
                }
                else if (num>9)
                {
                    [self.MessageBt setTitle:@"9+" forState:UIControlStateNormal];
                    self.MessageBt.backgroundColor = [UIColor redColor];
                }
                else
                {
                    [self.MessageBt setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
                    self.MessageBt.backgroundColor = [UIColor redColor];
                }
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}




-(void)requestQueryGetBillRecordList{
    [NetApiManager requestQueryGetBillRecordList:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                 self.RecordArr = [responseObject[@"data"] mj_JSONObject];
                [self.tableview reloadData];
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
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
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPMineCellID bundle:nil] forCellReuseIdentifier:LPMineCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPMineCardCellID bundle:nil] forCellReuseIdentifier:LPMineCardCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPMineBillCellID bundle:nil] forCellReuseIdentifier:LPMineBillCellID];
        _tableview.showsVerticalScrollIndicator = NO;

        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            [self requestUserMaterial];
            [self requestSelectCurIsSign];
            [self requestQueryInfounreadNum];
            [self requestQueryGetBillRecordList];
        }];
    }
    return _tableview;
}

-(UITableView *)Headtableview{
    if (!_Headtableview) {
        _Headtableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _Headtableview.delegate = self;
        _Headtableview.dataSource = self;
        _Headtableview.tableFooterView = [[UIView alloc]init];
        _Headtableview.rowHeight = UITableViewAutomaticDimension;
        _Headtableview.estimatedRowHeight = 0;
        _Headtableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _Headtableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _Headtableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_Headtableview registerNib:[UINib nibWithNibName:LPMineCellID bundle:nil] forCellReuseIdentifier:LPMineCellID];
        [_Headtableview registerNib:[UINib nibWithNibName:LPMineCardCellID bundle:nil] forCellReuseIdentifier:LPMineCardCellID];
        
        _Headtableview.sectionHeaderHeight = CGFLOAT_MIN;
        _Headtableview.sectionFooterHeight = 10;
        _Headtableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _Headtableview.scrollEnabled = NO;
 //        _Headtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self requestUserMaterial];
//            [self requestSelectCurIsSign];
//        }];
    }
    return _Headtableview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
