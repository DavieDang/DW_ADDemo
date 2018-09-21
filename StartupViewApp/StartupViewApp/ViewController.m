 //
//  ViewController.m
//  StartupViewApp
//
//  Created by dangwc on 2018/6/14.
//  Copyright © 2018年 dangwc. All rights reserved.
//

#import "ViewController.h"
#import "HHRAdView.h"
#import "HHRLaunchAdManager.h"
#import "HHRAdWebViewController.h"

//测试图片链接
//http://img.zcool.cn/community/01986958837303a801219c77d8057f.jpg@1280w_1l_2o_100sh.jpg
//http://pic1.win4000.com/mobile/7/57eb5dcc7c964.gif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"首页";
    
    HHRLaunchAdManager *margr = [HHRLaunchAdManager new];
    
    //参数配置
    margr.timeoutInterval = 3;
    margr.dayTimes = 400;
    
    //资源配置
    HHRAdModel *model = [HHRAdModel new];
    model.picture_url = @"http://pic1.win4000.com/mobile/7/57eb5dcc7c964.gif";
    model.type_str = @"gif";
    model.link_url = @"http://baidu.com";
    
    [margr LaunchAdManagerAddSubViewController:self sources:model timeOut:5];
}



@end
