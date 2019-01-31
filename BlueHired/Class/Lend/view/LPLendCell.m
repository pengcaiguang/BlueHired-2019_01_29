//
//  LPLendCell.m
//  BlueHired
//
//  Created by iMac on 2018/11/13.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLendCell.h"

@implementation LPLendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LPQueryCheckrecordModel *)model{
    _model = model;
    if (model.data) {
//        self.recordView.hidden = NO;
    }
    
    self.text1.text = @"";
    self.text2.text = @"";
    self.text3.text = @"";
    self.time1.text = @"";
    self.time2.text = @"";
    self.time3.text = @"";
    
    if (model.data.status.integerValue == 0) {
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"add_ record_normal"];
        
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        
        self.text1.text = [NSString stringWithFormat:@"借支金额%@元，我们将在1-3个工作日内完成审核",model.data.lendMoney];
        self.Title3.text = @"审核通过";
        [self.bottomButton setTitle:@"返回" forState:UIControlStateNormal];
        
    }else if (model.data.status.integerValue == 1){
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"add_ record_selected"];
        
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time3.text = [NSString convertStringToTime:[model.data.set_time stringValue]];
        
//        self.text3.text = @"借支金额将在1个工作日内发放至您的工资卡，如遇节假日时间顺延。";
        self.text1.text = [NSString stringWithFormat:@"借支金额%@元，我们将在1-3个工作日内完成审核",model.data.lendMoney];
        self.text3.text = [NSString stringWithFormat:@"%@",model.data.remarks];
        self.Title3.text = @"审核通过";
        [self.bottomButton setTitle:@"再借一笔" forState:UIControlStateNormal];
    }else if (model.data.status.integerValue == 2){
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"deleteCard"];
        self.text1.text = [NSString stringWithFormat:@"借支金额%@元，我们将在1-3个工作日内完成审核",model.data.lendMoney?model.data.lendMoney:@"0"];
        self.text3.text = [NSString stringWithFormat:@"%@",model.data.remarks];
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time3.text = [NSString convertStringToTime:[model.data.set_time stringValue]];
        self.Title3.text = @"失败";
        [self.bottomButton setTitle:@"重新申请" forState:UIControlStateNormal];
    }
 
}

- (IBAction)touchBottomButton:(UIButton *)sender {
    if (self.Block) {
        self.Block();
    }
}

@end
