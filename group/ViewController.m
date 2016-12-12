//
//  ViewController.m
//  group
//
//  Created by Igor Vedeneev on 20.11.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "ViewController.h"
#import "KGTextMessageCell.h"

static CGFloat const kMaxWidthMultiplier = 0.5;


@interface ViewController () {

}
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, assign) CGFloat scrWidth;
@property (nonatomic, strong) NSArray *strings;

@end

@implementation ViewController {
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _cache = [NSMutableDictionary dictionary];
        _strings = @[@"I am releasing this under MIT license as usual. Use it however you want as long as you give me credit somewhere. Please send in any feedback, suggestions, bugs, etc but keep in mind that this is not something I use in my projects so I probably will not be actively maintaining it beyond a certain point. I’ve made a point of making the the API easy to use and to extend so have fun with it.",
                     @"Это что? где? когда? или кто? где? куда? варварски говорит про змею которую собираются готовить и кушать бред какой та да еще такую версию дает Козлов которую даже маленький ребенок догадается и сможет показать а вот что она живая в этом и заключается вопрос из двух версий логично надо было выбрать про живую какой кошмар!!!!!!﻿", @"In OS X version 10.7 table views have been redesigned and now support using views as individual cells. These are referred to as view-based table views. View-based table views allow you to design custom cells in the Interface Builder portion of Xcode 4.0. It allows easy design time layout as well as making it easy to animate changes and customize drawing. As with cell-based table views, view-based table views support selection, column dragging, and other user-expected table view behavior. The only difference is that the developer is given much more flexibility in design and implementation.",
                     @"Lil text VIrtus pro gogogogoggo"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"viewdidload %f", CGRectGetWidth(self.tableView.superview.superview.frame));
    _tableView.dataSource = self;
    _tableView.floatsGroupRows = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(test:)
                                                 name:NSViewFrameDidChangeNotification
                                               object:self.tableView];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    NSLog(@"viewdidapper %f", CGRectGetWidth(self.tableView.superview.superview.frame));
    NSLog(@"viewdidapper %f", CGRectGetWidth(self.view.superview.superview.frame));
}

- (void)test:(NSNotification *)not {
//    [self.tableView reloadData];
    NSScrollView *scrView = self.tableView.enclosingScrollView;
    self.scrWidth = CGRectGetWidth(scrView.contentView.bounds);
    NSRange visRows = [self.tableView rowsInRect:scrView.contentView.bounds];
    NSRange allRows = NSMakeRange(0, self.tableView.numberOfRows);
    
    [NSAnimationContext beginGrouping];
    [NSAnimationContext currentContext].duration = 0.0;
    NSIndexSet *idxSet = [NSIndexSet indexSetWithIndexesInRange:visRows];
    [self.tableView noteHeightOfRowsWithIndexesChanged:idxSet];
    
//    NSIndexSet *idxSet = [NSIndexSet indexSetWithIndexesInRange:allRows];
//    [self.tableView noteHeightOfRowsWithIndexesChanged:idxSet];
    
    [NSAnimationContext endGrouping];
    
    redrawTableView(self.tableView, visRows, self.cache);
//    redrawTableView(self.tableView, allRows, self.cache);
}

void redrawTableView(NSTableView *tableView, NSRange range, NSMutableDictionary *cacheDict) {
    for (int i = range.location; i < range.location + range.length; i++) {
        KGTextMessageCell *cell = [tableView viewAtColumn:0 row:i makeIfNecessary:NO];
        NSArray *dims = cacheDict[@(i)];
        int w = [dims.firstObject intValue];
        int h = [dims.lastObject intValue];
        cell.textView.enclosingScrollView.frame = CGRectMake(100.0, 10.0, w, h);
//        NSLog(@"%d  %f %f", i, w, h);
    }

}

