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
#import "AOMModelStoreProtocol.h"

static const NSString *IS_COLLECTION_KEY = @"aom-is-collection";
static const NSString *LINKED_COLLECTIONS_KEY = @"aom-linked-collections";
static const NSString *HTTP_METHOD_KEY = @"aom-http-method";
static const NSString *IS_IMAGE_FILE = @"aom-is-image-file";
static const NSString *CACHED_RETURN_DATA_KEY = @"retData";
static const NSString *CACHED_RETURN_FAILED_KEY = @"failedHrefs";


NSMutableURLRequest* CreateGetRequestFromUrl(NSString*, BOOL);

@class AOMAbstractClientDataModel;
/*!
 Implementation of the ModelStoreProtocol
 
 @warning *Important:* This class is currenlty BETA and under heavy development. Don't use this in production environment
 */
@interface AOMModelStore : NSURLCache<AOMModelStoreProtocol>
+ (AOMModelStore*) sharedInstance;
+ (NSDictionary*) getCachedDataForCollection:(NSData*) collectionData;
+ (NSDictionary*) getCachedDataForHrefs:(NSArray*) jsonArray;

- (void) executeTasks:(BOOL)_executeTask;
- (NSDictionary*) getSavedIDsForRequest:(NSURLRequest*)_request;

@property (nonatomic, strong, readonly) NSOperationQueue* offlineQueue;
@property (nonatomic, readonly, strong) NSMutableDictionary *mapIdToHref;
@end
