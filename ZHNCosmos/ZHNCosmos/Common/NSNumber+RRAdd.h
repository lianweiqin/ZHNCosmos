//
//  NSNumber+RRAdd.h
//  RRAddition
//
//  Created by 连伟钦 on 16/2/29.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (RRAdd)
/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

/**
 *  23334.56  = >  @"23,334.56" 把数字转成带有千分位的字符串
 *
 *  @return
 */
- (nullable NSString *)addCommaAndTwoDecimalPlaces;

/**
 *  23334.56  = >  @"23,334"
 *
 *  @return
 */
- (nullable NSString *)addCommaAndNoDecimal;

@end

NS_ASSUME_NONNULL_END
