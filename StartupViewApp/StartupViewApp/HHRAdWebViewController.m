//
//  HHRAdWebViewController.m
//  StartupViewApp
//
//  Created by dangwc on 2018/9/19.
//  Copyright © 2018年 dangwc. All rights reserved.
//

#import "HHRAdWebViewController.h"
#import <WebKit/WKWebView.h>
#define KISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))
#define navigation_height KISIphoneX ? 88 : 64

@interface HHRAdWebViewController ()

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progress;//进度条

@end

@implementation HHRAdWebViewController



-(WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }
    return _webView;
}



-(UIProgressView *)progress{
    if (!_progress) {
        
     
        _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, navigation_height, self.view.bounds.size.width, 2)];
        _progress.backgroundColor = [UIColor whiteColor];
        _progress.tintColor = [UIColor greenColor];
        _progress.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  mztNavigation];
    
    NSURLRequest *requeset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.link_url]];
    [self.webView loadRequest:requeset];

    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //重置导航栏颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}


-(void)mztNavigation{
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 44)];
    //    backBtn.backgroundColor = ColorRed;
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"Back1"] forState:UIControlStateNormal];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backItem setTintColor:[UIColor whiteColor]];
    
    
    UIButton *backBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    //    backBtn.backgroundColor = ColorRed;
    backBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn2 setImage:[UIImage imageNamed:@"nav_off"] forState:UIControlStateNormal];
    [backBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [backBtn2 setTitle:@"" forState:UIControlStateNormal];
    backBtn2.titleLabel.font = [UIFont systemFontOfSize:17];
    [backBtn2 addTarget:self action:@selector(goBackHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem2 = [[UIBarButtonItem alloc] initWithCustomView:backBtn2];
    [backItem2 setTintColor:[UIColor whiteColor]];
    
    
    
    self.navigationItem.leftBarButtonItems = @[backItem,backItem2];
    
}



//返回
-(void)goback{
    
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//返回上一个界面
-(void)goBackHome{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --- 监听进度操作
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"title"]) {
        
        if (object == self.webView) {
            NSString *naTitle = self.webView.title;
            if (naTitle.length > 10) {
                naTitle = [[naTitle substringToIndex:9] stringByAppendingString:@"…"];
            }
            self.title = naTitle;
            
        }else{
            
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.webView.estimatedProgress];
            
            if (self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }else{
            
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    
}







@end
