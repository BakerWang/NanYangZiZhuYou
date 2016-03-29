//
//  LZAdViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/12.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZAdViewController.h"

@interface LZAdViewController ()<UIWebViewDelegate>

@end

@implementation LZAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    // 1.webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    // 伸缩页面至填充整个webView
    webView.scalesPageToFit = YES;
    // 隐藏scrollView
    //    webView.scrollView.hidden = YES;
    [ProgressHUD show:@"加载中..."];
    // 2.加载网页
    //http://m.mafengwo.cn/mdd/17396
    //http://www.mafengwo.cn/travel-scenic-spot/mafengwo/17396.html
    if (self.tag == 90) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.mafengwo.cn/mdd/17396"]];
        [webView loadRequest:request];
    }else if (self.tag == 91){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.mafengwo.cn/jd/17396/gonglve.html?mfw_chid=2703"]];
        [webView loadRequest:request];
        
    }else if (self.tag == 92){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.mafengwo.cn/cy/17396/gonglve.html"]];
        [webView loadRequest:request];
        
    }else if (self.tag == 93){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.mafengwo.cn/gw/17396/gonglve.html"]];
        [webView loadRequest:request];
        
    }else if (self.tag == 94){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.mafengwo.cn/yl/17396/gonglve.html"]];
        [webView loadRequest:request];
        
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [ProgressHUD dismiss];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
    
    
}


@end
