//
//  LPSelectCityVC.m
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSelectCityVC.h"
#import "LPCityDataManager.h"
#import "SCIndexViewConfiguration.h"
#import "UITableView+SCIndexView.h"
#import "LPCityCell.h"
#import "LPSearchBar.h"
#import "AddressPickerView.h"

static NSString *LPCityCellID = @"LPCityCell";

static NSString *CityRecently = @"CityRecently";

@interface LPSelectCityVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Subtableview;

@property(nonatomic,strong) LPCityDataManager *manager;
@property(nonatomic,strong) NSArray *firstLetterArray;
@property(nonatomic,strong) NSDictionary *listDic;

@property(nonatomic,strong) NSArray *recentlyArray;
@property(nonatomic,assign) BOOL isSearch;

@property (nonatomic ,strong) NSDictionary   * dataDict;/**< 省市区数据源字典*/
@property (nonatomic ,strong) NSMutableArray * pArr;/**< 地址选择器数据源,装省份模型,每个省份模型内包含城市模型*/

@property (nonatomic, assign) NSInteger selectPRow;

@end

@implementation LPSelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.navigationItem.title = @"地址选择";
    self.isSearch = NO;
    self.recentlyArray = (NSArray *)kUserDefaultsValue(CityRecently);
    if (self.recentlyArray.count == 0) {
        NSMutableArray *mu = [NSMutableArray array];
        [mu addObject:@"全国"];
        self.recentlyArray = [mu copy];
    }
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.left.top.bottom.mas_offset(0);
        make.width.mas_offset(120);
    }];
    
    [self.view addSubview:self.Subtableview];
    [self.Subtableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.right.top.bottom.mas_offset(0);
        make.left.equalTo(self.tableview.mas_right).offset(0);
    }];
    
    
    
//    [self setSearchView];
//    [self setData];
    [self loadAddressData];
    
}
-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBar];
    UIView *wrapView = [[UIView alloc]init];
    wrapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28);
    wrapView.layer.cornerRadius = 14;
    wrapView.layer.masksToBounds = YES;
    self.navigationItem.titleView = wrapView;
    
    [wrapView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
}
- (LPSearchBar *)addSearchBar{
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]init];
    searchBar.delegate = self;
    searchBar.placeholder = @"城市中文名或拼音";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14;
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 28.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"-%@",searchBar.text);
    
    NSString *str = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (str.length  == 0) {
        self.isSearch = NO;
        NSArray *cityArray = [self.manager getCity];
        [self addNodataViewHidden:YES];
        [self sortArray:cityArray];
    }else{
        self.isSearch = YES;
        NSArray *array = [self.manager query:str];
        if (array.count > 0) {
            [self addNodataViewHidden:YES];
            [self sortArray:array];
        }else{
            [self addNodataViewHidden:NO];
        }
    }
}
-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        noDataView.hidden = hidden;
    }
}


#pragma mark - 加载地址数据
- (void)loadAddressData{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"province"
                                                          ofType:@"json"];
    
    NSError  * error;
    NSString * str22 = [NSString stringWithContentsOfFile:filePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
    
    if (error) {
        return;
    }
    
    _dataDict = [self dictionaryWithJsonString:str22];
    
    if (!_dataDict) {
        return;
    }
    
    NSArray *DataArray = [str22 mj_JSONObject];
    
    _pArr         = [[NSMutableArray alloc]init];
    
    NSArray * reArray = @[@"北京",@"上海",@"广州",@"深圳",@"天津",@"杭州",@"南京",@"成都",@"武汉"];
    AddressProvince * REp     = [AddressProvince provinceWithName:@"热门城市"
                                                           cities:reArray];
    [_pArr addObject:REp];
    
    AddressProvince * Allp     = [AddressProvince provinceWithName:@"全国"
                                                           cities:@[@"全国"]];
    [_pArr addObject:Allp];
 
    //省份模型数组加载各个省份模型
    for (int i = 0 ;i < DataArray.count; i++) {
        NSDictionary *dic = DataArray[i];
        NSArray  * citys = [dic[@"cities"] mj_JSONObject];
        NSMutableArray *Citys = [[NSMutableArray alloc] init];
        for (int j = 0 ;j < citys.count; j++) {
            NSDictionary *citysdic = citys[j];
            [Citys addObject:citysdic[@"name"]];
        }
        AddressProvince * p     = [AddressProvince provinceWithName:dic[@"name"]
                                                             cities:Citys];
        [_pArr addObject:p];
    }
    
 
}



