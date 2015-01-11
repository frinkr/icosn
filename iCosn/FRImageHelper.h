//
//  FRImageHelper.h
//  iCosn
//
//  Created by Yuqing Jiang on 1/11/15.
//  Copyright (c) 2015 Yuqing Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRImageHelper : NSObject
+ (NSImage *)imageWithImage:(NSImage *)image
                       size:(CGSize)newSize;

+(BOOL)saveImage:(NSImage*)image
          toFile:(NSString*)filePath;
@end
