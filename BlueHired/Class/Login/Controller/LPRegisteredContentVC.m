//
//  LPRegisteredContentVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/5.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisteredContentVC.h"
#import <WebKit/WebKit.h>

@interface LPRegisteredContentVC ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation LPRegisteredContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户协议";
    
//    NSString *str = @"http://www.lanpin123.com/bluehired/protocol.html?type=android";
//        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    self.wkWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
//
//    [self.view addSubview:self.wkWebView];
//    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = webView;
    NSURL *url = [NSURL URLWithString:@"http://www.lanpin123.com/bluehired/protocol.html?type=android"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
//    [self.wkWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\" name=\"viewport\"><style type=\"text/css\">img{display: inline-block;max-width: 100%%;width:auto; height:auto;}</style></head><body>\%@</body></html>",str] baseURL: nil];

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.wkWebView.scrollView.scrollEnabled = NO;
    [webView evaluateJavaScript:@"document.body.scrollHeight"
              completionHandler:^(id result, NSError *_Nullable error) {
                  CGFloat documentHeight = [result doubleValue];
                  NSLog(@"%f",documentHeight);
                 self.wkWebView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, documentHeight);
              }];
}

-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.opaque = NO;
        _wkWebView.userInteractionEnabled = NO;
//        _wkWebView.scrollView.bounces = NO;
        _wkWebView.scrollView.delegate = self;
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}

@end
