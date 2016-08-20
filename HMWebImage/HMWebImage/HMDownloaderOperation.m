//
//  HMDownloaderOperation.m
//  HMWebImage
//
//  Created by GD on 16/8/20.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import "HMDownloaderOperation.h"

@interface HMDownloaderOperation ()

@property (copy,nonatomic) NSString *imageURL;

@property (copy,nonatomic) void(^finishiBlock)(UIImage *image);

@end

@implementation HMDownloaderOperation

-(void)main{

    
    NSURL *url = [NSURL URLWithString:self.imageURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    UIImage *image = [UIImage imageWithData:data];
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        self.finishiBlock(image);
//    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishiBlock(image);
    });

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
