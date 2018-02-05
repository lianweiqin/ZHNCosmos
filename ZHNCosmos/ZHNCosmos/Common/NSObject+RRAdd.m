//
//  NSObject+RRAdd.m
//  RRAddition
//
//  Created by 连伟钦 on 16/2/29.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "NSObject+RRAdd.h"

#import <objc/objc.h>
#import <objc/runtime.h>


static const int block_key;

@interface _RRNSObjectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation _RRNSObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
	self = [super init];
	if (self) {
		self.block = block;
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (!self.block) return;
	
	BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
	if (isPrior) return;
	
	NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
	if (changeKind != NSKeyValueChangeSetting) return;
	
	id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
	if (oldVal == [NSNull null]) oldVal = nil;
	
	id newVal = [change objectForKey:NSKeyValueChangeNewKey];
	if (newVal == [NSNull null]) newVal = nil;
	
	self.block(object, oldVal, newVal);
}

@end

@implementation NSObject (RRAdd)
- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
	if (!keyPath || !block) return;
	_RRNSObjectKVOBlockTarget *target = [[_RRNSObjectKVOBlockTarget alloc] initWithBlock:block];
	NSMutableDictionary *dic = [self _rr_allNSObjectObserverBlocks];
	NSMutableArray *arr = dic[keyPath];
	if (!arr) {
		arr = [NSMutableArray new];
		dic[keyPath] = arr;
	}
	[arr addObject:target];
	[self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
	if (!keyPath) return;
	NSMutableDictionary *dic = [self _rr_allNSObjectObserverBlocks];
	NSMutableArray *arr = dic[keyPath];
	[arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		[self removeObserver:obj forKeyPath:keyPath];
	}];
	
	[dic removeObjectForKey:keyPath];
}

- (void)removeObserverBlocks {
	NSMutableDictionary *dic = [self _rr_allNSObjectObserverBlocks];
	[dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
		[arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
			[self removeObserver:obj forKeyPath:key];
		}];
	}];
	
	[dic removeAllObjects];
}

- (NSMutableDictionary *)_rr_allNSObjectObserverBlocks {
	NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
	if (!targets) {
		targets = [NSMutableDictionary new];
		objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return targets;
}

- (void)setAssociateValue:(id)value withKey:(void *)key {
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)getAssociatedValueForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}
@end
