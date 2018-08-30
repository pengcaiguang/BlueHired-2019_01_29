//
//  LPMineVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMineVC.h"
#import "LPMineCell.h"
#import "LPMineCardCell.h"
#import "LPLoginVC.h"

static NSString *LPMineCellID = @"LPMineCell";
static NSString *LPMineCardCellID = @"LPMineCardCell";

@interface LPMineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation LPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(-20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    

}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
////设置状态栏颜色
//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//}
////！！！重点在viewWillAppear方法里调用下面两个方法
//-(void)viewWillAppear:(BOOL)animated{
//    [self preferredStatusBarStyle];
//    [self setStatusBarBackgroundColor:[UIColor baseColor]];
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [self preferredStatusBarStyle];
//    [self setStatusBarBackgroundColor:[UIColor clearColor]];
//}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        LPMineCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineCellID];
        if(cell == nil){
            cell = [[LPMineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineCellID];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        LPMineCardCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMineCardCellID];
        if(cell == nil){
            cell = [[LPMineCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMineCardCellID];
        }
        return cell;
    }
    
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#3A3A3A"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"salaryCard_img"];
            cell.textLabel.text = @"工资管理";
        }else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"changePhoneNumber_img"];
            cell.textLabel.text = @"手机号修改";
        }else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"changePassword_img"];
            cell.textLabel.text = @"密码修改";
        }else if (indexPath.row == 3) {
            cell.imageView.image = [UIImage imageNamed:@"customerService_img"];
            cell.textLabel.text = @"专属客服";
        }else if (indexPath.row == 4) {
            cell.imageView.image = [UIImage imageNamed:@"collectionCenter_img"];
            cell.textLabel.text = @"收藏中心";
        }
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([LoginUtils validationLogin:self]) {
        
    }
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPMineCellID bundle:nil] forCellReuseIdentifier:LPMineCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPMineCardCellID bundle:nil] forCellReuseIdentifier:LPMineCardCellID];
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        
    }
    return _tableview;
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
