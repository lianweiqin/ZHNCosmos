//
//  UIGestureRecognizer+RRAdd.m
//  RRAddition
//
//  Created by 连伟钦 on 16/2/29.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "UIGestureRecognizer+RRAdd.h"

#import <objc/runtime.h>


static const int block_key;

@interface _RRUIGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _RRUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
	self = [super init];
	if (self) {
		_block = [block copy];
	}
	return self;
}

- (void)invoke:(id)sender {
	if (_block) _block(sender);
}

@end

@implementation UIGestureRecognizer (RRAdd)

- (instancetype)initWithActionBlock:(void (^)(id sender))block {
	self = [self init];
	[self addActionBlock:block];
	return self;
}

- (void)addActionBlock:(void (^)(id sender))block {
	_RRUIGestureRecognizerBlockTarget *target = [[_RRUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
	[self addTarget:target action:@selector(invoke:)];
	NSMutableArray *targets = [self _rr_allUIGestureRecognizerBlockTargets];
	[targets addObject:target];
}

- (void)removeAllActionBlocks{
	NSMutableArray *targets = [self _rr_allUIGestureRecognizerBlockTargets];
	[targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
		[self removeTarget:target action:@selector(invoke:)];
	}];
	[targets removeAllObjects];
}

- (NSMutableArray *)_rr_allUIGestureRecognizerBlockTargets {
	NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
	if (!targets) {
		targets = [NSMutableArray array];
		objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return targets;
}
@end
