//
//  KGTextMessageCell.m
//  group
//
//  Created by Igor Vedeneev on 20.11.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTextMessageCell.h"

@interface KGTextMessageCell ()
@property (assign) CGFloat maxWidth;

@end

@implementation KGTextMessageCell


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.backgroundColor = [NSColor lightGrayColor];
    self.textView.superview.superview.layer.backgroundColor = [NSColor redColor].CGColor;
    self.textView.font = [NSFont fontWithName:@"Helvetica Neue" size:16.0];
    
    [self.textView.superview.superview setAutoresizingMask:NSViewNotSizable];
    [self.textView.superview.superview setTranslatesAutoresizingMaskIntoConstraints:YES];
}

- (void)configureWithString:(NSString *)string width:(CGFloat)width {
//    NSLog(@"%f", width);
    self.textView.string = string;
    
//    CGRect rect = __rectForString(string, width);
//    CGFloat w = CGRectGetWidth(rect);
//    CGFloat h = CGRectGetHeight(rect);
//    self.textView.superview.superview.frame = CGRectMake(100.0, 10.0, w, h);
}

CGRect __rectForString(NSString *string, CGFloat width) {
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:16.0];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:size];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:font
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    
    [layoutManager glyphRangeForTextContainer:textContainer];
    
    size.height = [layoutManager usedRectForTextContainer:textContainer].size.height;
    
    return CGRectMake(0, 0, size.width, size.height);
}


@end
