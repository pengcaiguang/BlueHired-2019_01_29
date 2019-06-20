//
//  LPMainSortAlertView.m
//  BlueHired
//
//  Created by iMac on 2019/5/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMainSortAlertView.h"

static NSInteger rowHeight = 40;


@interface LPMainSortAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *bgView;

//@property(nonatomic,copy) NSString *selectTitle;

@end

@implementation LPMainSortAlertView

-(instancetype)init{
    self = [super init];
    if (self) {
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
    UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.touchButton convertRect: self.touchButton.bounds toView:window];
    self.tableview.lx_y = CGRectGetMaxY(rect);
    self.bgView.lx_y = self.tableview.lx_bottom;
    [self.tableview reloadData];

    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableview.frame = CGRectMake(0, self.tableview.lx_y, SCREEN_WIDTH, 0 );
            self.bgView.frame = CGRectMake(0,self.tableview.lx_bottom , SCREEN_WIDTH, SCREEN_HEIGHT);
            self.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            self.bgView.hidden = hidden;
            self.tableview.hidden = hidden;
//            [self.tableview reloadData];
        }];
    }else{
        self.bgView.hidden = hidden;
        self.tableview.hidden = hidden;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableview.frame = CGRectMake(0, self.tableview.lx_y, SCREEN_WIDTH, rowHeight*(self.titleArray.count>6?6:self.titleArray.count));
            self.bgView.frame = CGRectMake(0,self.tableview.lx_bottom , SCREEN_WIDTH, SCREEN_HEIGHT);
            self.bgView.alpha = 0.5;
        } completion:^(BOOL finished) {
//            [self.tableview reloadData];
        }];
    }

}

- (void)close{
    [self hidden];
}

-(void)hidden{
    self.hidden = YES;
//    self.bgView.hidden = YES;
//    self.tableview.hidden = YES;
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
        UIImageView *imageViews = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH - 40, 15, 16, 13)];
        imageViews.image = [UIImage imageNamed:@"select_slices"];
        imageViews.contentMode = UIViewContentModeScaleAspectFit;
        imageViews.tag = 100;
        [cell.contentView addSubview:imageViews];
    }
    UIImageView *imageViews = [cell.contentView viewWithTag:100];
    NSLog(@"第 %ld 行",indexPath.row);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    if (indexPath.row == self.selectTitle) {
        cell.textLabel.textColor = [UIColor baseColor];
        imageViews.hidden = NO;
    }else{
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        imageViews.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectTitle = indexPath.row;
    [self.tableview reloadData];
    
    if ([self.delegate respondsToSelector:@selector(touchTableView:)]) {
        [self.delegate touchTableView:indexPath.row];
        [self hidden];
    }
}


#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.layer.borderWidth = 0.5;
        _tableview.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
    }
    return _tableview;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}



@end
