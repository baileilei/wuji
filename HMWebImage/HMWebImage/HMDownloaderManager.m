//
//  HMDownloaderManager.m
//  HMWebImage
//
//  Created by GD on 16/8/22.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import "HMDownloaderManager.h"
#import "HMDownloaderOperation.h"

@implementation HMDownloaderManager{

    NSOperationQueue *_queue;
    
    NSMutableDictionary *_OPCache;
}


-(void)cancelWithLastURLString:(NSString *)lastURLString{
    HMDownloaderOperation *lastOP = [_OPCache objectForKey:lastURLString];


    if (lastOP ) {
        [lastOP cancel];
        
        [_OPCache removeObjectForKey:lastURLString];
    }

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
        _OPCache = [NSMutableDictionary dictionary];
    }
    return self;
}


-(void)downLoadWithImageURL:(NSString *)imageURL finishBlock:(void (^)(UIImage *))finishBlock{
    
    if ([_OPCache objectForKey:imageURL]) {
        return;
    }

    HMDownloaderOperation *op = [HMDownloaderOperation downLoadWithImageURL:imageURL finishBlock:^(UIImage *image) {//能回到执行此代码块,说明下载已经完成
        
        if (finishBlock) {
            finishBlock(image);
        }
        
        [_OPCache removeObjectForKey:imageURL];
        
    }];
    
    [_OPCache setObject:op forKey:imageURL];

    [_queue addOperation:op];

}

@end
