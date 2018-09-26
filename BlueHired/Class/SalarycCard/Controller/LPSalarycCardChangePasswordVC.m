//
//  LPSalarycCardChangePasswordVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalarycCardChangePasswordVC.h"
#import "LPSalarycCardBindPhoneVC.h"

@interface LPSalarycCardChangePasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@end

@implementation LPSalarycCardChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.textColor = [UIColor clearColor];
    self.textField.tintColor = [UIColor clearColor];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    self.labelArray = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        [self.labelArray addObject:label];
        [self.textField addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
    }
    [self.labelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [self.labelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.textField becomeFirstResponder];
    NSMutableArray *viewarray = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"#AAAAAA"];
        [viewarray addObject:view];
        [self.textField addSubview:view];
    }
    [viewarray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:(SCREEN_WIDTH-46)/6-1 leadSpacing:0 tailSpacing:0];
    [viewarray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
}
-(void)textFieldChanged:(UITextField *)textField{
    for (UILabel *label in self.labelArray) {
        label.text = @"";
    }
    if (textField.text.length > 6) {
        return;
    }
    for (int i =0; i<textField.text.length; i++) {
        //        self.labelArray[i].text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        self.labelArray[i].text = @"●";
    }
    if (textField.text.length == 6) {
        
    }
}
#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.textField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.textField.text.length >= 6) {
            self.textField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}
- (IBAction)touchPhone:(UIButton *)sender {
    LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
