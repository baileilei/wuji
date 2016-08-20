//
//  HMDownloaderOperation.h
//  HMWebImage
//
//  Created by GD on 16/8/20.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HMDownloaderOperation : NSOperation

+(instancetype)downLoadWithImageURL:(NSString *)imageURL finishBlock:(void(^)(UIImage *image))finishBlock;

@end
