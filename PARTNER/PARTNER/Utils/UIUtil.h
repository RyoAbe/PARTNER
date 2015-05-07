//
//  UIUtil.h
//  RandomPocket
//
//  Created by RyoAbe on 2014/01/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIUtil : NSObject
+ (void)openInEvernoteWithURL:(NSString*)url title:(NSString*)title;
+ (void)openInSafariOrChrome:(NSURL*)url;
+ (void)openInChrome:(NSURL*)url;
+ (UIImage *)createQRImageForString:(NSString *)string backgroundColor:(UIColor*)backgroundColor foregroundColor:(UIColor*)foregroundColor size:(CGSize)size;
+ (BOOL)isSimulator;
+ (BOOL)is4s;
@end
