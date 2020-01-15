//
//  LPBaseViewController.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPBaseViewController.h"

@interface LPBaseViewController ()

@end

@implementation LPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    self.navigationItem.hidesBackButton = YES;

//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,-20, SCREEN_WIDTH, 20)];
//    [self.navigationController.navigationBar addSubview:backView];
//    backView.backgroundColor = [UIColor baseColor];
//    if (@available(iOS 11.0, *)) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
}
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"BackBttonImage"] forState:UIControlStateNormal];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.NBackBT = btn;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 这个方法返回支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

// 这个返回是否自动旋转
- (BOOL)shouldAutorotate{
  return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
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
