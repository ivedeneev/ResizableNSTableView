//
//  KGTextMessageCell.h
//  group
//
//  Created by Igor Vedeneev on 20.11.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KGTextMessageCell : NSTableCellView
- (void)configureWithString:(NSString *)string width:(CGFloat)width;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@end
