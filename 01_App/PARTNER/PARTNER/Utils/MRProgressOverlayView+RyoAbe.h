//
//  MRProgressOverlayView+RyoAbe.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/12/21.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <MRProgress/MRProgress.h>

@interface MRProgressOverlayView (RyoAbe)
+ (instancetype)show;
+ (instancetype)showWithTitle:(NSString*)title;
+ (instancetype)showWithTitle:(NSString*)title mode:(MRProgressOverlayViewMode)mode;
- (void)hide;
+ (void)hide;
@end
