//
//  LPTabBarViewController.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPTabBarViewController.h"


@interface LPTabBarViewController ()<UITabBarDelegate>

@end

@implementation LPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTabControllers];
    [[UITabBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    for(UIViewController *viewController in  self.viewControllers){
//        [viewController loadViewIfNeeded]; //ios9
//        //      __unused  UIView *view =  viewController.view;
//    }
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                       [UIColor colorWithHexString:@"e0e0e0"].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];

    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
}

-(void)createTabControllers{
    
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableArray *titleArrays = [NSMutableArray array];
    
    NSMutableArray *normalImages = [NSMutableArray array];
    NSMutableArray *selectedImages = [NSMutableArray array];
    
    controllers = [NSMutableArray arrayWithArray:@[@"LPMainVC",@"LPRecreationVC",@"LPCircle2VC",@"LPMine2VC"]];
    titleArrays = [NSMutableArray arrayWithArray:@[@"招工",@"看看",@"圈子",@"我的"]];
//    controllers = [NSMutableArray arrayWithArray:@[@"LPWorkHour2VC",@"LPInformationVC",@"LPCircleVC",@"LPMineVC"]];
//    titleArrays = [NSMutableArray arrayWithArray:@[@"工时",@"看看",@"圈子",@"我的"]];

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
        
        [navigationViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0,-4)];



        if (@available(iOS 13.0, *)) {
                self.tabBar.tintColor = [UIColor colorWithHexString:@"#3CAFFF"];
//            UITabBarAppearance *appearance = [UITabBarAppearance new];
//            // 设置未被选中的颜色
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]};
//            // 设置被选中时的颜色
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#3CAFFF"]};
//            navigationViewController.tabBarItem.standardAppearance = appearance;
        } else {
//                self.tabBar.tintColor = [UIColor colorWithHexString:@"#3CAFFF"];
            [navigationViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#3CAFFF"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
            [navigationViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#333333"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        }

        navigationViewController.tabBarItem.tag = index;
        [viewControllers addObject:navigationViewController];
        
    }
    // 首页
    [self setViewControllers:viewControllers];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
   
}

 
- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
