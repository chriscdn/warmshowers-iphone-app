//
//  Thread.h
//  WS
//
//  Created by Christopher Meyer on 10/05/15.
//  Copyright (c) 2015 Red House Consulting GmbH. All rights reserved.
//

#import "_Thread.h"

@interface Thread : _Thread

-(void)refresh;
-(void)replyWithBody:(NSString *)body
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end