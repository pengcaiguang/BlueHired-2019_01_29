//
//  LXCalendarView.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalendarView.h"
#import "LXCalendarHearder.h"
#import "LXCalendarWeekView.h"
#import "LXCalenderCell.h"
#import "LXCalendarMonthModel.h"
#import "NSDate+GFCalendar.h"
#import "LXCalendarDayModel.h"
#import "WHActivityView.h"

@interface LXCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)LXCalendarHearder *calendarHeader; //头部
@property(nonatomic,strong)LXCalendarWeekView *calendarWeekView;//周
@property(nonatomic,strong)UICollectionView *collectionView;//日历
@property(nonatomic,strong)NSMutableArray *monthdataA;//当月的模型集合
@property(nonatomic,strong)NSDate *currentMonthDate;//当月的日期
@property(nonatomic,strong)UISwipeGestureRecognizer *leftSwipe;//左滑手势
@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipe;//右滑手势
@property(nonatomic,strong)LXCalendarDayModel *selectModel;
@property(nonatomic,assign)CGFloat ItemHeight;
@property(nonatomic,strong)NSDictionary *dic;


@end
@implementation LXCalendarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentMonthDate = [NSDate date];
        [self setup];        
    }
    return self;
}
-(void)dealData:(NSDictionary *) dic{
    
    
    [self responData:dic];
}
-(void)setup{
    [self addSubview:self.calendarHeader];
    
    WEAK_SELF()
    self.calendarHeader.leftClickBlock = ^{
        [weakSelf rightSlide];
    };
    
    self.calendarHeader.rightClickBlock = ^{
        [weakSelf leftSlide];

    };
    [self addSubview:self.calendarWeekView];
    
    [self addSubview:self.collectionView];
    
    self.lx_height = self.collectionView.lx_bottom;
//
//    UIView *colorTypeView = [[UIView alloc] init];
//    [self addSubview:colorTypeView];
//    [colorTypeView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(self.collectionView.mas_bottom);
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(self.lx_width);
//        make.height.mas_equalTo(51);
//    }];
//
//    UIView *centreColorView = [[UIView alloc] init];
//    [colorTypeView addSubview:centreColorView];
//    [centreColorView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(colorTypeView);
//        make.centerX.equalTo(colorTypeView).offset(-15);
//        make.width.mas_equalTo(17);
//        make.height.mas_equalTo(17);
//    }];
//    centreColorView.backgroundColor = [UIColor colorWithHexString:@"#0CC2DE"];
//
//    UILabel *centreLabel = [[UILabel alloc] init];
//    [colorTypeView addSubview:centreLabel];
//    [centreLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(colorTypeView);
//        make.left.equalTo(centreColorView.mas_right).offset(4);
//    }];
//    centreLabel.textColor = [UIColor colorWithHexString:@"#929292"];
//    centreLabel.font = [UIFont systemFontOfSize:13];
//    centreLabel.text = @"请假";
//
//    UIView *leftColorView = [[UIView alloc] init];
//    [colorTypeView addSubview:leftColorView];
//    [leftColorView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(colorTypeView);
//        make.left.mas_equalTo(63);
//        make.width.mas_equalTo(17);
//        make.height.mas_equalTo(17);
//    }];
//    leftColorView.backgroundColor = [UIColor colorWithHexString:@"#3CAFFF"];
//
//    UILabel *leftLabel = [[UILabel alloc] init];
//    [colorTypeView addSubview:leftLabel];
//    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(colorTypeView);
//        make.left.equalTo(leftColorView.mas_right).offset(4);
//    }];
//    leftLabel.textColor = [UIColor colorWithHexString:@"#929292"];
//    leftLabel.font = [UIFont systemFontOfSize:13];
//    leftLabel.text = @"加班";
//
//
//    UILabel *rightLabel = [[UILabel alloc] init];
//    [colorTypeView addSubview:rightLabel];
//    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(colorTypeView);
//        make.right.mas_equalTo(-63);
//    }];
//    rightLabel.textColor = [UIColor colorWithHexString:@"#929292"];
//    rightLabel.font = [UIFont systemFontOfSize:13];
//    rightLabel.text = @"消费";
//
//    UIView *rightColorView = [[UIView alloc] init];
//    [colorTypeView addSubview:rightColorView];
//    [rightColorView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(colorTypeView);
//        make.right.equalTo(rightLabel.mas_left).offset(-4);
//        make.width.mas_equalTo(17);
//        make.height.mas_equalTo(17);
//    }];
//    rightColorView.backgroundColor = [UIColor colorWithHexString:@"#FF9898"];
    
 
    
    
    //添加左滑右滑手势
   self.leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
   self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.collectionView addGestureRecognizer:self.leftSwipe];
    
    self.rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:self.rightSwipe];
}
#pragma mark --左滑手势--
-(void)leftSwipe:(UISwipeGestureRecognizer *)swipe{
    
    [self leftSlide];
}
#pragma mark --左滑处理--
-(void)leftSlide{
    self.currentMonthDate = [self.currentMonthDate nextMonthDate];
    
    [self performAnimations:kCATransitionFromRight];
//    [self responData];
}
#pragma mark --右滑处理--
-(void)rightSlide{
    
    self.currentMonthDate = [self.currentMonthDate previousMonthDate];
    [self performAnimations:kCATransitionFromLeft];
    
//    [self responData];
}
#pragma mark --右滑手势--
-(void)rightSwipe:(UISwipeGestureRecognizer *)swipe{
   
    [self rightSlide];
}
#pragma mark--动画处理--
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.5;
    [catransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    catransition.type = kCATransitionPush; //choose your animation
    catransition.subtype = transition;
    [self.collectionView.layer addAnimation:catransition forKey:nil];
}

