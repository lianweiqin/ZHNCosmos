//
//  PostManager.h
//  ZHNCosmos
//
//  Created by 连伟钦 on 2018/2/2.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostManager : NSObject

+ (void)postWeibo:(NSString *)text pic:(UIImage *)image;

@end
