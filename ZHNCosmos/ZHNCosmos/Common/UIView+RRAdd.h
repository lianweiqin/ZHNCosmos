//
//  UIView+RRAdd.h
//  RRAddition
//
//  Created by 连伟钦 on 16/2/29.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (RRAdd)

/**
 *  给一个UIView添加tap手势
 *
 *  @param block tap动作发生之后的回调
 *  NOTE: 需要修改这个block 请调用后面的set方法
 */
- (void)addTapGestureWithBlock:(void (^)(id sender))block;

/**
 *  给一个UIView添加长按手势
 *
 *  @param block 长按动作发生之后的回调
 */
- (void)addLongPressGestureWithBlock:(void (^)(id sender))block;

/**
 *  添加或者替换一个UIView(self)的tap手势回调
 *
 *  @param block 新block
 */
- (void)setTapGestureWithBlock:(void (^)(id sender))block;

/**
 *  添加或者替换一个UIView(self)的LongPress手势回调
 *
 *  @param block new block
 */
- (void)setLongPressGestureWithBlock:(void (^)(id sender))block;

/**
 *  移除所有的子view
 */
- (void)removeAllSubviews;

/**
 *  找到当前view所在的viewcontroller
 *
 *  @return
 */
- (nullable UIViewController *)viewController;


/**
 * Create a snapshot image of the complete view hierarchy.
 */
- (UIImage *)snapshotImage;
@end
NS_ASSUME_NONNULL_END
