//
//  LPWorkHourKQWeekVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourKQWeekVC.h"
#import "LPWorkHourYsetModel.h"

@interface LPWorkHourKQWeekVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *SaveBT;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;
@property (weak, nonatomic) IBOutlet UIPickerView *PickerView;
@property (weak, nonatomic) IBOutlet UIView *BackPickerView;

@property (weak, nonatomic) IBOutlet UILabel *KQWeekLabel;

@property (nonatomic,assign) NSInteger SelectRow;

@property (nonatomic,strong) NSMutableArray *DataList;

@property (nonatomic,strong) LPWorkHourYsetModel *model;

@end

@implementation LPWorkHourKQWeekVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"考勤周期";
    
    self.SaveBT.layer.cornerRadius = 4;
    self.cancelBT.layer.cornerRadius = 4;
    self.cancelBT.layer.borderWidth = 1;
    self.cancelBT.layer.borderColor= [UIColor baseColor].CGColor;

    self.PickerView.delegate = self;
    self.PickerView.dataSource = self;
    [self addShadowToView:self.BackPickerView withColor:[UIColor lightGrayColor]];
    
    //获取当月的总天数
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
  
    self.DataList = [[NSMutableArray alloc] init];
    [self.DataList addObject:@"本月1号—本月结束"];
    for (int i = 2; i <=28; i++) {
        [self.DataList addObject:[NSString stringWithFormat:@"本月%d号—下月%d号",i,i-1]];
    }
 
    [self requestQueryGetHoursWorkYset];
}
/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 4;
    theView.layer.masksToBounds = NO;
    
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.DataList.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.DataList objectAtIndex:row];
}
// 给pickerview设置字体大小和颜色等
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;

    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        if (self.SelectRow == row) {
            pickerLabel.textColor = [UIColor baseColor];
        }
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }

    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    return pickerLabel;
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.SelectRow = row;
    //刷新picker，看上面的代理
    [self.PickerView reloadComponent:component];
//    self.KQWeekLabel.text = self.DataList[row];

}

- (void)setModel:(LPWorkHourYsetModel *)model{
    _model = model;
    if (model.data) {
        if ([model.data.period isEqualToString:@"01-31"]) {
            [self.PickerView selectRow:0 inComponent:0 animated:YES];
            self.KQWeekLabel.text = self.DataList[0];
        }else{
            NSArray *DateArr = [model.data.period componentsSeparatedByString:@"-"];
            [self.PickerView selectRow:[DateArr[0] integerValue]-1 inComponent:0 animated:YES];
            [self pickerView:self.PickerView didSelectRow:[DateArr[0] integerValue]-1 inComponent:0];
            self.KQWeekLabel.text = self.DataList[[DateArr[0] integerValue]-1];
        }
    }
}

- (IBAction)TouchCave:(id)sender {
    
    NSString *str2 =self.DataList[self.SelectRow];
        NSString *str1 = [NSString stringWithFormat:@"是否将考勤周期修改成 %@ ?",str2];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
        //设置：在3~length-3个单位长度内的内容显示成橙色
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[str1 rangeOfString:str2]];
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                [self requestQuerySetHoursWorkYset];
            }
        }];
        [alert show];
    
    
}

- (IBAction)TouchCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - request
-(void)requestQueryGetHoursWorkYset{
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"status":@(1),
                          };
    [NetApiManager requestQueryGetHoursWorkYset:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPWorkHourYsetModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQuerySetHoursWorkYset{
    
    NSString *Period = @"";
    if (self.SelectRow == 0) {
        Period = @"01-31";
    }else{
        Period = [NSString stringWithFormat:@"%.2ld-%.2ld",self.SelectRow+1,(long)self.SelectRow];
    }
    
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"id":self.model.data.id?self.model.data.id:@"",
                          @"period":Period,
                          @"status":@(1)
                          };
    [NetApiManager requestQuerySetHoursWorkYset:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1){
                    [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"保存失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];

        }
        
    }];
}
@end
