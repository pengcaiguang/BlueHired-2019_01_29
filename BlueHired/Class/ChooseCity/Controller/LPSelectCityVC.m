//
//  LPSelectCityVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSelectCityVC.h"
#import "LPCityDataManager.h"
#import "SCIndexViewConfiguration.h"
#import "UITableView+SCIndexView.h"
#import "LPCityCell.h"

static NSString *LPCityCellID = @"LPCityCell";

static NSString *CityRecently = @"CityRecently";

@interface LPSelectCityVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) NSArray *firstLetterArray;
@property(nonatomic,strong) NSDictionary *listDic;

@property(nonatomic,strong) NSArray *recentlyArray;

@end

@implementation LPSelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.recentlyArray = (NSArray *)kUserDefaultsValue(CityRecently);
    if (self.recentlyArray.count == 0) {
        NSMutableArray *mu = [NSMutableArray array];
        [mu addObject:@"全国"];
        self.recentlyArray = [mu copy];
    }
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self setData];
    
}

-(void)setData{
    LPCityDataManager *manager = [LPCityDataManager shareInstance];
    [manager areaSqliteDBData];
    
    NSArray *cityArray = [manager getCity];
    [self sortArray:cityArray];
}

-(void)sortArray:(NSArray *)cityArray{
    NSLog(@"%@",cityArray);
    
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
    [array insertObject:@"热门" atIndex:0];
    [array insertObject:@"最近" atIndex:0];

    self.firstLetterArray = [array copy];
    //索引
    self.tableview.sc_indexViewDataSource = self.firstLetterArray.copy;
    
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.firstLetterArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    NSArray *array = self.listDic[self.firstLetterArray[section]];
    return array.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.firstLetterArray[section];
}

//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.firstLetterArray;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
        CGFloat h = 30 * ceilf(array.count/3.0) + 10 * (ceilf(array.count/3.0) -1) + 40;
        return h;
    }else{
        return 44;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        LPCityCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCityCellID];
        NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
        cell.array = array;
        cell.block = ^(LPCityModel *model) {
            [self saveRecently:model];
        };
        return cell;
            
    }else{
        static NSString *rid=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
        }
        NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
        cell.textLabel.text = array[indexPath.row].c_name;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
    LPCityModel *model = array[indexPath.row];
    [self saveRecently:model];
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPCityCellID bundle:nil] forCellReuseIdentifier:LPCityCellID];
        
        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
        configuration.indexItemSelectedBackgroundColor = [UIColor baseColor];
        _tableview.sc_indexViewConfiguration = configuration;
        
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
