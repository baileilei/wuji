//
//  NSString+path.h
//  12-SD异步下载网络图片
//
//  Created by zhangjie on 16/8/18.
//  Copyright © 2016年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (path)

/// 获取cache文件缓存路径
- (NSString *)appendCachePath;

@end
