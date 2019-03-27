//
//  LXCalenderCell.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalenderCell.h"
@interface LXCalenderCell()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *Top1label;
@property (weak, nonatomic) IBOutlet UILabel *Top2label;

@property (weak, nonatomic) IBOutlet UILabel *Spendlabel;
@property (weak, nonatomic) IBOutlet UILabel *Recesslabel;
@property (weak, nonatomic) IBOutlet UILabel *Worklabel;


@end
@implementation LXCalenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Top1label.layer.cornerRadius = self.Top1label.lx_width/2;
    self.Top1label.layer.backgroundColor = [UIColor colorWithHexString:@"#0CC2DE"].CGColor;
    self.Top2label.layer.cornerRadius = self.Top2label.lx_width/2;
    self.Top2label.layer.backgroundColor = [UIColor colorWithHexString:@"#FFAF3C"].CGColor;
    
    self.Spendlabel.textColor = [UIColor colorWithHexString:@"#FD45FF"];
    self.Recesslabel.textColor = [UIColor colorWithHexString:@"#8661FE"];
    self.Worklabel.textColor = [UIColor colorWithHexString:@"#3CAFFF"];
    
    self.Spendlabel.backgroundColor = [UIColor clearColor];
    self.Recesslabel.backgroundColor = [UIColor clearColor];
    self.Worklabel.backgroundColor = [UIColor clearColor];
}
-(void)setModel:(LXCalendarDayModel *)model{
    _model = model;
    
    self.label.text = [NSString stringWithFormat:@"%ld",model.day];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:15];
    if (model.year>0) {
        NSString *dateStr = [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",(long)model.year,(long)model.month,(long)model.day];
        
        NSString *isFestival =[LPTools calculationChinaCalendarWithDate:[DataTimeTool dateFromString:dateStr DateFormat:@"yyyy-MM-dd"]];
        
        if (![isFestival isEqualToString:@""]) {
            self.label.text = isFestival;
            self.label.textColor = [UIColor redColor];
            self.label.font = [UIFont systemFontOfSize:Screen_Width == 320?12:15];
        }
    }

 
    [self.label setFTCornerdious:0.0];
    self.label.backgroundColor = [UIColor whiteColor];
    
    if (model.isNextMonth || model.isLastMonth) {
//        self.userInteractionEnabled = NO;
       
        if (model.isShowLastAndNextDate) {
            
            self.label.hidden = NO;
            self.Top1label.hidden = NO;
            self.Top2label.hidden = NO;
            self.Spendlabel.hidden = NO;
            self.Recesslabel.hidden = NO;
            self.Worklabel.hidden = NO;
//            if (model.isNextMonth) {
//                self.label.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
//            }
            self.Spendlabel.text = model.accountMoney;
            self.Recesslabel.text = model.leaveHours;
            self.Worklabel.text = model.overtimeHours;
            if (model.remark.integerValue>0) {
                self.Top2label.hidden = NO;
            }else{
                self.Top2label.hidden = YES;
            }
            
            self.Top1label.hidden = YES;

            self.Top1label.text = @"";
            if (model.shift.integerValue == 1) {
                self.Top1label.text = @"白";
                self.Top1label.hidden = NO;
            }else if (model.shift.integerValue == 2){
                self.Top1label.text = @"夜";
                self.Top1label.hidden = NO;
                
            }else if (model.shift.integerValue == 3){
                self.Top1label.text = @"早";
                self.Top1label.hidden = NO;
                
            }else if (model.shift.integerValue == 4){
                self.Top1label.text = @"中";
                self.Top1label.hidden = NO;
                
            }else if (model.shift.integerValue == 5){
                self.Top1label.text = @"晚";
                self.Top1label.hidden = NO;
                
            }else if (model.shift.integerValue == 6){
                self.Top1label.text = @"休";
                self.Top1label.hidden = NO;
            }
            
            if (model.isLastMonth) {
//                self.label.textColor = model.lastMonthTitleColor? model.lastMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
            }

            
        }else{
            
            self.label.hidden = YES;
            self.Top1label.hidden = YES;
            self.Top2label.hidden = YES;
            self.Spendlabel.hidden = YES;
            self.Recesslabel.hidden = YES;
            self.Worklabel.hidden = YES;
        }
        
        
    }else{
        
        self.label.hidden = NO;
        self.Top1label.hidden = NO;
        self.Top2label.hidden = NO;
        self.Spendlabel.hidden = NO;
        self.Recesslabel.hidden = NO;
        self.Worklabel.hidden = NO;
//        self.userInteractionEnabled = NO;
        
        self.Spendlabel.text = model.accountMoney;
        self.Recesslabel.text = model.leaveHours;
        self.Worklabel.text = model.overtimeHours;
        if (model.remark.integerValue>0) {
            self.Top2label.hidden = NO;
        }else{
            self.Top2label.hidden = YES;
        }

 
        self.Top1label.text = @"";
        self.Top1label.hidden = YES;
        if (model.shift.integerValue == 1) {
            self.Top1label.text = @"白";
            self.Top1label.hidden = NO;
        }else if (model.shift.integerValue == 2){
            self.Top1label.text = @"夜";
            self.Top1label.hidden = NO;

        }else if (model.shift.integerValue == 3){
            self.Top1label.text = @"早";
            self.Top1label.hidden = NO;

        }else if (model.shift.integerValue == 4){
            self.Top1label.text = @"中";
            self.Top1label.hidden = NO;

        }else if (model.shift.integerValue == 5){
            self.Top1label.text = @"晚";
            self.Top1label.hidden = NO;

        }else if (model.shift.integerValue == 6){
            self.Top1label.text = @"休";
            self.Top1label.hidden = NO;
        }
        
        
        if (model.isSelected) {
            [self.label setFTCornerdious:self.label.lx_width/2];
            self.label.backgroundColor = model.selectBackColor?model.selectBackColor:[UIColor greenColor];
            
            if (model.isHaveAnimation) {
                 [self addAnimaiton];
            }
           
        }
//        self.label.textColor = model.currentMonthTitleColor?model.currentMonthTitleColor:[UIColor hexStringToColor:@"000000"];
        if (model.isToday) {
//            self.label.textColor = model.todayTitleColor?model.todayTitleColor:[UIColor redColor];
        }
    }
    
}
-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    
    anim.values = @[@0.6,@1.2,@1.0];
//    anim.fromValue = @0.6;
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;                // 设置动画执行时间
//    anim.repeatCount = MAXFLOAT;        // MAXFLOAT 表示动画执行次数为无限次
    
//    anim.autoreverses = YES;            // 控制动画反转 默认情况下动画从尺寸1到0的过程中是有动画的，但是从0到1的过程中是没有动画的，设置autoreverses属性可以让尺寸0到1也是有过程的
    
    [self.label.layer addAnimation:anim forKey:nil];
}
@end
