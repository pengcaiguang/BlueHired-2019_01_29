//
//  LPSortAlertView.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSortAlertView.h"


static NSInteger rowHeight = 44;

@interface LPSortAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) NSArray *titleArray;

@end

@implementation LPSortAlertView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.titleArray = @[@"综合工资最高",@"报名人数最多",@"企业评分最高",@"工价最高",@"可借支"];
        self.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.tableview];
    }
    return self;
}
-(void)setTouchButton:(UIButton *)touchButton{
    _touchButton = touchButton;
}

-(void)setHidden:(BOOL)hidden{
    self.bgView.hidden = hidden;
    self.tableview.hidden = hidden;
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.touchButton convertRect: self.touchButton.bounds toView:window];
    self.tableview.frame = CGRectMake(0, CGRectGetMaxY(rect)+10, SCREEN_WIDTH, rowHeight*self.titleArray.count);

}

-(void)hidden{
    self.hidden = YES;
    self.bgView.hidden = YES;
    self.tableview.hidden = YES;
    self.touchButton.selected = NO;
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(touchTableView:)]) {
        [self.delegate touchTableView:indexPath.row];
        [self hidden];
    }
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
    }
    return _tableview;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        _bgView.alpha = 0.1;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
@end
