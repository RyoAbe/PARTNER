//
//  UIUtil.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/01/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "UIUtil.h"
#import <CoreImage/CoreImage.h>
#import "PARTNER-Bridging-Header.h"

static NSString * const kGoogleChromeHTTPScheme = @"googlechrome:";
static NSString * const kGoogleChromeHTTPSScheme = @"googlechromes:";
static NSString * const kGoogleChromeCallbackScheme = @"googlechrome-x-callback:";

@implementation UIUtil

+ (void)openInEvernoteWithURL:(NSString*)url title:(NSString*)title
{
    NSString *clipURL = [NSString stringWithFormat:@"http://s.evernote.com/grclip?url=%@&title=%@",
                         encodeByAddingPercentEscapes(url), encodeByAddingPercentEscapes(title)];
    [UIUtil openInSafariOrChrome:[NSURL URLWithString:clipURL]];
}

+ (void)openInSafariOrChrome:(NSURL*)url
{
    if ([self isChromeInstalled]) {
        [self openInChrome:url];
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}

+ (UIImage *)createQRImageForString:(NSString *)string backgroundColor:(UIColor*)backgroundColor foregroundColor:(UIColor*)foregroundColor size:(CGSize)size
{
    CIImage *image;
    CIFilter *filter;
    CIFilter *filterColor;
    
    // Setup the QR filter with our string
    filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    image = [filter valueForKey:@"outputImage"];
    
    filterColor = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage", image, @"inputColor0", foregroundColor.CIColor, @"inputColor1", backgroundColor.CIColor, nil];
    //[filterColor setDefaults];
    
    image = [filterColor valueForKey:@"outputImage"];

    //image = [CIImage imageWithColor:[CIColor colorWithRed:1 green: 0 blue: 0]];
    
    // Calculate the size of the generated image and the scale for the desired image size
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));
    
    // Since CoreImage nicely interpolates, we need to create a bitmap image that we'll draw into
    // a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 256*4, cs, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);

    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);

    return [[UIImage alloc] initWithCGImage:scaledImage];
}

+ (BOOL)isSimulator
{
    return [[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"];
}

#pragma mark - Open In Chrome

/**
 *  Chromeで開く
 *
 *  @param url
 *  @see https://developers.google.com/chrome/mobile/docs/ios-links?hl=ja
 */
+ (void)openInChrome:(NSURL *)url
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *callbackURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [bundle infoDictionary][@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0], @"://"]];
    if (![url.scheme isEqualToString:@"http"] && ![url.scheme isEqualToString:@"https"]) {
        return;
    }
    NSString *chromeURLString = [NSString stringWithFormat:
                                 @"%@//x-callback-url/open/?x-source=%@&x-success=%@&url=%@",
                                 kGoogleChromeCallbackScheme,
                                 encodeByAddingPercentEscapes([bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]),
                                 encodeByAddingPercentEscapes(callbackURL.absoluteString),
                                 encodeByAddingPercentEscapes(url.absoluteString)];

    NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
    [[UIApplication sharedApplication] openURL:chromeURL];
}

static NSString * encodeByAddingPercentEscapes(NSString *input)
{
    NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                        kCFAllocatorDefault,
                                                        (CFStringRef)input,
                                                        NULL,
                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                        kCFStringEncodingUTF8));
    return encodedValue;
}


+ (BOOL)isChromeInstalled {
    NSURL *simpleURL = [NSURL URLWithString:kGoogleChromeHTTPScheme];
    NSURL *callbackURL = [NSURL URLWithString:kGoogleChromeCallbackScheme];
    return  [[UIApplication sharedApplication] canOpenURL:simpleURL] || [[UIApplication sharedApplication] canOpenURL:callbackURL];
}

@end
