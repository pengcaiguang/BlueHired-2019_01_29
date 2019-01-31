//
//  LPCircleSearchVC.m
//  BlueHired
//
//  Created by iMac on 2018/12/11.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCircleSearchVC.h"
#import "LPSearchBar.h"
#import "LPMapLocCell.h"


static NSString *LPMapLocCellID = @"LPMapLocCell";

@interface LPCircleSearchVC ()<AMapSearchDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic,strong) AMapLocationManager *locationManager;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic,copy) NSString *searchWord;
@property (nonatomic,copy) AMapLocationReGeocode *searchcity;
@property (nonatomic, strong) NSMutableArray<AMapPOI *> *poisListArray;

@end

@implementation LPCircleSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLocationManager];
 
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self setSearchView];
    [self setSearchButton];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}


-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 - 2 * 15 - 44, 44)];
    [searchBar becomeFirstResponder];
    UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
    [wrapView addSubview:searchBar];
    self.navigationItem.titleView = wrapView;
}
- (LPSearchBar *)addSearchBarWithFrame:(CGRect)frame {
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]initWithFrame:frame];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入搜索关键字";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14;
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }
    [searchField resignFirstResponder];

    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 28.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}
-(void)setSearchButton{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 47, 28);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 14;
    [button addTarget:self action:@selector(touchSearchButton) forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:[UIImage imageNamed:@"search_btn_bgView"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self touchSearchButton];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"-%@",searchBar.text);
    self.searchWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


-(void)touchSearchButton{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
     request.keywords            = self.searchWord;
    request.requireExtension    = YES;
     /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = true;
    request.city = self.searchcity.city;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.poisListArray.count;
 }

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
          LPMapLocCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMapLocCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(cell == nil){
            cell = [[LPMapLocCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMapLocCellID];
        }
        AMapPOI *model = self.poisListArray[indexPath.row];
        cell.AddName.text = model.name;
        cell.AddDetail.text = model.address;
//        cell.SelectBt.hidden = !model.IsSelect;
    
        return cell;
     
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *model = self.poisListArray[indexPath.row];
      if ([self.delegate respondsToSelector:@selector(LPCircleSearchBack:)]) {
          [self.delegate LPCircleSearchBack:model];
         [self.navigationController  popViewControllerAnimated:YES];
     }
}

#pragma mark lazy 定位.
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
             if (error.code == AMapLocationErrorLocateFailed)
            {
                [self.view showLoadingMeg:@"定位失败,请手动搜索" time:2.0];
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        self.searchcity = regeocode;
        // 周边检索
        [self searchPoiWithCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];

        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
    
    
}


- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord{
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude longitude:coord.longitude];
    request.radius = 500;   /// 搜索范围
    request.types = @"";
    request.sortrule = 1;              ///排序规则
    request.city = self.searchcity.city;
    [self.search AMapPOIAroundSearch:request];
    
}
 

 

#pragma mark lazy POI 搜索回调.
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        [LPTools AlertMessageView:@"没有相关位置,请换个关键字试试"];
         return;
    }
    
    //地址拼接省和市
    for (AMapPOI *p in  response.pois) {
        if ([self.searchcity.city isEqualToString:self.searchcity.district]) {
            p.address = [NSString stringWithFormat:@"%@%@%@",
                         [LPTools isNullToString:self.searchcity.province],
                         [LPTools isNullToString:self.searchcity.city],
                         p.address];
        }else{
            p.address = [NSString stringWithFormat:@"%@%@%@%@",[LPTools isNullToString:self.searchcity.province],
                         [LPTools isNullToString:self.searchcity.city],
                         [LPTools isNullToString:self.searchcity.district],p.address];
        }
        p.city = self.searchcity.city;
    }
    
    self.poisListArray = [response.pois mutableCopy];
    AMapPOI *poi1 = [[AMapPOI alloc] init];
    poi1.name = [NSString stringWithFormat:@"%@",self.searchcity.city];
    poi1.address = @"";
    [self.poisListArray insertObject:poi1 atIndex:0];
    
    AMapPOI *poi2 = [[AMapPOI alloc] init];
    poi2.name = @"保密";
    poi2.address = @"";
    [self.poisListArray insertObject:poi2 atIndex:0];
    
    [self.tableview reloadData];
    //解析response获取POI信息，具体解析见 Demo
}


#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPMapLocCellID bundle:nil] forCellReuseIdentifier:LPMapLocCellID];
    }
    return _tableview;
}

@end
