//
//  UIGestureRecognizer+RRAdd.h
//  RRAddition
//
//  Created by 连伟钦 on 16/2/29.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (RRAdd)
/**
 *  给手势加回调. 也是为了方便使用block.
 *
 *  @param block
 *
 *  @return
 */
- (instancetype)initWithActionBlock:(void (^)(id sender))block;

/**
 *  给已存在的手势加block
 *
 *  @param block
 */
- (void)addActionBlock:(void (^)(id sender))block;

/**
 *  remove all action blocks
 */
- (void)removeAllActionBlocks;
@end
