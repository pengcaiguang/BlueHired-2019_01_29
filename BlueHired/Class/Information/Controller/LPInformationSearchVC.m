//
//  LPInformationSearchVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationSearchVC.h"
#import "LPSearchBar.h"

@interface LPInformationSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) NSArray *textArray;

@end

@implementation LPInformationSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSearchView];
    [self setSearchButton];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 - 2 * 15, 44)];
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
    }
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
    [button setBackgroundImage:[UIImage imageNamed:@"search_btn_bgView"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(view);
    }];
    label.text = @"历史搜索";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"#434343"];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.textArray.count <= 0) {
        UIView *view = [[UIView alloc]init];
        return view;
    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]init];
    [view addSubview:button];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(120);
    }];
    [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setImage:[UIImage imageNamed:@"delete_search"] forState:UIControlStateNormal];
    [button setTitle:@"清空历史记录" forState:UIControlStateNormal];
    
    
    
    return view;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
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
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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