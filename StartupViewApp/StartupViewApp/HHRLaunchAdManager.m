//
//  HHRLaunchAdManager.m
//  StartupViewApp
//
//  Created by dangwc on 2018/6/14.
//  Copyright © 2018年 dangwc. All rights reserved.
//

#import "HHRLaunchAdManager.h"
#import "UIImage+GIF.h"
#import "HHRAdWebViewController.h"


typedef void(^CompletionBlock)(HHRADPictureType type,id data);

@interface HHRLaunchAdManager()<NSURLSessionDownloadDelegate>

/**
 广告视图
 */
@property (nonatomic,strong) HHRAdView *adView;


/**
 广告数据model
 */
@property (nonatomic,strong) HHRAdModel *adModel;

/**
 资源链接的资源最好不要超过1M
 这里的默认规则是：如果是gif图片链接请以gif作为结尾比如(http://xxxxx.gif)这里以.gif作为图片类型的区分
 */
@property (nonatomic,copy) NSString *pictureUrl;


/**
 资源下载完的回调
 */
@property (nonatomic,copy) CompletionBlock completionBlock;




@end

@implementation HHRLaunchAdManager



-(void)LaunchAdManagerAddSubViewController:(UIViewController *)viewController sources:(HHRAdModel *)sourcesModel timeOut:(NSInteger)timeOut{
    self.adModel = sourcesModel;
    if([self saveTimes]){
        self.adView = [[HHRAdView alloc] initWithDownTime:timeOut];
        _adView.frame = viewController.view.bounds;
        _pictureUrl = sourcesModel.picture_url;
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        // 添加到窗口
        [window addSubview:_adView];
    
        //广告跳转
        _adView.clickEvent = ^{
            HHRAdWebViewController *webvc = [HHRAdWebViewController new];
            webvc.link_url = sourcesModel.link_url;
            [viewController.navigationController pushViewController:webvc animated:YES];
        };
        
        [self loadData];
        
    }else{
        //不作处理
        return;
    }
}



//启动次数处理
-(BOOL)saveTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSString *launchDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"LaunchDate"];
    
    
    if (![launchDate isEqualToString:dateTime]) {
         [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LaunchTimes"];
    }
    NSInteger timesNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"LaunchTimes"];
 
    
    if (timesNum < self.dayTimes) {
        timesNum ++;
        [[NSUserDefaults standardUserDefaults] setInteger:timesNum forKey:@"LaunchTimes"];
        [[NSUserDefaults standardUserDefaults] setValue:dateTime forKey:@"LaunchDate"];
        return YES;
        
    }else{
        return NO;
    }
}


//数据加载类
-(void)loadData{
    
    //设置默认数据
    if (self.timeoutInterval == 0) {
        self.timeoutInterval = 5.0;
    }
    
     if (self.dayTimes == 0) {
        self.dayTimes = 99999;
     };
    NSString *imagePath = self.pictureUrl;
    
    //如果数据为空则去掉广告页显示
    if (!imagePath) {
        [self.adView dismissADView];
    }
    
    __weak typeof(self) weakSelf = self;
    [self imageDataWihtUrl:imagePath callback:^(HHRADPictureType type, id data) {
        if ([data isKindOfClass:[NSData class]]) {
            
            if (type == HHRADPictureGIF) {
                UIImage *image = [UIImage sd_animatedGIFWithData:data];
                weakSelf.adView.adImageView.image = image;
                
            }else{
                weakSelf.adView.adImageView.image = [UIImage imageWithData:data];
            }
        }else if([data isKindOfClass:[NSString class]]){
            
            [self loadDownPictureSourceWithUrl:data callback:^(HHRADPictureType type, id data) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (type == HHRADPictureGIF) {
                        UIImage *image = [UIImage sd_animatedGIFWithData:data];
                        weakSelf.adView.adImageView.image = image;
                    }else{
                        weakSelf.adView.adImageView.image = [UIImage imageWithData:data];
                    }
                });
            }];
        }else{
            //后续补充其他类型
        }
    }];
}


/**
 缓存路径
 @param imagePath 图片链接
 @return 图片路径
 */
-(NSString *)filePathWihtImagePath:(NSString *)imagePath{
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [cachePath stringByAppendingPathComponent:[self fileNameForPath:imagePath]];
    return filePath;
    
}


/**
 图片数据获取
 */
-(void)imageDataWihtUrl:(NSString *)imageUrl callback:(void(^)(HHRADPictureType type,id data))callback{
    
    NSString *filePath = [self filePathWihtImagePath:imageUrl];
    HHRADPictureType type_p = HHRADPictureJPG;
    
    //如果指定资源文件类型（推荐使用）
    if (_adModel.type_str) {
        
        if ([_adModel.type_str containsString:@"gif"] || [_adModel.type_str containsString:@"GIF"]) {
            type_p = HHRADPictureGIF;
        }
        
    }else{
        
        //否则按默认的类型判断（链接不是文件类型结尾的可能会出现显示bug）
        if ([filePath hasSuffix:@"gif"] || [filePath hasSuffix:@"GIF"]) {
            type_p = HHRADPictureGIF;
        }
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        //如果存在则加载缓存数据
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        callback(type_p,imageData);
        
    }else{
        //否则加载网络数据
        callback(type_p,imageUrl);
    }
}


//格式化文件名
-(NSString *)fileNameForPath:(NSString *)path{
    
    NSString *str1 = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];//去掉/
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"//" withString:@""];//去掉/
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉空格
    NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@":" withString:@""];//:
    
    return str4;
    
}





/**
 开启图片下载操作

 @param api 图片资源链接
 @param callback 操作数据返回
 */
-(void)loadDownPictureSourceWithUrl:(NSString *)api callback:(CompletionBlock)callback{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:api] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    //开始任务
    [task resume];
    //完成回调
    _completionBlock = callback;
    
}

#pragma mark --- NSURLSessionDownloadDelegate

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
     //下载完成
   BOOL isSeccess =   [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:[self filePathWihtImagePath:self.pictureUrl] error:nil];
    if (isSeccess) {
        NSLog(@"广告页已缓存");
        __weak typeof(self) weakSelf = self;
        [self imageDataWihtUrl:self.pictureUrl callback:^(HHRADPictureType type, id data) {
             weakSelf.completionBlock(type,data);
        }];
       
    }else{
         NSLog(@"广告页缓存出现问题请排查");
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    //显示下载进度（暂不需要）
//   NSLog(@"下载进度：%f",1.0*totalBytesWritten/totalBytesExpectedToWrite);
    
}


-(void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
   //下载出错（退出广告界面）
    if (error) {
        NSLog(@"资源下载出错：%ld",[error code]);
        [self.adView dismissADView];
    }
}








@end
