//
//  LPRecruitRequireCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRecruitRequireCell.h"

@implementation LPRecruitRequireCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.addRow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addRow.layer.borderWidth = 0.5;
    self.textView.delegate= self;
    self.HintList = @[@"请输入入职要求",@"请输入薪资福利",@"请输入住宿餐饮",@"请输入工作时间",@"请输入面试材料",@"请输入其他说明"];


}

-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"-%ld - %@",textView.tag ,textView.text);
    //    _valueArray[textField.tag-1] = textField.text;
    if ([self.textView.textColor isEqual:[UIColor lightGrayColor]])
    {
        return;
    }
    
    if (self.Block) {
        self.Block(textView.text);
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.textColor isEqual:[UIColor lightGrayColor]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = [NSString stringWithFormat:@"%ld、%@",(long)_row+1,self.HintList[_Type]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
