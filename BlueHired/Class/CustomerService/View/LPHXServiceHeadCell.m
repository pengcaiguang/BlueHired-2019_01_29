//
//  LPHXServiceHeadCell.m
//  BlueHired
//
//  Created by iMac on 2019/10/31.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHXServiceHeadCell.h"
#import "LPCustomerServiceVC.h"

@implementation LPHXServiceHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.HeadView.layer.cornerRadius = LENGTH_SIZE(6);
    self.HeadView.layer.borderWidth = LENGTH_SIZE(0.5);
    self.HeadView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchToMore:)];
    [self.HeadView addGestureRecognizer:TapGestureRecognizerimageBg];
}


- (void)setModel:(LPCustomerServiceModel *)model{
    _model = model;
    NSMutableArray *Problem = [[NSMutableArray alloc] init];
    for (LPCustomerServiceDataListModel *M in model.data.list) {
        [Problem addObjectsFromArray:[M.problemTitle componentsSeparatedByString:@"#"]];
    }

    NSInteger Count = Problem.count >= 3 ? 3 : Problem.count;
    for (int i = 0 ;i < Count ; i++) {
        UILabel *Label = [self.HeadView viewWithTag:i+1000];
        Label.text = [NSString stringWithFormat:@"%d.%@",i+1,Problem[i]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)TouchToService:(id)sender {
    if (self.block) {
        self.block();
    }
}

- (IBAction)TouchToMore:(id)sender {
    LPCustomerServiceVC *vc = [[LPCustomerServiceVC alloc] init];
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}
@end
