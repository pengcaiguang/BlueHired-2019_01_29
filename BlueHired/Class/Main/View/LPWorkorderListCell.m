//
//  LPWorkorderListCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkorderListCell.h"

@implementation LPWorkorderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LPWorkorderListDataModel *)model{
    _model = model;
    
    self.mechanismNameLabel.text = model.mechanismName;
    self.timeLabel.text = [NSString convertStringToTime:model.time];
    
    if ([model.status integerValue] == 1 ) {//1 通过
        self.statusLabel.text = @"入职状体啊：面试通过";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }else if ([model.status integerValue] == 2){//2。失败
        self.statusLabel.text = @"入职状体啊：面试失败";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }else if ([model.status integerValue] == 3){//3。招满
        self.statusLabel.text = @"入职状体啊：已招满";
        self.titleBgView.backgroundColor = [UIColor colorWithHexString:@"#939393"];
        [self.selectButton setTitle:@"删除" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
    }else{
        self.statusLabel.text = @"入职状体啊：预约中";
        self.titleBgView.backgroundColor = [UIColor baseColor];
        [self.selectButton setTitle:@"取消报名" forState:UIControlStateNormal];
        self.selectButton.backgroundColor = [UIColor baseColor];
    }
    
    
    self.interviewTimeLabel.text = [NSString stringWithFormat:@"面试时间：%@",model.interviewTime];
    self.workNameLabel.text = [NSString stringWithFormat:@"应聘岗位：%@",model.workName];
    self.teacherNameLabel.text = [NSString stringWithFormat:@"驻场老师：%@",model.teacherList[0].teacherName];
    
    if (model.teacherList.count > 1) {
        self.teacherTelLabel.text = [NSString stringWithFormat:@"驻场老师：%@",model.teacherList[1].teacherName];
    }else{
        self.teacherTelLabel.text = [NSString stringWithFormat:@"联系方式：%@",model.teacherList[0].teacherTel];
    }
    
    self.recruitAddressLabel.text = [NSString stringWithFormat:@"面试地点：%@",model.recruitAddress];
    
}
- (IBAction)touchSelectButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(buttonClick:workId:)]) {
        NSInteger index;
        if ([self.model.status integerValue] == 1 || [self.model.status integerValue] == 2 || [self.model.status integerValue] == 3){
            index = 0;//删除
        }else{
            index = 1;//取消
        }
        [self.delegate buttonClick:index workId:self.model.workId.integerValue];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
