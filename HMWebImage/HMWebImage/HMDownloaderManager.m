//
//  HMDownloaderManager.m
//  HMWebImage
//
//  Created by GD on 16/8/22.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import "HMDownloaderManager.h"
#import "HMDownloaderOperation.h"
#import "NSString+path.h"

@implementation HMDownloaderManager{

    NSOperationQueue *_queue;
    
    NSCache *_OPCache;
    
    //内存缓存
    NSCache *_imageMemCache;
}





+(instancetype)sharedManager{
    static HMDownloaderManager *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [HMDownloaderManager new];
    });
    
    return _instance;
}

-(instancetype)init{
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _OPCache = [[NSCache alloc] init];
        
        _imageMemCache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

-(void)clearCache{
    [_imageMemCache removeAllObjects];
    
    [_OPCache removeAllObjects];
    
    [_queue cancelAllOperations];
}

-(void)dealloc{//单例中无用   问题: 添加了三次,移除三次吗?
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)downLoadWithImageURL:(NSString *)imageURL finishBlock:(void (^)(UIImage *))finishBlock{
    //判断有无缓存
    if ([self checkCacheWithURLString:imageURL]) {
        if (finishBlock) {
            NSLog(@"缓存图片%@,    缓存key%@",[_imageMemCache objectForKey:imageURL],imageURL);
            finishBlock([_imageMemCache objectForKey:imageURL]);
        }
        
        return;
    }
    
    
    
    if ([_OPCache objectForKey:imageURL]) {
        return;
    }

    HMDownloaderOperation *op = [HMDownloaderOperation downLoadWithImageURL:imageURL finishBlock:^(UIImage *image) {//能回到执行此代码块,说明下载已经完成
        
        if (finishBlock) {
            finishBlock(image);
        }
        
        //实现内存缓存  可以用图片  直接实现内存缓存
        [_imageMemCache setObject:image forKey:imageURL];
        
        [_OPCache removeObjectForKey:imageURL];
        
    }];
    
    [_OPCache setObject:op forKey:imageURL];

    [_queue addOperation:op];

}

-(void)cancelWithLastURLString:(NSString *)lastURLString{
    HMDownloaderOperation *lastOP = [_OPCache objectForKey:lastURLString];
    
    
    if (lastOP ) {
        [lastOP cancel];
        
        [_OPCache removeObjectForKey:lastURLString];
    }
    
}


-(BOOL)checkCacheWithURLString:(NSString *)urlStr{

    //判断内存缓存
    if ([_imageMemCache objectForKey:urlStr]) {
        NSLog(@"从内存中加载.....");
//        [_imageMemCache objectForKey:urlStr];
        return YES;
    }
    
    //判断沙盒缓存
    UIImage *cacheImage = [UIImage imageWithContentsOfFile:[urlStr appendCachePath]];
    
    if (cacheImage) {
        NSLog(@"从沙盒中加载....");
        NSLog(@"%@     内存key%@",cacheImage,urlStr);
        [_imageMemCache setObject:cacheImage forKey:urlStr];
        
        return YES;
    }
    
    
    return NO;

}

@end
