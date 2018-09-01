//
//  LPEssayDetailHeadCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPEssayDetailHeadCell.h"

@interface LPEssayDetailHeadCell() <WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic,assign) BOOL reloadTable;

@end

@implementation LPEssayDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.webBgView addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webBgView);
    }];
//    self.wkWebView.backgroundColor = [UIColor redColor];

}

-(void)setModel:(LPEssayDetailModel *)model{
    if ([_model.mj_keyValues isEqual:model.mj_keyValues]) {
        return;
    }
    _model = model;
    
    self.essayNameLabel.text = model.data.essayName;
    self.essayAuthorLabel.text = model.data.essayAuthor;
    self.timeLabel.text = [NSString convertStringToTime:[model.data.time stringValue]];
    self.viewLabel.text = model.data.view ? [model.data.view stringValue] : @"0";
    self.commentTotalLabel.text = model.data.commentTotal ? [model.data.commentTotal stringValue] : @"0";
    self.praiseTotalLabel.text = model.data.praiseTotal ? [model.data.praiseTotal stringValue] : @"0";
    
    if (!kStringIsEmpty(model.data.essayDetails)) {
//        [self.wkWebView loadHTMLString:model.data.essayDetails baseURL:nil];
        
        [self.wkWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\" name=\"viewport\"><style type=\"text/css\">img{display: inline-block;max-width: 100%%}</style></head><body>\%@</body></html>",model.data.essayDetails] baseURL: nil];

        
    }
    
}


//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
//{
//
////    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetTop"completionHandler:^(id _Nullable result,NSError * _Nullable error) {
////        //获取页面高度，并重置webview的frame
////        CGFloat lastHeight  = [result doubleValue];
////        NSLog(@"%f",lastHeight);
//////        self.wkWebView.frame = CGRectMake(14, 0, SCREEN_WIDTH - 28, lastHeight);
////        self.webBgView_constraint_height.constant = lastHeight;
//////        webHeight = lastHeight;
////        [self.tableView beginUpdates];
////        [self.tableView endUpdates];
////    }];
//
//    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;"completionHandler:^(id _Nullable result,NSError *_Nullable error) {
//        //获取页面高度，并重置webview的frame
//        CGFloat documentHeight = [result doubleValue];
//        NSLog(@"%f",documentHeight);
//
////        CGRect frame = webView.frame;
////        frame.size.height = documentHeight;
////        webView.frame = frame;
//    }];
//
//
//}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.wkWebView.scrollView.scrollEnabled = NO;
    [webView evaluateJavaScript:@"document.body.scrollHeight"
              completionHandler:^(id result, NSError *_Nullable error) {
                  CGFloat documentHeight = [result doubleValue];
                  NSLog(@"%f",documentHeight);
                  self.webBgView_constraint_height.constant = documentHeight;
                  
                  [self.tableView beginUpdates];
                  [self.tableView endUpdates];
                  
                  //result 就是加载完成后 webView的实际高度
                  //获取后返回重新布局
              }];
}



- (UITableView *)tableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.opaque = NO;
        _wkWebView.userInteractionEnabled = NO;
        _wkWebView.scrollView.bounces = NO;
        [_wkWebView sizeToFit];

        //开了支持滑动返回
//        _wkWebView.allowsBackForwardNavigationGestures = YES;
    }
    return _wkWebView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
