//
//  PostManager.m
//  ZHNCosmos
//
//  Created by 连伟钦 on 2018/2/2.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "PostManager.h"

@implementation PostManager

+ (void)postWeibo:(NSString *)text pic:(UIImage *)image{
	ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
	NSString* safeLink = @" http://weico.com/ ";
	[params zhn_safeSetObjetct:@"test share inter http://weico.com/ " forKey:@"status"];
	[ZHNNETWROK post:@"https://api.weibo.com/2/statuses/share.json" params:[params copy] responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
		
	} failure:^(NSError *error, NSURLSessionDataTask *task) {
		[ZHNHudManager showWarning:@"发微博 失败了"];
	}];
}
@end