#pragma mark--数据以及更新处理--
-(void)responData:(NSDictionary *) dic{
    self.dic = dic;
    [self.monthdataA removeAllObjects];
    
//    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];
    
//    NSDate *nextMonthDate = [self.currentMonthDate  nextMonthDate];
    
    
//    LXCalendarMonthModel *lastMonthModel = [[LXCalendarMonthModel alloc]initWithDate:previousMonthDate];
    
//     LXCalendarMonthModel *nextMonthModel = [[LXCalendarMonthModel alloc]initWithDate:nextMonthDate];
    if (self.WorkHourType == 3) {
        self.calendarHeader.dateStr = [NSString stringWithFormat:@"本月总工时%.2f小时",[dic[@"data"][@"hours"] floatValue]];
        
        NSString *monthSalary = [NSString stringWithFormat:@"%.2f",[dic[@"data"][@"monthSalary"] floatValue]];
        
        self.calendarHeader.WorkMoney.text = [NSString stringWithFormat:@"本月工资%@元",monthSalary];
        self.calendarHeader.BasicMoney.text = @"";
        self.calendarHeader.LayoutConstraintTop.constant = 22;
        NSString *string = self.calendarHeader.WorkMoney.text;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        NSUInteger length = [string length];
        //设置字体
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, length)];//设置所有的字体
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:[string rangeOfString:monthSalary]];//设置Text这四个字母的字体为粗体
        self.calendarHeader.WorkMoney.attributedText = attrString;
     
    }else if (self.WorkHourType == 4){
        self.calendarHeader.dateStr = [NSString stringWithFormat:@"本月总件数%ld件",[dic[@"data"][@"productNum"] integerValue]];
        
        NSString *Moneys = [NSString stringWithFormat:@"%.2f",[dic[@"data"][@"moneys"] floatValue]];
        NSString *monthSalary = [NSString stringWithFormat:@"%.2f",[dic[@"data"][@"monthSalary"] floatValue]];
        
        self.calendarHeader.WorkMoney.text = [NSString stringWithFormat:@"计件工资%@元",Moneys];
        self.calendarHeader.BasicMoney.text = [NSString stringWithFormat:@"基本工资%@元",monthSalary];
        self.calendarHeader.LayoutConstraintTop.constant = 32;
        
        NSString *string = self.calendarHeader.WorkMoney.text;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        NSUInteger length = [string length];
        //设置字体
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, length)];//设置所有的字体
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:[string rangeOfString:Moneys]];//设置Text这四个字母的字体为粗体
        self.calendarHeader.WorkMoney.attributedText = attrString;
        
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:self.calendarHeader.BasicMoney.text];
        //设置字体
        [attrString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, self.calendarHeader.BasicMoney.text.length)];//设置所有的字体
        [attrString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:[self.calendarHeader.BasicMoney.text rangeOfString:monthSalary]];//设置Text这四个字母的字体为粗体
        self.calendarHeader.BasicMoney.attributedText = attrString2;
    }else{
        self.calendarHeader.dateStr = [NSString stringWithFormat:@"共加班%ld天|%.2f小时",[dic[@"data"][@"overtimeDay"] integerValue],[dic[@"data"][@"hours"] floatValue]];
        NSString *Moneys = [NSString stringWithFormat:@"%.2f",[dic[@"data"][@"moneys"] floatValue]];
        NSString *monthSalary = [NSString stringWithFormat:@"%.2f",[ dic[@"data"][@"monthSalary"] floatValue]];
        self.calendarHeader.WorkMoney.text = [NSString stringWithFormat:@"加班工资%@元",Moneys];
        self.calendarHeader.BasicMoney.text = [NSString stringWithFormat:@"基本工资%@元",monthSalary];
        self.calendarHeader.LayoutConstraintTop.constant = 32;
        NSString *string = self.calendarHeader.WorkMoney.text;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        NSUInteger length = [string length];
        //设置字体
         [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, length)];//设置所有的字体
         [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:[string rangeOfString:Moneys]];//设置Text这四个字母的字体为粗体
        self.calendarHeader.WorkMoney.attributedText = attrString;
   
        NSString *string2 = self.calendarHeader.BasicMoney.text;

        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:string2];
        //设置字体
        [attrString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, string2.length)];//设置所有的字体
        [attrString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:[string2 rangeOfString:monthSalary]];//设置Text这四个字母的字体为粗体
        self.calendarHeader.BasicMoney.attributedText = attrString2;
        
    }

    
    NSArray *KqArr = [self.KQDateString componentsSeparatedByString:@"#"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";//日期格式化类
    
    NSDate *startDate = [formatter dateFromString:KqArr[0]];
    NSDate *endDate = [formatter dateFromString:KqArr[1]];

    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc]initWithDate:startDate];
    LXCalendarMonthModel *nextMonthModel = [[LXCalendarMonthModel alloc]initWithDate:endDate];

