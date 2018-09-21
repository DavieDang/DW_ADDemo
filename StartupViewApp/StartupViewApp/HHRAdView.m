//
//  HHRAdView.m
//  StartupViewApp
//
//  Created by dangwc on 2018/6/15.
//  Copyright © 2018年 dangwc. All rights reserved.
//

#import "HHRAdView.h"

@interface HHRAdView()
@property (nonatomic,strong) UIButton *skipBtn;
@property (nonatomic,strong) dispatch_source_t ad_timer;

@end

@implementation HHRAdView


-(UIImageView *)adImageView{
    if (!_adImageView) {
        _adImageView = [UIImageView new];
        _adImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _adImageView;
}



-(instancetype)initWithDownTime:(NSInteger)downTime{
    if (self = [super init]) {
        _downTime = downTime;
        [self setupUI];
    }
    return self;
}




-(void)setupUI{
    
    
    //广告图片
    self.adImageView = [[UIImageView alloc] init];
    _adImageView .userInteractionEnabled = YES;
    _adImageView.backgroundColor = [UIColor grayColor];
    _adImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self addSubview:_adImageView];
    

    
    //添加广告页链接动作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkEvent)];
    [_adImageView addGestureRecognizer:tap];

    
    //跳转按钮
    self.skipBtn = [UIButton buttonWithType:0];
    _skipBtn.layer.cornerRadius = 20;
    [_skipBtn setTitleColor:[UIColor whiteColor] forState:0];
    _skipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _skipBtn.backgroundColor = [UIColor colorWithRed:105/255 green:105/255 blue:105/255 alpha:0.7];
    _skipBtn.frame = CGRectMake(ScreenWidth-100, 65, 75, 40);
    [_skipBtn addTarget:self action:@selector(skipEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_adImageView addSubview:_skipBtn];
    [self countDownTime:_downTime];
}


/**
 设置倒计时
 @param timeLine 倒计时时间
 */
-(void)countDownTime:(NSInteger)timeLine{
    
    __block int timeOut = (int)timeLine;
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.ad_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_ad_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_ad_timer, ^{
        if (timeOut <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissADView];
            });
        }else{
           //显示秒数
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.skipBtn setTitle:[NSString stringWithFormat:@"%ldS 跳过",(long)timeOut] forState:0];
            });
            timeOut--;
        }
    });
    dispatch_resume(_ad_timer);
}




/**
 跳转链接
 */
-(void)linkEvent{
    
    [self dismissADView];
    
    if(self.clickEvent){
        
        self.clickEvent();
    }
}

-(void)skipEvent:(UIButton *)sender{

    [self dismissADView];
    
    
}



-(void)dismissADView{
    //清除计时器和视图
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.alpha = 0.0;
        } completion:^(BOOL finished) {
            dispatch_cancel(weakSelf.ad_timer);
            [weakSelf removeFromSuperview];
        }];
    });
    
}


- (UIViewController*)viewController{
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            
            return (UIViewController*)nextResponder;
            
        }
    }
    
    return nil;
}






@end
