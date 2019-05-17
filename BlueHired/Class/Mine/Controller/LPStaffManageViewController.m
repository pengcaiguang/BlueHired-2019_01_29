//
//  LPStaffManageViewController.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPStaffManageViewController.h"
#import "LPFirmVC.h"
#import "LPEntryVC.h"
#import "LPAffiliationMenageVC.h"
#import "LPMapLocCell.h"
#import "LPLendMechanismModel.h"

static NSString *LPMapLocCellID = @"LPMapLocCell";


@interface LPStaffManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *EntryBt;
@property (weak, nonatomic) IBOutlet UIButton *FirmBt;
@property (weak, nonatomic) IBOutlet UIButton *SelectBt;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (nonatomic,strong) UITableView *CompanyTableView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *MechanismView;

@property (nonatomic,strong) LPLendMechanismModel *model;
@property (nonatomic,assign) NSInteger selectCell;

@end

@implementation LPStaffManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"人员管理";
    // Do any additional setup after loading the view from its nib.
    self.FirmBt.layer.borderWidth = 0.5;
    self.FirmBt.layer.borderColor = [UIColor baseColor].CGColor;
    self.selectView.layer.borderWidth = 0.5;
    self.selectView.layer.borderColor = [UIColor baseColor].CGColor;
    self.selectView.layer.cornerRadius = 5;
    self.SelectBt.titleLabel.numberOfLines = 2;
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.MechanismView];
    [self.MechanismView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(234);
    }];
    self.MechanismView.hidden = YES;
    self.bgView.hidden = YES;
    
    [self requestQueryTeacherMechanism];
    
}
- (IBAction)touchentry:(id)sender {
//    if (kUserDefaultsValue(USERDATA).integerValue == 4  ||
//        kUserDefaultsValue(USERDATA).integerValue == 11  ||
//        kUserDefaultsValue(USERDATA).integerValue == 12 ||
//        kUserDefaultsValue(USERDATA).integerValue == 13 ||
//        kUserDefaultsValue(USERDATA).integerValue == 14 ||
//        kUserDefaultsValue(USERDATA).integerValue == 19 ||
//        kUserDefaultsValue(USERDATA).integerValue == 20 ||
//        kUserDefaultsValue(USERDATA).integerValue == 21 ) {
//        
//        if (self.SelectBt.currentTitle.length == 0) {
//            [LPTools AlertMessageView:@"请选择企业"];
//            return;
//        }
//        
//        LPEntryVC *vc = [[LPEntryVC alloc] init];
//        vc.Mechanismodel = self.model.data[self.selectCell];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        [LPTools AlertMessageView:@"权限不足"];
//    }

}
- (IBAction)touchFirm:(id)sender {
//    if (kUserDefaultsValue(USERDATA).integerValue == 4  ||
//        kUserDefaultsValue(USERDATA).integerValue == 15  ||
//        kUserDefaultsValue(USERDATA).integerValue == 16 ||
//        kUserDefaultsValue(USERDATA).integerValue == 17 ||
//        kUserDefaultsValue(USERDATA).integerValue == 18 ||
//        kUserDefaultsValue(USERDATA).integerValue == 19 ||
//        kUserDefaultsValue(USERDATA).integerValue == 20 ||
//        kUserDefaultsValue(USERDATA).integerValue == 21 ) {
//        NSLog(@"%@",self.SelectBt.currentTitle);
//        if (self.SelectBt.currentTitle.length == 0) {
//            [LPTools AlertMessageView:@"请选择企业"];
//            return;
//        }
//
//        LPFirmVC *vc = [[LPFirmVC alloc] init];
//        vc.Mechanismodel = self.model.data[self.selectCell];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        [LPTools AlertMessageView:@"权限不足"];
//    }

}