//    NSCalendar *calendar = [NSCalendar currentCalendar];
    //把NSCalendarUnitMonth换成NSCalendarUnitYear就能获取当前年有多少天
//    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:startDate];
    

    
    NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar2 setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;

    NSDateComponents *theComponents = [calendar2 components:calendarUnit fromDate:startDate];
    NSInteger firstWeekday = theComponents.weekday-1;       //周几
    
    NSDateComponents *NexttheComponents = [calendar2 components:calendarUnit fromDate:endDate];
    NSInteger NextfirstWeekday =7- NexttheComponents.weekday;       //周几
    
    NSInteger totalDays = monthModel.totalDays;             //当月总天数
    
    NSInteger DayCount =  firstWeekday + totalDays - monthModel.Day +nextMonthModel.Day+1 +NextfirstWeekday;

    if (monthModel.month== nextMonthModel.month) {              //考勤周期是一个月
        DayCount = monthModel.firstWeekday+monthModel.totalDays + NextfirstWeekday;
    }
    
    _collectionView.lx_height = DayCount/7*(self.ItemHeight+1);
    
    
    for (int i = 0; i <DayCount; i++) {
        LXCalendarDayModel *model =[[LXCalendarDayModel alloc]init];
        [self configDayModel:model];
        
        if (i<firstWeekday) {
            model.isLastMonth = YES;
        }
        
        //当月的日期
        if (i >= firstWeekday && i < (firstWeekday + monthModel.totalDays - monthModel.Day+1)) {
            model.day = i + monthModel.Day  -firstWeekday;
            model.isCurrentMonth = YES;
            model.month = monthModel.month;
            model.year = monthModel.year;


            NSString *dateStr = [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",(long)model.year,(long)model.month,(long)model.day];

                if (self.WorkHourType == 2) {
                    if ([dic[@"data"][dateStr][@"overtimeHours"] floatValue] == 0.00) {
                        model.overtimeHours = @"";
                    }else{
                        model.overtimeHours = [NSString stringWithFormat:@"工 %.2fh",[dic[@"data"][dateStr][@"overtimeHours"] floatValue]];
                    }
                }else if (self.WorkHourType == 3){
                    if ([dic[@"data"][dateStr][@"overtimeHours"] floatValue] == 0.00) {
                        model.overtimeHours = @"";
                    }else{
                        model.overtimeHours = [NSString stringWithFormat:@"工 %.2fh",[dic[@"data"][dateStr][@"overtimeHours"] floatValue]];
                    }
                }else if (self.WorkHourType == 4){
                    if ([dic[@"data"][dateStr][@"productNum"] floatValue] == 0.00) {
                        model.overtimeHours = @"";
                    }else{
                        model.overtimeHours = [NSString stringWithFormat:@"计¥%ld",[dic[@"data"][dateStr][@"productNum"] integerValue]];
                    }
                }else{
                    if ([dic[@"data"][dateStr][@"overtimeHours"] floatValue] == 0.00) {
                        model.overtimeHours = @"";
                    }else{
                        model.overtimeHours = [NSString stringWithFormat:@"加 %.2fh",[dic[@"data"][dateStr][@"overtimeHours"] floatValue]];
                    }
                }
            
            
            if ([dic[@"data"][dateStr][@"leaveHours"] floatValue] == 0.00) {
                model.leaveHours = @"";
            }else{
                model.leaveHours = [NSString stringWithFormat:@"假 %.2fh",[dic[@"data"][dateStr][@"leaveHours"] floatValue]];
            }
            
            if ([dic[@"data"][dateStr][@"accountMoney"] floatValue] == 0.00) {
                model.accountMoney = @"";
            }else{
                model.accountMoney = [NSString stringWithFormat:@"花¥%ld",[dic[@"data"][dateStr][@"accountMoney"] integerValue]];
            }
            model.remark = dic[@"data"][dateStr][@"remark"];
            model.shift = dic[@"data"][dateStr][@"shift"];
            
        }
         //下月的日期
        if (i >= (firstWeekday + monthModel.totalDays - monthModel.Day+1) && i <DayCount-NextfirstWeekday) {
            model.day = i -(firstWeekday + monthModel.totalDays - monthModel.Day);
            model.month = nextMonthModel.month;
            model.year = nextMonthModel.year;
            model.isNextMonth = YES;
            model.isShowLastAndNextDate = YES;
            
            NSString *dateStr = [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",(long)model.year,(long)model.month,(long)model.day];
            
            if (self.WorkHourType == 2) {
                if ([dic[@"data"][dateStr][@"overtimeHours"] floatValue] == 0.00) {
                    model.overtimeHours = @"";
                }else{
                    model.overtimeHours = [NSString stringWithFormat:@"工 %.2fh",[dic[@"data"][dateStr][@"overtimeHours"] floatValue]];
                }
            }else if (self.WorkHourType == 3){
                if ([dic[@"data"][dateStr][@"overtimeHours"] floatValue] == 0.00) {
                    model.overtimeHours = @"";
                }else{
                    model.overtimeHours = [NSString stringWithFormat:@"工 %.2fh",[dic[@"data"][dateStr][@"overtimeHours"] floatValue]];
                }
            }else if (self.WorkHourType == 4){
                if ([dic[@"data"][dateStr][@"productNum"] floatValue] == 0.00) {
                    model.overtimeHours = @"";
                }else{
                    model.overtimeHours = [NSString stringWithFormat:@"计¥%ld",[dic[@"data"][dateStr][@"productNum"] integerValue]];
                }
            }else{
                if ([dic[@"data"][dateStr][@"overtimeHours"] floatValue] == 0.00) {
                    model.overtimeHours = @"";
                }else{
                    model.overtimeHours = [NSString stringWithFormat:@"加 %.2fh",[dic[@"data"][dateStr][@"overtimeHours"] floatValue]];
                }
            }
            
            
            if ([dic[@"data"][dateStr][@"leaveHours"] floatValue] == 0.00) {
                model.leaveHours = @"";
            }else{
                model.leaveHours = [NSString stringWithFormat:@"假 %.2fh",[dic[@"data"][dateStr][@"leaveHours"] floatValue]];
            }
            
            if ([dic[@"data"][dateStr][@"accountMoney"] floatValue] == 0.00) {
                model.accountMoney = @"";
            }else{
                model.accountMoney = [NSString stringWithFormat:@"花¥%ld",[dic[@"data"][dateStr][@"accountMoney"] integerValue]];
            }
            model.remark = dic[@"data"][dateStr][@"remark"];
            model.shift = dic[@"data"][dateStr][@"shift"];
        }
        
        if (i >=DayCount-NextfirstWeekday) {
            model.isLastMonth = YES;
        }
      
        
        [self.monthdataA addObject:model];
    }
    

//    NSInteger firstWeekday = monthModel.firstWeekday;
    
//    NSInteger totalDays = monthModel.totalDays;
    
//    dic.count
    
//    for (int i = 0; i <42; i++) {
//
//        LXCalendarDayModel *model =[[LXCalendarDayModel alloc]init];
//
//        //配置外面属性
//        [self configDayModel:model];
//
//        model.firstWeekday = firstWeekday;
//        model.totalDays = totalDays;
//
//        model.month = monthModel.month;
//
//        model.year = monthModel.year;
//
//
//        //上个月的日期
//        if (i < firstWeekday) {
//            model.day = lastMonthModel.totalDays - (firstWeekday - i) + 1;
//            model.isLastMonth = YES;
//        }
//
//        //当月的日期
//        if (i >= firstWeekday && i < (firstWeekday + totalDays)) {
//
//            model.day = i -firstWeekday +1;
//            model.isCurrentMonth = YES;
//
//            //标识是今天
//            if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {
//                if (i == [[NSDate date] dateDay] + firstWeekday - 1) {
//
//                    model.isToday = YES;
//
//                }
//            }
//
//        }
//         //下月的日期
//        if (i >= (firstWeekday + monthModel.totalDays)) {
//
//            model.day = i -firstWeekday - monthModel.totalDays +1;
//            model.isNextMonth = YES;
//
//        }
//
//        [self.monthdataA addObject:model];
//
//    }
    
    
//    [self.monthdataA enumerateObjectsUsingBlock:^(LXCalendarDayModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if ((obj.year == self.selectModel.year) && (obj.month == self.selectModel.month) && (obj.day == self.selectModel.day)) {
//            obj.isSelected = YES;
//        }
//    }];
    [self.collectionView reloadData];
    
}
-(void)configDayModel:(LXCalendarDayModel *)model{
    

    //配置外面属性
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.currentMonthTitleColor = self.currentMonthTitleColor;
    
    model.lastMonthTitleColor = self.lastMonthTitleColor;
    
    model.nextMonthTitleColor = self.nextMonthTitleColor;
    
    model.selectBackColor = self.selectBackColor;
    
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.todayTitleColor = self.todayTitleColor;
    
    model.isShowLastAndNextDate = self.isShowLastAndNextDate;

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthdataA.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"cell";
    LXCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    if (!cell) {
        cell =[[LXCalenderCell alloc]init];
        
    }
    
    
    cell.model = self.monthdataA[indexPath.row];
    
    
    cell.backgroundColor =[UIColor whiteColor];
    

    
    
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    LXCalendarDayModel *model = self.monthdataA[indexPath.row];
//    model.isSelected = YES;
//
//    //选中的day
//    self.selectModel = model;
//    [self.monthdataA enumerateObjectsUsingBlock:^(LXCalendarDayModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        if (obj != model) {
//            obj.isSelected = NO;
//        }
//    }];
//
    if (self.selectBlock && model.year>0) {
        self.selectBlock(model.year, model.month, model.day);
    }
//    [collectionView reloadData];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
 
    self.calendarHeader.frame = CGRectMake(0, 0, self.lx_width, 59);
}
#pragma mark---懒加载
-(LXCalendarHearder *)calendarHeader{
    if (!_calendarHeader) {
        _calendarHeader =[LXCalendarHearder showView];
        _calendarHeader.frame = CGRectMake(0, 0, self.lx_width, 59);
//        _calendarHeader.backgroundColor =[UIColor whiteColor];
    }
    return _calendarHeader;
}
-(LXCalendarWeekView *)calendarWeekView{
    if (!_calendarWeekView) {
        _calendarWeekView =[[LXCalendarWeekView alloc]initWithFrame:CGRectMake(13, self.calendarHeader.lx_bottom, self.lx_width-26, 37)];
        _calendarWeekView.weekTitles = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    return _calendarWeekView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        //325*403
        flow.minimumInteritemSpacing = 1;
        flow.minimumLineSpacing = 1;
        flow.sectionInset =UIEdgeInsetsMake(0 , 0, 0, 0);
        CGFloat ItemHeight = Screen_Width == 320.0 ?59.0:59.0/375*Screen_Width;
        self.ItemHeight = ItemHeight;
        flow.itemSize = CGSizeMake(floor((self.lx_width-6-26)/7), ItemHeight);
         _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(13, self.calendarWeekView.lx_bottom, self.lx_width-26, 6 * (ItemHeight+1)) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = YES;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _collectionView.layer.borderWidth = 1;
        _collectionView.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
        UINib *nib = [UINib nibWithNibName:@"LXCalenderCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
        
//        _collectionView.layer.co
        
    }
    return _collectionView;
}
-(NSMutableArray *)monthdataA{
    if (!_monthdataA) {
        _monthdataA =[NSMutableArray array];
    }
    return _monthdataA;
}

/*
 * 当前月的title颜色
 */
-(void)setCurrentMonthTitleColor:(UIColor *)currentMonthTitleColor{
    _currentMonthTitleColor = currentMonthTitleColor;
}
/*
 * 上月的title颜色
 */
-(void)setLastMonthTitleColor:(UIColor *)lastMonthTitleColor{
    _lastMonthTitleColor = lastMonthTitleColor;
}
/*
 * 下月的title颜色
 */
-(void)setNextMonthTitleColor:(UIColor *)nextMonthTitleColor{
    _nextMonthTitleColor = nextMonthTitleColor;
}

/*
 * 选中的背景颜色
 */
-(void)setSelectBackColor:(UIColor *)selectBackColor{
    _selectBackColor = selectBackColor;
}

/*
 * 选中的是否动画效果
 */

-(void)setIsHaveAnimation:(BOOL)isHaveAnimation{
    
    _isHaveAnimation  = isHaveAnimation;
}

/*
 * 是否禁止手势滚动
 */
-(void)setIsCanScroll:(BOOL)isCanScroll{
    _isCanScroll = isCanScroll;
    
    self.leftSwipe.enabled = self.rightSwipe.enabled = isCanScroll;
}

/*
 * 是否显示上月，下月的按钮
 */

-(void)setIsShowLastAndNextBtn:(BOOL)isShowLastAndNextBtn{
    _isShowLastAndNextBtn  = isShowLastAndNextBtn;
    self.calendarHeader.isShowLeftAndRightBtn = isShowLastAndNextBtn;
}


/*
 * 是否显示上月，下月的的数据
 */
-(void)setIsShowLastAndNextDate:(BOOL)isShowLastAndNextDate{
    _isShowLastAndNextDate =  isShowLastAndNextDate;
}
/*
 * 今日的title颜色
 */

-(void)setTodayTitleColor:(UIColor *)todayTitleColor{
    _todayTitleColor = todayTitleColor;
}

-(void)SetscreenshotView{
    
    UIView *screenshotView = [[UIView alloc] init];
    screenshotView.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-40, 45)];
    [screenshotView addSubview:headView];
    headView.backgroundColor = [UIColor baseColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(14);
        make.height.with.mas_equalTo(25);
    }];
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.cornerRadius = 4;
    imageView.image = [UIImage imageNamed:@"logo_Information"];
    
    UILabel *Label = [[UILabel alloc] init];
    [headView addSubview:Label];
    [Label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(headView);
        make.centerY.equalTo(headView);
    }];
    Label.textColor = [UIColor whiteColor];
