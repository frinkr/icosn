//
//  FRSizeWindowController.m
//  iCosn
//
//  Created by Yuqing Jiang on 1/11/15.
//  Copyright (c) 2015 Yuqing Jiang. All rights reserved.
//

#import "FRSizeWindowController.h"

@interface FRSizeWindowController ()
{
    NSWindow * _window;
}
- (IBAction)onCancelButtonPressed:(id)sender;
- (IBAction)onOkButtonPressed:(id)sender;
@end

@implementation FRSizeWindowController

- (instancetype)init {
    self = [super initWithWindowNibName:NSStringFromClass([self class])
                                  owner:self];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

//method to remove the myownwindow
- (void)endSheetWithCode:(NSUInteger) code {
    [[[self window] sheetParent] endSheet:[self window] returnCode:code];
}

- (IBAction)onCancelButtonPressed:(id)sender {
    [self endSheetWithCode:NSModalResponseCancel];
}

- (IBAction)onOkButtonPressed:(id)sender {
    [self endSheetWithCode:NSModalResponseOK];
}
@end
