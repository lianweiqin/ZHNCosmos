//
//  UIView+RRAdd.m
//  RRAddition
//
//  Created by 连伟钦 on 16/2/29.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "UIView+RRAdd.h"

#import "UIGestureRecognizer+RRAdd.h"
#import <objc/runtime.h>


static const int kTapGestureKey;
static const int kLongPressGestureKey;

@implementation UIView (RRAdd)

- (void)addTapGestureWithBlock:(void (^)(id sender))block{
	UITapGestureRecognizer* gesture = objc_getAssociatedObject(self, &kTapGestureKey);
	if (!gesture){
		gesture = [[UITapGestureRecognizer alloc] initWithActionBlock:block];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (void)addLongPressGestureWithBlock:(void (^)(id sender))block{
	UILongPressGestureRecognizer* gesture = objc_getAssociatedObject(self, &kLongPressGestureKey);
	if (!gesture){
		gesture = [[UILongPressGestureRecognizer alloc] initWithActionBlock:block];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (void)setTapGestureWithBlock:(void (^)(id sender))block{
	UITapGestureRecognizer* gesture = objc_getAssociatedObject(self, &kTapGestureKey);
	if (gesture){
		[gesture removeAllActionBlocks];
		[gesture addActionBlock:block];
	}else{
		[self addTapGestureWithBlock:block];
	}
}

- (void)setLongPressGestureWithBlock:(void (^)(id sender))block{
	UILongPressGestureRecognizer* gesture = objc_getAssociatedObject(self, &kLongPressGestureKey);
	if (gesture){
		[gesture removeAllActionBlocks];
		[gesture addActionBlock:block];
	}else{
		[self addLongPressGestureWithBlock:block];
	}
}

- (void)removeAllSubviews {
	while (self.subviews.count) {
		[self.subviews.lastObject removeFromSuperview];
	}
}

- (UIViewController *)viewController {
	for (UIView *view = self; view; view = view.superview) {
		UIResponder *nextResponder = [view nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	}
	return nil;
}

- (UIImage *)snapshotImage {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return snap;
}

@end