//    Label.text = @"2019.01.01—2019.02.02";
    Label.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    Label.text = [Label.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
    
    UIImageView *WeekImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, Screen_Width-40, 37)];
    WeekImage.image = [self screenShotView:self.calendarWeekView];
    [screenshotView addSubview:WeekImage];
    
    UIImageView *collectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45+37, Screen_Width-40, self.collectionView.lx_height)];
    collectionImage.image = [self screenShotView:self.collectionView];
    [screenshotView addSubview:collectionImage];

    
    UIView *footerView =[[UIView alloc] initWithFrame:CGRectMake(0, 45+self.calendarHeader.lx_height +self.collectionView.lx_height, Screen_Width-40, 121)];
    [screenshotView addSubview:footerView];
    
    
    UILabel *label2 = [[UILabel alloc] init];
    [footerView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(13);
    }];
    label2.text = @"本月工资";
    label2.font = [UIFont systemFontOfSize:14];

    UILabel *label3 = [[UILabel alloc] init];
    [footerView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(25);
        make.left.equalTo(label2.mas_right).offset(0);
    }];
    label3.textColor = [UIColor baseColor];
    label3.text = [NSString stringWithFormat:@"%.2f",[self.dic[@"data"][@"monthWage"] floatValue]];
    label3.font = [UIFont systemFontOfSize:14];

    UILabel *label4 = [[UILabel alloc] init];
    [footerView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(25);
        make.left.equalTo(label3.mas_right).offset(0);
    }];
    label4.text = @"元";
    label4.font = [UIFont systemFontOfSize:14];

    UILabel *labelDate2 = [[UILabel alloc] init];
    [footerView addSubview:labelDate2];
    [labelDate2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.left.mas_equalTo(13);
    }];
    if (self.WorkHourType == 3) {
        labelDate2.text = @"本月总工时";
    }else if (self.WorkHourType == 4){
        labelDate2.text = @"本月总件数";
    }else{
        labelDate2.text = @"本月加班时间";
    }
    labelDate2.font = [UIFont systemFontOfSize:14];

    UILabel *labelDate3 = [[UILabel alloc] init];
    [footerView addSubview:labelDate3];
    [labelDate3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.left.equalTo(labelDate2.mas_right).offset(0);
    }];
    labelDate3.textColor = [UIColor baseColor];
    labelDate3.font = [UIFont systemFontOfSize:14];

    UILabel *labelDate4 = [[UILabel alloc] init];
    [footerView addSubview:labelDate4];
    [labelDate4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.left.equalTo(labelDate3.mas_right).offset(0);
    }];
    if (self.WorkHourType == 4) {
        labelDate4.text = @"件";
//        labelDate3.text = reviseString(self.dic[@"data"][@"productNum"]);
        labelDate3.text = [NSString stringWithFormat:@"%ld",[self.dic[@"data"][@"productNum"] integerValue]];

    }else{
//        labelDate3.text = reviseString(self.dic[@"data"][@"hours"]);
        labelDate3.text = [NSString stringWithFormat:@"%.2f",[self.dic[@"data"][@"hours"] floatValue]];

        labelDate4.text = @"小时";
    }
    labelDate4.font = [UIFont systemFontOfSize:14];

    
    UIImageView *CodeiamgeView = [[UIImageView alloc] init];
    [footerView addSubview:CodeiamgeView];
    [CodeiamgeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-27);
        make.width.height.mas_equalTo(36);
    }];
    CodeiamgeView.image = [UIImage imageNamed:@"WorkHourcode_icon"];
    
    UILabel *LabelCode = [[UILabel alloc] init];
    [footerView addSubview:LabelCode];
    [LabelCode mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(CodeiamgeView.mas_bottom).offset(4);
        make.centerX.equalTo(CodeiamgeView);
    }];
    LabelCode.font = [UIFont systemFontOfSize:13];
    LabelCode.text = @"下载二维码";
    
    
    UILabel *LabelTitel = [[UILabel alloc] init];
    [footerView addSubview:LabelTitel];
    [LabelTitel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(-17);
        make.centerX.equalTo(footerView);
    }];
    LabelTitel.font = [UIFont systemFontOfSize:17];
    LabelTitel.textColor = [UIColor baseColor];
    LabelTitel.text = @"蓝聘—专注于服务蓝领人士";
    
    screenshotView.frame = CGRectMake(0, 0, Screen_Width-40, footerView.lx_bottom);
