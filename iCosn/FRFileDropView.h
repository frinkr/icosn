//
//  FRFileDropView.h
//  iCosn
//
//  Created by Yuqing Jiang on 1/11/15.
//  Copyright (c) 2015 Yuqing Jiang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class FRFileDropView;

@protocol FRFileDropViewDelegate <NSObject>

@optional
- (void)fileDropView:(FRFileDropView *)fileDropView
        didDropFiles:(NSArray *)files;

@end

@interface FRFileDropView : NSView <NSDraggingDestination>


@property (weak, nonatomic) IBOutlet id<FRFileDropViewDelegate> delegate;
@end
