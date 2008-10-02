#import <Cocoa/Cocoa.h>

@class CollectionViewItem;

@protocol CollectionViewTarget <NSObject>

- (NSDragOperation)dragOperationForFiles: (NSArray *)filePaths;
- (void)dragFiles: (NSArray *)filePaths toIndex: (int)index;
- (void)dragItemsAtIndexes: (NSArray *)indexes toIndex: (int)index;
- (BOOL)shouldRemoveItemsAtIndexes: (NSArray *)indexes;
- (void)performDoubleClickActionForIndex: (int)index;
- (void)onSelectionDidChange;
- (NSString *)filePathForIndex: (int)index;

@end


@interface CollectionView : NSView
{
   IBOutlet id<CollectionViewTarget> target;
   NSMutableArray *items;
   BOOL needsLayout;
}

- (void)addItem: (CollectionViewItem *)item atIndex: (int)index;
- (void)removeItemAtIndex: (int)index;
- (void)removeAllItems;
- (int)numberOfItems;
- (NSArray *)selectedIndexes;

@end


@interface CollectionViewItem : NSView
{
   BOOL isSelected;
   NSPoint mouseDownPos;
   int dragTargetType;
   NSMutableDictionary *cachedTextColors;
}
@end
