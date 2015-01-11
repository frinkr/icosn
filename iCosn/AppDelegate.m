//
//  AppDelegate.m
//  iCosn
//
//  Created by Yuqing Jiang on 1/11/15.
//  Copyright (c) 2015 Yuqing Jiang. All rights reserved.
//

#import "AppDelegate.h"
#import "FRFileDropView.h"
#import "FRImageHelper.h"

@interface AppDelegate ()
@property (weak) IBOutlet FRFileDropView * iosAppView;
@property (weak) IBOutlet FRFileDropView * macAppView;
@property (weak) IBOutlet FRFileDropView * imageView;

@property (weak) IBOutlet NSWindow * window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - FRFileDropViewDelegate
- (void)fileDropView:(FRFileDropView *)fileDropView didDropFiles:(NSArray *)files {
    if (fileDropView == self.iosAppView)
        [self handleIOSViewDropFiles:files];
    if (fileDropView == self.macAppView)
        [self handleMacViewDropFiles:files];
    else if (fileDropView == self.imageView)
        [self handleImageViewDropFiles:files];
    else
        NSLog(@"Not able to handle drop: %@", files);
}

#pragma mark - Private
- (void)handleIOSViewDropFiles:(NSArray *)dropFiles {
    NSUInteger allSizes[] = {29, 40, 58, 76, 80, 87, 120, 152, 180};

    NSMutableArray * p = [NSMutableArray new];
    for (size_t i = 0; i < sizeof(allSizes) / sizeof(allSizes[0]); ++i) {
        [p addObject:[NSValue valueWithSize:CGSizeMake(allSizes[i], allSizes[i])]];
    }
    
    for (NSString * filePath in dropFiles) {
        [self imageSetFromFile:filePath sizes:p];
    }
}

- (void)handleMacViewDropFiles:(NSArray *)dropFiles {
    NSUInteger allSizes[] = {16, 32, 64, 128, 256, 512, 1024};
    
    NSMutableArray * p = [NSMutableArray new];
    for (size_t i = 0; i < sizeof(allSizes) / sizeof(allSizes[0]); ++i) {
        [p addObject:[NSValue valueWithSize:CGSizeMake(allSizes[i], allSizes[i])]];
    }
    
    for (NSString * filePath in dropFiles) {
        [self imageSetFromFile:filePath sizes:p];
    }
}

- (void)handleImageViewDropFiles:(NSArray *)dropFiles {
    
}

#pragma mark - imageCreation
- (BOOL)imageSetFromFile:(NSString*) filePath sizes:(NSArray *)allSizes {
    NSImage * image = [[NSImage alloc] initWithContentsOfFile:filePath];
    if (!image.isValid) {
        [self alertCannotOpenFile:filePath fromView:self.iosAppView];
        return FALSE;
    }
    
    NSString * fileExtension = [filePath pathExtension];
    NSString * fileNameBase = [[filePath lastPathComponent] stringByDeletingPathExtension];
    NSString * fileDirectory = [filePath stringByDeletingLastPathComponent];
    
    [allSizes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSValue * value = (NSValue*)obj;
        CGSize size = [value sizeValue];
        NSImage * newImage = [FRImageHelper imageWithImage:image size:size];
        
        [FRImageHelper saveImage:newImage toFile:[NSString stringWithFormat:@"%@/%@@%dx%d.%@",
                                                  fileDirectory,
                                                  fileNameBase,
                                                  (int)size.width,
                                                  (int)size.height,
                                                  fileExtension]];
    }];
    
    return TRUE;
}

#pragma mark - Alert

- (void)alertCannotOpenFile:(NSString *)file fromView:(NSView *)view {
    [self alertFromView:view message:file informativeText:[NSString stringWithFormat:@"Can not open file \"%@\"", file, nil]];
}

- (void)alertFromView:(NSView *)view
              message:(NSString *)message
      informativeText:(NSString *)informativeText {

    NSAlert * alert = [[NSAlert alloc] init];
    alert.alertStyle = NSCriticalAlertStyle;
    alert.messageText = message;
    alert.informativeText = informativeText;
    [alert beginSheetModalForWindow:[view window] completionHandler:^(NSModalResponse returnCode){

    }];
}
@end
