//
//  NSNumber+RRAdd.m
//  RRAddition
//
//  Created by 连伟钦 on 16/2/29.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "NSNumber+RRAdd.h"
#import "NSString+RRAdd.h"


@implementation NSNumber (RRAdd)


+ (NSNumber *)numberWithString:(NSString *)string {
	NSString *str = [[string stringByTrim] lowercaseString];
	if (!str || !str.length) {
		return nil;
	}
	
	static NSDictionary *dic;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dic = @{@"true" :   @(YES),
				@"yes" :    @(YES),
				@"false" :  @(NO),
				@"no" :     @(NO),
				@"nil" :    [NSNull null],
				@"null" :   [NSNull null],
				@"<null>" : [NSNull null]};
	});
	id num = dic[str];
	if (num) {
		if (num == [NSNull null]) return nil;
		return num;
	}
	
	// hex number
	int sign = 0;
	if ([str hasPrefix:@"0x"]) sign = 1;
	else if ([str hasPrefix:@"-0x"]) sign = -1;
	if (sign != 0) {
		NSScanner *scan = [NSScanner scannerWithString:str];
		unsigned num = -1;
		BOOL suc = [scan scanHexInt:&num];
		if (suc)
			return [NSNumber numberWithLong:((long)num * sign)];
		else
			return nil;
	}
	// normal number
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	return [formatter numberFromString:string];
}

- (NSString *)addCommaAndTwoDecimalPlaces{
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	[formatter setPositiveFormat:@"###,##0.00;"];
	NSString* numberText = [formatter stringFromNumber:self];
	return numberText;
}

- (NSString *)addCommaAndNoDecimal{
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	[formatter setPositiveFormat:@"###,##0;"];
	NSString* numberText = [formatter stringFromNumber:self];
	return numberText;
}

@end
