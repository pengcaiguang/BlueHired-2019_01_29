//
//  LPMessageToServiceCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMessageToServiceCell.h"


@implementation LPMessageToServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftTxtView.layer.cornerRadius = LENGTH_SIZE(6);
    self.leftTxtView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.leftTxtView.layer.borderWidth = LENGTH_SIZE(0.5);
    
    self.leftUserImage.layer.cornerRadius = LENGTH_SIZE(18);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPCustomMessageModel *)model{
    _model = model;
    self.leftTxtLabel.text = model.text;
    if (model.Type == 1) {
        self.ToComment.hidden = YES;
        self.ToIm.hidden = NO;
        self.ToPhone.hidden = NO;
    }else if (model.Type == 2){
        self.ToComment.hidden = NO;
        self.ToIm.hidden = YES;
        self.ToPhone.hidden = YES;
    }
        
}

- (IBAction)TouchToPhone:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (IBAction)TouchToIm:(id)sender {
    if (self.block) {
        self.block();
    }
}

- (IBAction)TouchToComment:(id)sender {
    if (self.CommentBlock) {
        self.CommentBlock();
    }
}

@end
