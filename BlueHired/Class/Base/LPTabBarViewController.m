//
//  LPTabBarViewController.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPTabBarViewController.h"

@interface LPTabBarViewController ()

@end

@implementation LPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTabControllers];

}

-(void)createTabControllers{
    
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableArray *titleArrays = [NSMutableArray array];
    
    NSMutableArray *normalImages = [NSMutableArray array];
    NSMutableArray *selectedImages = [NSMutableArray array];
    
    controllers = [NSMutableArray arrayWithArray:@[@"LPMineVC",@"LPInformationVC",@"LPCircleVC",@"LPMainVC"]];
    titleArrays = [NSMutableArray arrayWithArray:@[@"首页",@"资讯",@"圈子",@"我的"]];
    
    for (int index = 0; index<controllers.count; index++) {
        [normalImages addObject:[[UIImage imageNamed:[NSString stringWithFormat:@"ic_tab_normal0%d.png",index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [selectedImages addObject:[[UIImage imageNamed:[NSString stringWithFormat:@"ic_tab_selected0%d.png",index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int index = 0; index < controllers.count; index++) {
        
        RTRootNavigationController *navigationViewController;
        
        Class class = NSClassFromString(controllers[index]);
        
        UIViewController *vc = [[class alloc] init];
        vc.navigationItem.title = [titleArrays objectAtIndex:index];
        navigationViewController = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        
        UIImage *normalImage = (UIImage *)normalImages[index];
        
        UIImage *selectedImage = (UIImage *)selectedImages[index];
        
        navigationViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[titleArrays objectAtIndex:index] image:normalImage selectedImage:selectedImage];
        
        [navigationViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#FF3CAFFF"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [navigationViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#FF5E5E5E"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

        navigationViewController.tabBarItem.tag = index;
        [viewControllers addObject:navigationViewController];
        
    }
    // 首页
    [self setViewControllers:viewControllers];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
