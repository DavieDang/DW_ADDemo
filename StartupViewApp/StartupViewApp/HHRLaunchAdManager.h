//
//  HHRLaunchAdManager.h
//  StartupViewApp
//
//  Created by dangwc on 2018/6/14.
//  Copyright © 2018年 dangwc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHRAdView.h"
#import <UIKit/UIKit.h>
#import "HHRAdModel.h"

@interface HHRLaunchAdManager : NSObject


/**
 每天显示多少次 默认显示99999次;
 */
@property (nonatomic,assign) NSInteger dayTimes;

/**
 网络请求的超时时间（在超时时间内，未获取资源，则不予显示广告,默认超时时间5s）
 */
@property (nonatomic,assign) double timeoutInterval;



-(void)LaunchAdManagerAddSubViewController:(UIViewController *)viewController sources:(HHRAdModel *)sourcesModel timeOut:(NSInteger)timeOut;


@end
