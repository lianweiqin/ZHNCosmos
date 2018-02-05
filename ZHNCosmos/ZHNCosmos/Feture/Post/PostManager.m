//
//  PostManager.m
//  ZHNCosmos
//
//  Created by 连伟钦 on 2018/2/2.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "PostManager.h"
//#import <AFNetworking.h>

@implementation PostManager

+ (void)postWeibo:(NSString *)text pic:(NSArray *)images{
	ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
//	NSString* safeLink = @" http://weico.com/ ";
//	NSString* status = [NSString stringWithFormat:@"%@%@", text, safeLink];
//	[params zhn_safeSetObjetct:status forKey:@"status"];
	[params zhn_safeSetObjetct:text forKey:@"status"];

	if (!images || images.count == 0) {
//		[ZHNNETWROK post:@"https://api.weibo.com/2/statuses/share.json" params:[params copy] responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
//			[ZHNHudManager showWarning:@"发微博成功啦~"];
//		} failure:^(NSError *error, NSURLSessionDataTask *task) {
//			[ZHNHudManager showWarning:@"发送微博失败, 别问我为什么"];
//		}];
		[ZHNNETWROK post:@"https://api.weibo.com/2/statuses/update.json" params:[params copy] responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
			[ZHNHudManager showSuccess:@"发微博成功啦~"];
		} failure:^(NSError *error, NSURLSessionDataTask *task) {
			[ZHNHudManager showWarning:@"发送微博失败, 别问我为什么"];
		}];
	}else {
		// 带图片的那种
		AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
		[manager POST:@"https://api.weibo.com/2/statuses/upload.json"
		   parameters:[params copy] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
			   [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				   
				   [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.6) name:@"pic" fileName:[NSString stringWithFormat:@"pic_%zd", idx] mimeType:@"application/octet-stream"];
			   }];
			   
		   } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			   [ZHNHudManager showSuccess:@"发微博成功啦~"];
			   
		   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			   [ZHNHudManager showWarning:@"发送微博失败, 别问我为什么"];
		   }];
	}
}

+ (void)postComment:(NSString *)text weiboId:(unsigned long long )weiboId commentId:(unsigned long long)commentId{
	NSString* urlPath = nil;
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	if (commentId != -1) {
		urlPath = @"https://api.weibo.com/2/comments/reply.json";
		[params zhn_safeSetObjetct:@(commentId) forKey:@"cid"];
	}else {
		urlPath = @"https://api.weibo.com/2/comments/create.json";
	}
	ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
	
	[params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
	[params zhn_safeSetObjetct:text forKey:@"comment"];
	[params zhn_safeSetObjetct:@(weiboId) forKey:@"id"];
	
	
	[ZHNNETWROK post:urlPath params:[params copy] responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
		[ZHNHudManager showSuccess:@"评论成功~"];
	} failure:^(NSError *error, NSURLSessionDataTask *task) {
		[ZHNHudManager showWarning:@"评论失败~"];
	}];
}
@end
