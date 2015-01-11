//
//  FRImageHelper.m
//  iCosn
//
//  Created by Yuqing Jiang on 1/11/15.
//  Copyright (c) 2015 Yuqing Jiang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRImageHelper.h"

@implementation FRImageHelper

+ (NSImage *)imageWithImage:(NSImage *)image
                       size:(CGSize)newSize {
    CGSize sourceSize = image.size;

    NSImage * newImage = [[NSImage alloc] initWithSize:newSize];
    [newImage lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];

    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)
              fromRect:CGRectMake(0, 0, sourceSize.width, sourceSize.height)
             operation:NSCompositeCopy
              fraction:1
        respectFlipped:FALSE
                 hints:@{NSImageHintInterpolation : [NSNumber numberWithInt:NSImageInterpolationHigh]}];

    [newImage unlockFocus];
    return newImage;
}

+ (BOOL)saveImage:(NSImage *)image toFile:(NSString *)filePath {
    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[image size]];   // if you want the same resolution
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
    [pngData writeToFile:filePath atomically:YES];

    return TRUE;
}
@end
