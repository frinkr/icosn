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
#import "FRSizeWindowController.h"

@interface AppDelegate () {
    FRSizeWindowController * _sizeWindowController;
}
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
    if (!_sizeWindowController) {
        _sizeWindowController = [[FRSizeWindowController alloc] init];
    }

    for (NSString * filePath in dropFiles) {
        _sizeWindowController.imageFile = filePath;
        [self.window beginSheet:_sizeWindowController.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSModalResponseOK)
            {
                NSSize x3Size = _sizeWindowController.x3Size;
                NSArray * p = @[[NSValue valueWithSize:CGSizeMake(x3Size.width/3, x3Size.height/3)],
                                [NSValue valueWithSize:CGSizeMake(x3Size.width*2/3, x3Size.height*2/3)],
                                [NSValue valueWithSize:x3Size]];
                [self imageSetFromFile:filePath sizes:p];
            }
        }];
    }
}

#pragma mark - imageCreation
- (BOOL)imageSetFromFile:(NSString *)filePath sizes:(NSArray *)allSizes {
    NSImage * image = [[NSImage alloc] initWithContentsOfFile:filePath];
    if (!image.isValid) {
        [self alertCannotOpenFile:filePath];
        return FALSE;
    }

    NSString * fileExtension = [filePath pathExtension];
    NSString * fileNameBase = [[filePath lastPathComponent] stringByDeletingPathExtension];
    NSString * fileDirectory = [filePath stringByDeletingLastPathComponent];

    NSMutableArray * savedFilesURL = [[NSMutableArray alloc] init];
    
    [allSizes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        NSValue * value = (NSValue*)obj;
        CGSize size = [value sizeValue];
        NSImage * newImage = [FRImageHelper imageWithImage:image size:size];
        
        NSString * newFilePath = [NSString stringWithFormat:@"%@/%@@%dx%d.%@",
                                  fileDirectory,
                                  fileNameBase,
                                  (int)size.width,
                                  (int)size.height,
                                  fileExtension];
        [FRImageHelper saveImage:newImage toFile:newFilePath];
        
        [savedFilesURL addObject:[[NSURL alloc] initFileURLWithPath:newFilePath]];
    }];

    // Open the folder in Finder with files selected
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs: savedFilesURL];
    return TRUE;
}

#pragma mark - Alert

- (void)alertCannotOpenFile:(NSString *)file {
    [self alertWithMessage:file informativeText:[NSString stringWithFormat:@"Can not open file \"%@\"", file, nil]];
}

- (void)alertWithMessage:(NSString *)message
         informativeText:(NSString *)informativeText {

    NSAlert * alert = [[NSAlert alloc] init];
    alert.alertStyle = NSCriticalAlertStyle;
    alert.messageText = message;
    alert.informativeText = informativeText;
    [alert beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse returnCode){

    }];
}
@end