- (IBAction)ToucheSelect:(id)sender {
    self.MechanismView.hidden = !self.MechanismView.hidden;
    self.bgView.hidden = self.MechanismView.hidden;
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.count;
 }

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMapLocCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMapLocCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPMapLocCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMapLocCellID];
        
    }
    LPLendMechanismDataModel *model = self.model.data[indexPath.row];
    cell.AddName.text = model.mechanismName;
    [cell.SelectBt setImage:[UIImage imageNamed:@"select_slices"] forState:UIControlStateNormal];

    if (self.selectCell == indexPath.row) {
        cell.AddName.textColor = [UIColor baseColor];
        cell.SelectBt.hidden = NO;
    }else{
        cell.AddName.textColor = [UIColor blackColor];
        cell.SelectBt.hidden = YES;
    }
    cell.AddDetail.text = @"";
     return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//           [self hiddenSelect];
    self.selectCell = indexPath.row;
    [self hiddenSelect];
    [self.SelectBt setTitle:self.model.data[self.selectCell].mechanismName forState:UIControlStateNormal];
    [tableView reloadData];
 }


#pragma mark - request
-(void)requestQueryTeacherMechanism{
    NSDictionary *dic = @{
                          };
    WEAK_SELF()
    [NetApiManager requestQueryTeacherMechanism:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
          if (isSuccess) {
              if ([responseObject[@"code"] integerValue] == 0) {
                  weakSelf.model = [LPLendMechanismModel mj_objectWithKeyValues:responseObject];
                  if (weakSelf.model.data.count) {
                      self.selectCell = 0;
                      [self.SelectBt setTitle:self.model.data[self.selectCell].mechanismName forState:UIControlStateNormal];
                  }
                  [weakSelf.CompanyTableView reloadData];
              }else{
                  [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
              }
             

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



#pragma mark lazy
- (UITableView *)CompanyTableView{
    if (!_CompanyTableView) {
        _CompanyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 234)];
        _CompanyTableView.delegate = self;
        _CompanyTableView.dataSource = self;
        _CompanyTableView.tableFooterView = [[UIView alloc]init];
        _CompanyTableView.rowHeight = UITableViewAutomaticDimension;
        _CompanyTableView.estimatedRowHeight = 100;
        _CompanyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _CompanyTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_CompanyTableView registerNib:[UINib nibWithNibName:LPMapLocCellID bundle:nil] forCellReuseIdentifier:LPMapLocCellID];
//        _CompanyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self requestQueryLendMoneyMechanism];
//        }];
        
       

    }
    return _CompanyTableView;
}

-(void)hiddenSelect{
    self.MechanismView.hidden = YES;
    self.bgView.hidden = YES;
}

-(UIView *)MechanismView{
    if (!_MechanismView) {
        _MechanismView = [[UIView alloc]init];
        [_MechanismView addSubview: self.CompanyTableView];
 
//        UIButton *CancelBt= [[UIButton alloc] initWithFrame:CGRectMake(0, 234-48, Screen_Width/2, 48)];
//        [_MechanismView addSubview:CancelBt];
//        CancelBt.layer.borderWidth = 1;
//        CancelBt.layer.borderColor = [UIColor colorWithHexString:@"#FFE6E6E6"].CGColor;
//        [CancelBt setTitle:@"取消" forState:UIControlStateNormal];
//        [CancelBt setTitleColor:[UIColor colorWithHexString:@"#FF666666"] forState:UIControlStateNormal];
//        [CancelBt addTarget:self action:@selector(TouchCancel) forControlEvents:UIControlEventTouchUpInside];
//
//
//        UIButton *confirmBt= [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width/2, 234-48, Screen_Width/2, 48)];
//        [_MechanismView addSubview:confirmBt];
//        confirmBt.layer.borderWidth = 1;
//        confirmBt.layer.borderColor = [UIColor colorWithHexString:@"#FFE6E6E6"].CGColor;
//        [confirmBt setTitle:@"确定" forState:UIControlStateNormal];
//        [confirmBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
//        [confirmBt addTarget:self action:@selector(Touchconfirm) forControlEvents:UIControlEventTouchUpInside];

    }
    return _MechanismView;
}

-(void)TouchCancel{
    [self hiddenSelect];
}

-(void)Touchconfirm{
    [self hiddenSelect];
    [self.SelectBt setTitle:self.model.data[self.selectCell].mechanismName forState:UIControlStateNormal];
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
@end
