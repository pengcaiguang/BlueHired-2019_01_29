//
//  LPSelectCityVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSelectCityVC.h"
#import "LPCityDataManager.h"
#import "LPCityModel.h"
#import "SCIndexViewConfiguration.h"
#import "UITableView+SCIndexView.h"


@interface LPSelectCityVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) NSArray *firstLetterArray;
@property(nonatomic,strong) NSDictionary *listDic;
@property(nonatomic,strong) NSArray <LPCityModel *>*listArray;

@end

@implementation LPSelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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
    self.firstLetterArray = [set allObjects];
    
    self.tableview.sc_indexViewDataSource = self.firstLetterArray.copy;

    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (NSString *string in self.firstLetterArray) {
        NSMutableArray *arr = [NSMutableArray array];
        for (LPCityModel *model in modelCityArray) {
            if ([string isEqualToString:model.c_firstLetter]) {
                [arr addObject:model];
            }
            [dic setObject:arr forKey:string];
        }
    }
    
    self.listDic = dic;
    
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"c_pinyin" ascending:YES];
    //    NSArray *a = [modelCityArray copy];
    //    NSArray *tempArray = [a sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //
    //    self.listArray = tempArray;
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.firstLetterArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.listDic[self.firstLetterArray[section]];
    return array.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.firstLetterArray[section];
}

//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.firstLetterArray;
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    
    NSArray <LPCityModel *>*array = self.listDic[self.firstLetterArray[indexPath.section]];
    cell.textLabel.text = array[indexPath.row].c_name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
        configuration.indexItemSelectedBackgroundColor = [UIColor baseColor];
        _tableview.sc_indexViewConfiguration = configuration;
//        _tableview.sc_translucentForTableViewInNavigationBar = self.translucent;
        
        
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