//    screenshotView.layer.cornerRadius = 4;

    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    alert.containerView = screenshotView;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];
    alert.containerView.clipsToBounds = NO;
    [self  btnClickShare:[self screenShotView:screenshotView] Title:@""];
    
}


// 对指定视图进行截图
- (UIImage *)screenShotView:(UIView *)view
{
    UIImage *imageRet = nil;
    
    if (view)
    {
        if(&UIGraphicsBeginImageContextWithOptions)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
        }
        else
        {
            UIGraphicsBeginImageContext(view.frame.size);
        }
        
        //获取图像
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        imageRet = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
    }
    
    return imageRet;
}




-(void)btnClickShare:(UIImage *)iamge Title:(NSString *)Title{
    //更多。用于分享及编辑
    for (UIView *sub in [activityView subviews]) {
        [sub removeFromSuperview];
    }
    [activityView removeFromSuperview];
    activityView=nil;
    if (!activityView)
    {
        activityView = [[WHActivityView alloc]initWithTitle:nil referView:[[UIWindow visibleViewController].view window] isNeed:YES];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        activityView.numberOfButtonPerLine = 4;
        activityView.titleLabel.text = @"请选择分享平台";
        __weak __typeof(self) weakSelf = self;
        ButtonView *bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"QQLogo"] handler:^(ButtonView *buttonView){
            [weakSelf share:1 Url:iamge    Title:Title];//QQ好友
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"QQ空间"  image:[UIImage imageNamed:@"QQSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:2 Url:iamge Title:Title];//QQ空间
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"微信"  image:[UIImage imageNamed:@"weixinLogo"] handler:^(ButtonView *buttonView){
            [weakSelf share:3 Url:iamge Title:Title];//微信
        }];
        [activityView addButtonView:bv];
        bv = [[ButtonView alloc]initWithText:@"朋友圈"  image:[UIImage imageNamed:@"WXSpace"] handler:^(ButtonView *buttonView){
            [weakSelf share:4 Url:iamge Title:Title];//微信朋友圈
        }];
        [activityView addButtonView:bv];
        
        [activityView show];
    }
}

