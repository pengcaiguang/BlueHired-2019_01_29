//
//  CustomDataPickView.m
//  BlueHired
//
//  Created by iMac on 2019/3/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "CustomDataPickView.h"
#import "DataTimeTool.h"
#import "Masonry.h"

@interface CustomDataPickView ()
//保存年月日数据的array
@property (nonatomic,strong) NSMutableArray *yearArray;
@property (nonatomic,strong) NSMutableArray *monthArray;
@property (nonatomic,strong) NSMutableArray *dayArray;
//选中的当前行
@property (nonatomic,assign) int selectedRowYear;
@property (nonatomic,assign) int selectedRowMonth;
@property (nonatomic,assign) int selectedRowDay;
//每个月的天数
@property (nonatomic,assign) int dayNumber;
//应该跟新天数了,当月份或年份被选择过或是刚进入为true，需要刷新day
@property (nonatomic,assign) Boolean dayShouldChangeEnable;

@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *day;

@end

@implementation CustomDataPickView

//根据传递进入的dayNumber计算dayArray
-(void)setDaysForMonth:(int) dayNumber{
    self.dayArray = nil;
    self.dayArray = [NSMutableArray array];
    for (int index=1; index<=_dayNumber; index++) {
        [_dayArray addObject:[@(index) stringValue]];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

-(instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithBtns:(NSArray *)btns vc:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        //[self Btns:btns vc:vc];
    }
    return self;
}

-(void)commonInit{
}

-(void)initYesArr {
    self.yearArray  = [NSMutableArray array];
    NSString *maxYearStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    NSString *minYearStr = [DataTimeTool stringFromDate:self.minimumDate DateFormat:@"yyyy"];
    int difference = [maxYearStr intValue] - [minYearStr intValue];
    if (difference<0 || difference==0) {
        [self.yearArray addObject:maxYearStr];
        return;
    }
    for (int i = 0; i<=difference; i ++) {
        NSString *yesS = [NSString stringWithFormat:@"%d",[minYearStr intValue] + i];
        [self.yearArray addObject:yesS];
    }
    [self YearMonthEqual_pickerView:pickView inComponent:0 month:[self.month intValue] Year:[self.year intValue]];
}

-(void)initDayArr {
    self.dayArray = [NSMutableArray array];
    [self calculateDayWithMonth:[self.month intValue] andYear:[self.year intValue]];
}

-(void)initMonthArr {
    self.monthArray = [NSMutableArray array];
    NSString *maxMonthStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"MM"];
    NSString *maxYearStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    
    NSString *minMonthStr = [DataTimeTool stringFromDate:self.minimumDate DateFormat:@"MM"];
    NSString *minYearStr = [DataTimeTool stringFromDate:self.minimumDate DateFormat:@"yyyy"];
    
    if ([maxYearStr intValue] == [minYearStr intValue]) {
        for (int i = [minMonthStr intValue]; i<=[maxMonthStr intValue]; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.monthArray addObject:yesS];
        }
        return;
    }
    [self YearMonthEqual_pickerView:pickView inComponent:0 month:[self.month intValue] Year:[self.year intValue]];
}