-(void)setData{
    NSArray *cityArray = [self.manager getCity];
    
    [self sortArray:cityArray];
}

-(void)sortArray:(NSArray *)cityArray{
    
    NSMutableArray *modelCityArray = [NSMutableArray array];
    
    for (NSDictionary *dic in cityArray) {
        LPCityModel *model = [LPCityModel mj_objectWithKeyValues:dic];
        model.c_firstLetter = [[model.c_pinyin substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        [modelCityArray addObject:model];
    }
    
    NSMutableArray *firstArray = [NSMutableArray array];
    for (LPCityModel *model in modelCityArray) {
        [firstArray addObject:model.c_firstLetter];
    }
    NSSet *set = [NSSet setWithArray:firstArray];
    NSMutableArray *array = [[set allObjects] mutableCopy];
    if (!self.isSearch) {
        [array insertObject:@"热门城市" atIndex:0];
        [array insertObject:@"热门城市" atIndex:0];
//        [array insertObject:@"最近" atIndex:0];
    }

    self.firstLetterArray = [array copy];
    //索引
    NSMutableArray *ar = [NSMutableArray array];
    for (NSString *str in self.firstLetterArray) {
        if (str.length > 1) {
            NSString *s =  [str substringToIndex:1];
            [ar addObject:s];
        }else{
            [ar addObject:str];
        }
    }
    self.tableview.sc_indexViewDataSource = ar.copy;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (NSString *string in self.firstLetterArray) {
        NSMutableArray *arr = [NSMutableArray array];
        
        if ([string isEqualToString:@"热门"]) {
            NSArray * reArray = @[@"北京",@"上海",@"广州",@"深圳",@"天津",@"杭州",@"南京",@"成都",@"武汉"];
            for (NSString *str in reArray) {
                LPCityModel *m = [self getModel:str from:modelCityArray];
                [arr addObject:m];
                [dic setObject:arr forKey:string];
            }
        }
        if ([string isEqualToString:@"最近"]) {
            for (NSString *str in self.recentlyArray) {
                if ([str isEqualToString:@"全国"]) {
                    LPCityModel *m = [[LPCityModel alloc]init];
                    m.c_name = @"全国";
                    [arr addObject:m];
                    [dic setObject:arr forKey:string];
                }else{
                    LPCityModel *m = [self getModel:str from:modelCityArray];
                    [arr addObject:m];
                    [dic setObject:arr forKey:string];
                }
                
            }
        }
        
        
        for (LPCityModel *model in modelCityArray) {
            if ([string isEqualToString:model.c_firstLetter]) {
                [arr addObject:model];
            }
            [dic setObject:arr forKey:string];
        }
    }
    
    self.listDic = dic;

    [self.tableview reloadData];
}

-(LPCityModel *)getModel:(NSString *)string from:(NSArray *)modelCityArray{
    for (LPCityModel *model in modelCityArray) {
        if ([model.c_name isEqualToString:string]) {
            return model;
            break;
        }
    }
    return nil;
}

#pragma mark - TableViewDelegate & Datasource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (self.tableview == tableView) {
//        return self.pArr.count;
//    }else{
//        AddressProvince * p     = self.pArr[self.selectPRow];
//        return p.cities.count;
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableview == tableView) {
        return self.pArr.count;
    }else{
        AddressProvince * p     = self.pArr[self.selectPRow];
        return p.cities.count;
    }
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.firstLetterArray[section];
//}

//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.firstLetterArray;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isSearch) {
//        return 44;
//    }
//    if (indexPath.section == 0 || indexPath.section == 1) {
//        NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
//        CGFloat h = 30 * ceilf(array.count/3.0) + 10 * (ceilf(array.count/3.0) -1) + 40;
//        return h;
//    }else{
//        return 44;
//    }
     return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isSearch) {
//        static NSString *rid=@"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//        if(cell == nil){
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
//        }
//        NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
//        cell.textLabel.text = array[indexPath.row].c_name;
//        return cell;
//    }
//    if (indexPath.section == 0 || indexPath.section == 1) {
//        LPCityCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCityCellID];
//        NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
//        cell.array = array;
//        cell.block = ^(LPCityModel *model) {
//            [self saveRecently:model];
//        };
//        return cell;
//
//    }else{
//        static NSString *rid=@"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//        if(cell == nil){
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
//        }
//        NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
//        cell.textLabel.text = array[indexPath.row].c_name;
//        return cell;
//    }
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
        UIView *LineV = [[UIView alloc] init];
        [cell.contentView addSubview:LineV];
        [LineV mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(1);
        }];
        LineV.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
