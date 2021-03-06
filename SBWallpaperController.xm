#import <substrate.h>

#import "PNBlurController.h"
#import "Private.h"
#import "Logging.h"

%hook SBWallpaperController

- (BOOL)variantsShareWallpaper {

    if (![[PNBlurController sharedInstance] shouldHook] || 
        [[PNBlurController sharedInstance] variantsShareBlur])
        return %orig;

    return NO;

}

- (void)_updateSharedWallpaper {

    %orig;

    if (![[PNBlurController sharedInstance] shouldHook])
        return;

    SBFWallpaperView * _sharedWallpaperView = MSHookIvar<SBFWallpaperView *>(self, "_sharedWallpaperView");

    [[PNBlurController sharedInstance] applyBackdropToWallpaperView:_sharedWallpaperView forVariant:kVariantLockscreen];

}

- (void)_updateSeparateWallpaper {

    %orig;

    if (![[PNBlurController sharedInstance] shouldHook])
        return;

    if ([PNBlurController sharedInstance].settings.BlurLockscreen) {
        SBFWallpaperView * _lockscreenWallpaperView = MSHookIvar<SBFWallpaperView *>(self, "_lockscreenWallpaperView");
        [[PNBlurController sharedInstance] applyBackdropToWallpaperView:_lockscreenWallpaperView forVariant:kVariantLockscreen];
    }

    if ([PNBlurController sharedInstance].settings.BlurHomescreen) {
        SBFWallpaperView * _homescreenWallpaperView = MSHookIvar<SBFWallpaperView *>(self, "_homescreenWallpaperView");
        [[PNBlurController sharedInstance] applyBackdropToWallpaperView:_homescreenWallpaperView forVariant:kVariantHomescreen];
    }

}

- (BOOL)_shouldSuspendMotionEffectsForState:(unsigned int)state {

    if ([PNBlurController sharedInstance].settings.ParallaxEnabled || ![[PNBlurController sharedInstance] shouldHook])
        return %orig;

    return YES;

}

%end