#pragma  mark -- <UIPickerViewDataSource,UIPickerViewDelegate>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.type == CustomDataPickViewTypeYearMonth) {
        return 2;
    }else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.yearArray.count;
    }else if(component==1){
        return self.monthArray.count;
    } else{
        return self.dayArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
    }else if(component==1){
        return [NSString stringWithFormat:@"%@月",[self.monthArray objectAtIndex:row]];
    }else {
        return [NSString stringWithFormat:@"%@日",[self.dayArray objectAtIndex:row]];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        _dayShouldChangeEnable = true;
        self.year = self.yearArray[row];
        self.selectedRowYear = (int)row;
        [pickerView reloadComponent:0];
        [self YearMonthEqual_pickerView:pickerView inComponent:0 month:[self.month intValue] Year:[self.year intValue]];
    }else if(component==1){
        _dayShouldChangeEnable = true;
        self.month = self.monthArray[row];
        self.selectedRowMonth = (int)row;
        [pickerView reloadComponent:1];
        [self YearMonthEqual_pickerView:pickerView inComponent:1 month:[self.month intValue] Year:[self.year intValue]];
    }else{
        self.day = _dayArray[row];
        self.selectedRowDay = (int)row;
        [pickerView reloadComponent:2];
    }
    if (self.type == CustomDataPickViewTypeYearMonthDay) {
        if(_dayShouldChangeEnable){
            //调用计算天数的函数
            [self calculateDayWithMonth:[self.month intValue] andYear:[self.year intValue]];
            //由于更新的时候self.selectRowDay很可能大于 天数的最大值，比如self.selectRowDay为31，而天数最大值切换至了29，所以若超出，则需要将selectRowDay重新赋值
            if(self.selectedRowDay > _dayNumber-1){
                self.selectedRowDay = _dayNumber-1;
            }
            [pickerView reloadComponent:2];
            _dayShouldChangeEnable = false;
        }
    }
    if ([self.delegate respondsToSelector:@selector(pickViewScroollCallBack_year:month:day:)]) {
        [self.delegate pickViewScroollCallBack_year:self.year month:self.month day:self.day];
    }
 
}

-(void)YearMonthEqual_pickerView:(UIPickerView *)pickerView inComponent:(NSInteger)component month:(int)month Year:(int) year {
    NSString *maxYearStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    NSString *maxMonthStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"MM"];
    NSString *maxDayStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"dd"];
    
    if (component == 0) {
        self.monthArray = [NSMutableArray array];
        if ([maxYearStr intValue] != year) {
            NSString *minMonthStr = [DataTimeTool stringFromDate:self.minimumDate DateFormat:@"MM"];
            for (int i = [minMonthStr intValue]; i<=12; i++) {
                NSString *yesS = [NSString stringWithFormat:@"%d",i];
                [self.monthArray addObject:yesS];
            }
            [pickerView reloadComponent:1];
        }else {
            for (int i = 1; i<=[maxMonthStr intValue]; i++) {
                NSString *yesS = [NSString stringWithFormat:@"%d",i];
                [self.monthArray addObject:yesS];
            }
            if ([maxMonthStr intValue] < [self.month intValue]) {
                self.month = maxMonthStr;
                month = [maxMonthStr intValue];
            }
            [pickerView reloadComponent:1];
        }
        
        if ([maxYearStr intValue] == month && [maxMonthStr intValue] == year) {
            self.dayArray = [NSMutableArray array];
            for (int i = 1; i<=[maxDayStr intValue]; i++) {
                NSString *yesS = [NSString stringWithFormat:@"%d",i];
                [self.dayArray addObject:yesS];
            }
            [pickerView reloadComponent:2];
        }
    }
    
}

