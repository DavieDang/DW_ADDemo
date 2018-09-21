//
//  HHRAdModel.h
//  StartupViewApp
//
//  Created by dangwc on 2018/9/19.
//  Copyright © 2018年 dangwc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHRAdModel : NSObject


/**
 作为类型判断的字段（默认是以链接结尾字段作为类型字段的区分）目前只支持图片和gif图片的资源
 */
@property (nonatomic,copy) NSString *type_str;

/**
 广告资源的链接
 */
@property (nonatomic,copy) NSString *picture_url;

/**
 广告详情的链接
 */
@property (nonatomic,copy) NSString *link_url;



@end
