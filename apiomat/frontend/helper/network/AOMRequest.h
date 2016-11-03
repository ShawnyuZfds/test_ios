/*
 * Copyright (c) 2011 - 2016, Apinauten GmbH
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THIS FILE IS GENERATED AUTOMATICALLY. DON'T MODIFY IT.
 */

#import <Foundation/Foundation.h>
#import "AOMConstants.h"

@interface AOMRequest : NSObject
- (id) initWithURL:(NSString*)_url httpMethod:(NSString*)_httpMethod expectedCodes:(NSArray*) _exptectedCodes responseBlock:(AOMResponseDataBlock) _responseBlock;
- (id) initWithURL:(NSString*)_url httpMethod:(NSString*)_httpMethod expectedCode:(NSInteger) _exptectedCode responseBlock:(AOMResponseDataBlock) _responseBlock;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *httpMehod;
@property(nonatomic, strong) NSArray *expectedCodes;
@property(nonatomic, strong) NSData *httpBody;
@property(nonatomic, copy) AOMResponseDataBlock responseBlock;
@property(nonatomic) BOOL isBinaryData;
@property(nonatomic) BOOL storeInCache;
@property(nonatomic) BOOL useDeltaSync;
@property(nonatomic) BOOL useAuthorization;
@property(nonatomic) BOOL processResponse;
@property(nonatomic, strong) NSDictionary *addtionalHeaders;
@end