//    NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
    if (self.tableview == tableView) {
        AddressProvince * p     = self.pArr[indexPath.row];
        cell.textLabel.text = p.name;
        if (self.selectPRow == indexPath.row) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }else{
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        }
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
        AddressProvince * p     = self.pArr[self.selectPRow];
        cell.textLabel.text = p.cities[indexPath.row];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
//    LPCityModel *model = array[indexPath.row];
//    [self saveRecently:model];
    if (self.tableview == tableView) {
        self.selectPRow = indexPath.row;
        [self.Subtableview reloadData];
        [self.tableview reloadData];
    }else if (self.Subtableview == tableView){
        LPCityModel *model = [[LPCityModel alloc] init];
        AddressProvince * p     = self.pArr[self.selectPRow];
        model.c_name = p.cities[indexPath.row];
//        [self saveRecently:model];
        [self pop:model];

    }
}

-(void)saveRecently:(LPCityModel *)model{
    NSMutableArray *mu = [NSMutableArray arrayWithArray:self.recentlyArray];
    if ([mu containsObject:model.c_name]) {
        [mu removeObject:model.c_name];
    }
    if ([model.c_name isEqualToString:@"全国"]) {
        [mu insertObject:model.c_name atIndex:0];
    }else{
        [mu insertObject:model.c_name atIndex:1];
    }
    NSArray *array = @[];
    if (mu.count > 6) {
        array = [mu subarrayWithRange:NSMakeRange(0, 6)];
    }else{
        array = [mu copy];
    }
    kUserDefaultsSave(array, CityRecently);
    [self pop:model];
}

-(void)pop:(LPCityModel *)model{
    if ([self.delegate respondsToSelector:@selector(selectCity:)]) {
        [self.delegate selectCity:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPCityCellID bundle:nil] forCellReuseIdentifier:LPCityCellID];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _tableview.showsVerticalScrollIndicator = NO;

//        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
//        configuration.indexItemSelectedBackgroundColor = [UIColor baseColor];
//        configuration.indicatorTextFont = [UIFont systemFontOfSize:58];
//        _tableview.sc_indexViewConfiguration = configuration;
        
    }
    return _tableview;
}

- (UITableView *)Subtableview{
    if (!_Subtableview) {
        _Subtableview = [[UITableView alloc]init];
        _Subtableview.delegate = self;
        _Subtableview.dataSource = self;
        _Subtableview.tableFooterView = [[UIView alloc]init];
        _Subtableview.rowHeight = UITableViewAutomaticDimension;
        _Subtableview.estimatedRowHeight = 100;
        _Subtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Subtableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_Subtableview registerNib:[UINib nibWithNibName:LPCityCellID bundle:nil] forCellReuseIdentifier:LPCityCellID];
        _Subtableview.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _Subtableview.showsVerticalScrollIndicator = NO;

//        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
//        configuration.indexItemSelectedBackgroundColor = [UIColor baseColor];
//        configuration.indicatorTextFont = [UIFont systemFontOfSize:58];
//        _tableview.sc_indexViewConfiguration = configuration;
        
    }
    return _Subtableview;
}


-(LPCityDataManager *)manager{
    if (!_manager) {
        _manager = [LPCityDataManager shareInstance];
        [_manager areaSqliteDBData];
    }
    return _manager;
}



#pragma mark - 解析json

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