//根据month和year计算对应的天数
-(void)calculateDayWithMonth:(int) month andYear:(int) year{
    float yearF = [self.year floatValue]/4; //能被4整除的是闰年
    float yearI = (int)yearF; //若yearI和yearF不一样，也就是说没有被整除，则不是闰年
    //当然以上计算没有包括：能被100整除，但不能被400整除的，不是闰年，因为2000年已过2100年还远....
    
    switch (month) {
        case 1:_dayNumber = 31; break;
        case 2:
            if(yearF != yearI){_dayNumber = 28;}else{
                _dayNumber = 29;}break;
        case 3:_dayNumber = 31;break;
        case 4:_dayNumber = 30;break;
        case 5:_dayNumber = 31;break;
        case 6:_dayNumber = 30;break;
        case 7:_dayNumber = 31;break;
        case 8:_dayNumber = 31;break;
        case 9:_dayNumber = 30;break;
        case 10:_dayNumber = 31;break;
        case 11:_dayNumber = 30;break;
        case 12:_dayNumber = 31;break;
        default:_dayNumber = 31;break;
    }
    
    NSString *maxYearStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    NSString *maxMonthStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"MM"];
    NSString *maxDayStr = [DataTimeTool stringFromDate:self.maximumDate DateFormat:@"dd"];
    
    NSString *minYearStr = [DataTimeTool stringFromDate:self.minimumDate DateFormat:@"yyyy"];
    NSString *minMonthStr = [DataTimeTool stringFromDate:self.minimumDate DateFormat:@"MM"];
    NSString *minDayStr = [DataTimeTool stringFromDate:self.minimumDate DateFormat:@"dd"];
    
    if ([minYearStr intValue] == year && [minMonthStr intValue] == month && [maxYearStr intValue] == year && [maxMonthStr intValue] == month) {
        self.dayArray = [NSMutableArray array];
        for (int i = [minDayStr intValue]; i<=[maxDayStr intValue]; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.dayArray addObject:yesS];
        }
        return;
    }
    
    if ([minYearStr intValue] == year && [minMonthStr intValue] == month) {
        self.dayArray = [NSMutableArray array];
        for (int i = [minDayStr intValue]; i<=_dayNumber; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.dayArray addObject:yesS];
        }
        return;
    }
    
    if ([maxYearStr intValue] == year && [maxMonthStr intValue] == month) {
        self.dayArray = [NSMutableArray array];
        for (int i = 1; i<=[maxDayStr intValue]; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.dayArray addObject:yesS];
        }
        return;
    }
    [self setDaysForMonth:_dayNumber]; //此处调用函数，将dayArray重新赋值；
}

- (void)show{
    self.month = [DataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"M"];
    self.year = [DataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"y"];
    
    [self initYesArr];
    [self initMonthArr];
    [self initDayArr];
    
    if (!pickView) {
        pickView = [[UIPickerView alloc]initWithFrame:self.bounds];
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.dataSource = self;
        pickView.delegate = self;
        [self addSubview:pickView];
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.mas_equalTo(0);
        }];
    }
    
    NSString *defaultYearStr = [DataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"y"];
    NSUInteger yeasRow = [self.yearArray indexOfObject:defaultYearStr];
    
    NSString *defaultMonthStr = [DataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"M"];
    NSUInteger monthRow = [self.monthArray indexOfObject:defaultMonthStr];
    
    NSString *defaultDayStr = [DataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"d"];
    NSUInteger dayRow = [self.dayArray indexOfObject:defaultDayStr];
    
    if (yeasRow < self.yearArray.count) {
        [pickView selectRow:yeasRow inComponent:0 animated:YES];
    }
    
    if (monthRow < self.monthArray.count) {
        [pickView selectRow:monthRow  inComponent:1 animated:YES];
    }
    
    if (self.type == CustomDataPickViewTypeYearMonthDay) {
        if (dayRow < self.dayArray.count) {
            [pickView selectRow:dayRow  inComponent:2 animated:YES];
        }
    }
}

- (void)startCallBack{
    NSInteger yearRow = [pickView selectedRowInComponent:0];
    NSInteger monthRow = [pickView selectedRowInComponent:1];
    if (self.type == CustomDataPickViewTypeYearMonth) {
        if ([_delegate respondsToSelector:@selector(pickViewCallBack_year:month:)]) {
            [_delegate pickViewCallBack_year:[self.yearArray objectAtIndex:yearRow] month:[self.monthArray objectAtIndex:monthRow]];
        }
    }
    if (self.type == CustomDataPickViewTypeYearMonthDay) {
        NSInteger dayRow = [pickView selectedRowInComponent:2];
        if ([_delegate respondsToSelector:@selector(pickViewCallBack_year:month:day:)]) {
            [_delegate pickViewCallBack_year:[self.yearArray objectAtIndex:yearRow] month:[self.monthArray objectAtIndex:monthRow] day:[self.dayArray objectAtIndex:dayRow]];
        }
    }
}

@end