- (void)setScrWidth:(CGFloat)scrWidth {
    BOOL shouldRedrawTable = ceilf(_scrWidth) != ceilf(scrWidth);

    
    if (shouldRedrawTable) {
//        [self.tableView reloadData];
//        NSScrollView *scrView = (NSScrollView *)self.tableView.superview.superview;
//        NSRange visRows = [self.tableView rowsInRect:scrView.contentView.bounds];
//        
//        [NSAnimationContext beginGrouping];
//        [NSAnimationContext currentContext].duration = 0.0;
//        NSIndexSet *idxSet = [NSIndexSet indexSetWithIndexesInRange:visRows];
//        [self.tableView noteHeightOfRowsWithIndexesChanged:idxSet];
//        [self.tableView reloadDataForRowIndexes:idxSet columnIndexes:[NSIndexSet indexSetWithIndex:0]];
//        [NSAnimationContext endGrouping];
    }
    
        _scrWidth = scrWidth;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 75;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    self.scrWidth = CGRectGetHeight(self.view.window.frame);
    KGTextMessageCell *cellView = [tableView makeViewWithIdentifier:@"cell" owner:self];
    
    cellView.wantsLayer = YES;
    cellView.layer.backgroundColor = [NSColor redColor].CGColor;
    NSString *text = _strings[row % 4];
    [cellView configureWithString:text width:CGRectGetWidth(self.tableView.bounds) * kMaxWidthMultiplier];
    NSArray *dims = self.cache[@(row)];
    NSNumber *he = dims.lastObject;
    
    CGRect rect = rectForString(text, CGRectGetWidth(self.tableView.bounds) * kMaxWidthMultiplier);
    CGFloat w = ceil(CGRectGetWidth(rect));
    CGFloat h = ceil(CGRectGetHeight(rect));
//
    if (ceilf(h) != ceilf(he.floatValue)) {
//        [self test:[NSNotification new]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSScrollView *scrView = self.tableView.enclosingScrollView;
            self.scrWidth = CGRectGetWidth(scrView.contentView.bounds);
            NSRange visRows = [self.tableView rowsInRect:scrView.contentView.bounds];
            NSIndexSet *idxSet = [NSIndexSet indexSetWithIndex:row];
            [self.tableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:row]];
            [NSAnimationContext beginGrouping];
            [NSAnimationContext currentContext].duration = 0.0;
//            [self.tableView reloadDataForRowIndexes:idxSet columnIndexes:[NSIndexSet indexSetWithIndex:0]];
            [NSAnimationContext endGrouping];
            
            redrawTableView(self.tableView, visRows, self.cache);
        });
    
//        NSScrollView *scrView = self.tableView.superview.superview;
//        self.scrWidth = CGRectGetWidth(scrView.contentView.bounds);
//        NSRange visRows = [self.tableView rowsInRect:scrView.contentView.bounds];
//        
//        [NSAnimationContext beginGrouping];
//        [NSAnimationContext currentContext].duration = 0.0;

//        [self.tableView noteHeightOfRowsWithIndexesChanged:idxSet];
//        [self.tableView reloadDataForRowIndexes:idxSet columnIndexes:[NSIndexSet indexSetWithIndex:0]];
//        [NSAnimationContext endGrouping];

    }
    
    cellView.textView.superview.superview.frame = CGRectMake(100.0, 10.0, w, h);
//    NSLog(@"cellFOrRow idx [%d] %f", row, CGRectGetWidth(self.tableView.bounds) * kMaxWidthMultiplier);
    
    return cellView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
//    NSLog(@"heightForRow  ROW [%d] WIDTH [%f]", row, self.tableView.enclosingScrollView.bounds);
    NSString *text = _strings[row % 4];
    CGRect rect = rectForString(text, CGRectGetWidth(self.tableView.bounds) * kMaxWidthMultiplier);
    [self.cache setObject:@[@(rect.size.width), @(rect.size.height)] forKey:@(row)];
    
    return CGRectGetHeight(rect) + 15.0;
}


CGRect rectForString(NSString *string, CGFloat width) {
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