-(void)share:(int)type Url:(UIImage *)Str  Title:(NSString *)Title{
    //分享代码；
    if (type == 1) {        //qq
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
            return;
        }
        NSString *title = @"蓝聘";
        NSData *data = UIImagePNGRepresentation(Str);

        QQApiImageObject *newsObj = [QQApiImageObject objectWithData:data
                                                    previewImageData:data
                                                               title:nil
                                                         description:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
    }else if (type == 2){      //QQ空间
        if (![QQApiInterface isSupportShareToQQ])
        {
            [LPTools AlertMessageView:@"请安装QQ" dismiss:1.0];
            return;
        }
        NSString *title = @"蓝聘";
        NSData *data = UIImagePNGRepresentation(Str);
        QQApiImageObject *newsObj = [QQApiImageObject objectWithData:data
                                                    previewImageData:data
                                                               title:nil
                                                         description:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
    }else if (type == 3){       //  wx
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
        NSData *data = UIImagePNGRepresentation(Str);
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = data;

        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneSession;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"蓝聘";
        message.description= Title;
 
        message.mediaObject = ext;
        req.message = message;
        [WXApi sendReq:req];
    }else if (type == 4){       //朋友圈
        if ([WXApi isWXAppInstalled]==NO) {
            [LPTools AlertMessageView:@"请安装微信" dismiss:1.0];
            return;
        }
        NSData *data = UIImagePNGRepresentation(Str);
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = data;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneTimeline;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"蓝聘";
        message.description= Title;

//        WXWebpageObject *ext = [WXWebpageObject object];
        
//        ext.webpageUrl = Str;
        message.mediaObject = ext;
        req.message = message;
        [WXApi sendReq:req];
    }
}


@end
