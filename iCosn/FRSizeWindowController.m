//
//  FRSizeWindowController.m
//  iCosn
//
//  Created by Yuqing Jiang on 1/11/15.
//  Copyright (c) 2015 Yuqing Jiang. All rights reserved.
//

#import "FRSizeWindowController.h"

@interface FRSizeWindowController () <NSTextFieldDelegate> {
    NSWindow * _window;
    NSSize _imageSize;
}
@property (weak) IBOutlet NSTextField * fileNameLabel;
@property (weak) IBOutlet NSTextField * x3Width;
@property (weak) IBOutlet NSTextField * x3Height;
@property (weak) IBOutlet NSTextField * x2Width;
@property (weak) IBOutlet NSTextField * x2Height;
@property (weak) IBOutlet NSTextField * x1Width;
@property (weak) IBOutlet NSTextField * x1Height;
@property (weak) IBOutlet NSButton * aspectButton;
@property (weak) IBOutlet NSButton * okButton;

- (IBAction)onCancelButtonPressed:(id)sender;
- (IBAction)onOkButtonPressed:(id)sender;
- (IBAction)onAspectButtonPressed:(id)sender;
@end

@implementation FRSizeWindowController

- (instancetype)init {
    self = [super initWithWindowNibName:NSStringFromClass([self class])
                                  owner:self];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self setupImageFile];
}

- (void)endSheetWithCode:(NSUInteger)code {
    [[[self window] sheetParent] endSheet:[self window] returnCode:code];
}

- (void)setImageFile:(NSString *)imageFile {
    _imageFile = imageFile;
    [self setupImageFile];
}

- (NSSize)x3Size {
    return CGSizeMake([self valueFromTextField:self.x3Width],
                      [self valueFromTextField:self.x3Height]);
}

#pragma mark - Actions
- (IBAction)onCancelButtonPressed:(id)sender {
    [self endSheetWithCode:NSModalResponseCancel];
}

- (IBAction)onOkButtonPressed:(id)sender {
    [self endSheetWithCode:NSModalResponseOK];
}

- (IBAction)onAspectButtonPressed:(id)sender {
    BOOL keepAspect = self.aspectButton.state == NSOnState;
    if (keepAspect) {
        if ([self isTextFieldInFocus:self.x3Width])
            [self onX3TextFieldChanged:self.x3Width];
        else if ([self isTextFieldInFocus:self.x3Height])
            [self onX3TextFieldChanged:self.x3Height];
    }
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj {
    NSTextField * textField = obj.object;
    [self onX3TextFieldChanged:textField];
}

#pragma mark - Private

- (BOOL)isTextFieldInFocus:(NSTextField *)textField {
    BOOL inFocus = NO;

    inFocus = ([[[textField window] firstResponder] isKindOfClass:[NSTextView class]] && [[textField window] fieldEditor:NO forObject:nil] != nil && [textField isEqualTo:(id)[(NSTextView *)[[textField window] firstResponder] delegate]]);

    return inFocus;
}

- (void)onX3TextFieldChanged:(NSTextField *)textField {
    BOOL keepAspect = self.aspectButton.state == NSOnState;
    if (keepAspect) {
        if (textField == self.x3Width) {
            [self setValue:_imageSize.height / _imageSize.width * [self valueFromTextField:textField]
                forTextField:self.x3Height];
        } else if (textField == self.x3Height) {
            [self setValue:_imageSize.width / _imageSize.height * [self valueFromTextField:textField]
                forTextField:self.x3Width];
        }
    }

    [self updateX2X1FromX3];
}

- (void)setupImageFile {
    if (self.imageFile) {
        [self.fileNameLabel setStringValue:[self.imageFile lastPathComponent]];
        NSImage * image = [[NSImage alloc] initWithContentsOfFile:_imageFile];
        if (image.isValid) {
            _imageSize = image.size;
            [self setValue:_imageSize.width forTextField:self.x3Width];
            [self setValue:_imageSize.height forTextField:self.x3Height];

            [self updateX2X1FromX3];
        } else {
            [self.okButton setEnabled:NO];
        }
    } else {
        [self.fileNameLabel setStringValue:@""];
        [self.x3Width setStringValue:[@1 stringValue]];
    }
}

- (void)setValue:(CGFloat)value forTextField:(NSTextField *)textField {
    textField.stringValue = [NSString stringWithFormat:@"%ld", (NSInteger)(value + 0.5)];
}

- (CGFloat)valueFromTextField:(NSTextField *)textField {
    return textField.stringValue.floatValue;
}

- (void)updateX2X1FromX3 {
    [self.okButton setEnabled:YES];

    // Width
    if (self.x3Width.stringValue.length) {
        CGFloat width = [self valueFromTextField:self.x3Width];
        [self setValue:width * 2 / 3.0f forTextField:self.x2Width];
        [self setValue:width / 3.0f forTextField:self.x1Width];
    } else {
        self.x2Width.stringValue = @"";
        self.x1Width.stringValue = @"";
        [self.okButton setEnabled:NO];
    }

    // Height
    if (self.x3Height.stringValue.length) {
        CGFloat height = [self valueFromTextField:self.x3Height];
        [self setValue:height * 2 / 3.0f forTextField:self.x2Height];
        [self setValue:height / 3.0f forTextField:self.x1Height];
    } else {
        self.x2Height.stringValue = @"";
        self.x1Height.stringValue = @"";
        [self.okButton setEnabled:NO];
    }
}

@end
