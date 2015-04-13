//
//  MRProgressOverlayView+RyoAbe.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/12/21.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "MRProgressOverlayView+RyoAbe.h"

typedef NS_ENUM(NSUInteger, PartnerViewTag) {
    PartnerViewTag_MRProgressOverlayView = 9000,
};

@implementation MRProgressOverlayView (RyoAbe)

+ (instancetype)show
{
    return [self showWithTitle:@"" mode:MRProgressOverlayViewModeIndeterminate];
}

+ (instancetype)showWithTitle:(NSString*)title
{
    return [self showWithTitle:title mode:MRProgressOverlayViewModeIndeterminate];
}

+ (instancetype)showWithTitle:(NSString*)title mode:(MRProgressOverlayViewMode)mode
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if([window viewWithTag:PartnerViewTag_MRProgressOverlayView]){
        [[window viewWithTag:PartnerViewTag_MRProgressOverlayView] removeFromSuperview];
    }
    MRProgressOverlayView *view = [self new];
    view.tintColor = [UIColor blackColor];
    view.tag = PartnerViewTag_MRProgressOverlayView;
    view.mode = mode;
    if(title){
        view.titleLabelText = title;
    }
    [window addSubview:view];
    [view show:YES];
    return view;
}

- (void)hide
{
    [self dismiss:YES];
}

+ (void)hide
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    MRProgressOverlayView *view = (MRProgressOverlayView*)[window viewWithTag:PartnerViewTag_MRProgressOverlayView];
    [view hide];
}

@end
