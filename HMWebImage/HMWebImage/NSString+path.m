//
//  NSString+path.m
//  12-SD异步下载网络图片
//
//  Created by zhangjie on 16/8/18.
//  Copyright © 2016年 zhangjie. All rights reserved.
//

#import "NSString+path.h"
#import "NSString+Hash.h"

@implementation NSString (path)


- (NSString *)appendCachePath
{
    // 获取cache文件目录
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    // 获取文件名字
    NSString *name = [self md5String];
    
    // 路径拼接文件名
    NSString *filePath = [path stringByAppendingPathComponent:name];
    
    return filePath;
}

@end
