//
//  HHRAdView.h
//  StartupViewApp
//
//  Created by dangwc on 2018/6/15.
//  Copyright © 2018年 dangwc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define  ScreenHeight  [UIScreen mainScreen].bounds.size.height
typedef NS_ENUM(NSUInteger, HHRADPictureType) {
    HHRADPictureJPG,
    HHRADPictureGIF,
};

typedef void(^ClickLinkEvent)();

@interface HHRAdView : UIView


@property (nonatomic,assign) NSInteger downTime;//倒计时
@property (nonatomic,strong) UIImageView *adImageView;

@property (nonatomic,copy) ClickLinkEvent clickEvent;

-(instancetype)initWithDownTime:(NSInteger)downTime;

-(void)dismissADView;

@end
