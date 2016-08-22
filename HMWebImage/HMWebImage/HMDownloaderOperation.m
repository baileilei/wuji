//
//  HMDownloaderOperation.m
//  HMWebImage
//
//  Created by GD on 16/8/20.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import "HMDownloaderOperation.h"
#import "NSString+path.h"

@interface HMDownloaderOperation ()

@property (copy,nonatomic) NSString *imageURL;

@property (copy,nonatomic) void(^finishiBlock)(UIImage *image);

@end

@implementation HMDownloaderOperation

-(void)main{

    NSLog(@"传入 %@",self.imageURL);
    
    [NSThread sleepForTimeInterval:1.0];
    
    NSURL *url = [NSURL URLWithString:self.imageURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    UIImage *image = [UIImage imageWithData:data];
    
    
    
    
    
    if (self.isCancelled) {//  其实,实质该请求已经发出去了.  也有数据返回. 只是该图片不刷新了.
        NSLog(@"取消 %@",self.imageURL);
        
        return;
    }
    
    
    //实现沙盒缓存
    if (image != nil) {
        [data writeToFile:[self.imageURL appendCachePath] atomically:YES];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"完成 %@" , self.imageURL);
        self.finishiBlock(image);
    }];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"完成" , self.imageURL);
//        self.finishiBlock(image);
//    });

}


+(instancetype)downLoadWithImageURL:(NSString *)imageURL finishBlock:(void (^)(UIImage *))finishBlock{


    HMDownloaderOperation *op = [[self alloc] init];
    
    op.imageURL = imageURL;
    
    if (finishBlock) {
        
        op.finishiBlock = finishBlock;
    }
    
    
    return op;
}



@end
