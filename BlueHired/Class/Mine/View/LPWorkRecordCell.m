//
//  LPWorkRecordCell.m
//  BlueHired
//
//  Created by iMac on 2019/10/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkRecordCell.h"

@implementation LPWorkRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPWorkRecordDataModel *)model{
    _model = model;
    
    self.WorkName.text = model.mechanismName;
    self.WorkPost.text = [NSString stringWithFormat:@"入职岗位：%@",model.workTypeName];
    self.TimeLabel.text = [NSString convertStringToTime:model.time];
    
    if (model.status.integerValue == 0) {
         self.WorkStatus.text = @"面试预约中";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"FFAE3D"];
    }else if (model.status.integerValue == 1){
        self.WorkStatus.text = @"面试通过";
        self.WorkStatus.textColor = [UIColor baseColor];
    }else if (model.status.integerValue == 2){
        self.WorkStatus.text = @"面试失败";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#FF5353"];
    }else if (model.status.integerValue == 4){
        self.WorkStatus.text = @"放弃入职";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#FF5353"];
    }else if (model.status.integerValue == 5){
        self.WorkStatus.text = @"入职成功";
        self.WorkStatus.textColor = [UIColor baseColor];
    }else if (model.status.integerValue == 6){
        self.WorkStatus.text = @"离职";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#FF5353"];
    }else if (model.status.integerValue == 7){
        self.WorkStatus.text = @"未报名";
        self.WorkStatus.textColor = [UIColor colorWithHexString:@"#FFAE3D"];

    }
    
}


@end
