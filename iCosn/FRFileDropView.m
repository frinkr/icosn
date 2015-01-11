//
//  FRFileDropView.m
//  iCosn
//
//  Created by Yuqing Jiang on 1/11/15.
//  Copyright (c) 2015 Yuqing Jiang. All rights reserved.
//

#import "FRFileDropView.h"

@implementation FRFileDropView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationEvery;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSArray * dropFiles = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];

    if ([self.delegate respondsToSelector:@selector(fileDropView:didDropFiles:)]) {
        [self.delegate fileDropView:self didDropFiles:dropFiles];
        return TRUE;
    }
    return FALSE;
}

@end
