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

#import "AOMOfflineTask.h"
#import "AOMModelStore.h"
#import "AOMDatastore.h"
#import "AOMAbstractClientDataModel.h"
#import "AOMModelHelper.h"

#define kAOMRequestKey @"kAOMRequestKey"
#define kAOMLocalIdKey @"kAOMLocalIdKey"
#define kAOMRefNameKey @"kAOMRefNameKey"
#define kAOMTimestampKey @"kAOMTimestampKey"
#define kAOMClassNameKey @"kAOMClassNameKey"

@interface AOMOfflineTask()

- (BOOL) sendModelToServer:(NSData*) data HttpMethod:(NSString*)httpMethod URL:(NSURL*) _url;
- (BOOL) sendStaticReqToServer:(NSData*) data HttpMethod:(NSString*) httpMethod AsImage:(BOOL) isImage;
- (void) cleanupJson:(AOMAbstractClientDataModel*) obj;

@end

@implementation AOMOfflineTask
@synthesize localId, refName, request, timeStamp, className, realHref, object;

- (id) initWithURLRequest:(NSURLRequest*) _urlRequest localId:(NSString*) _localId refName:(NSString*) _refName timeStamp:(NSDate*) _timeStamp className:(NSString*) _className Object:(AOMAbstractClientDataModel*) _object
{
    if (self = [super init])
    {
        [self setRequest:_urlRequest];
        [self setLocalId:_localId];
        [self setRefName:_refName];
        [self setTimeStamp:_timeStamp];
        [self setClassName:_className];
        [self setObject:_object];
    }
    return self;
}

-(void)main {
    @try {
        if([self isCancelled] == FALSE)
        {
            /* Get data from cache */
            NSCachedURLResponse *cachedResp = [[AOMModelStore sharedInstance] cachedResponseForRequest:[self request]];
            if(cachedResp)
            {
                BOOL wasSuccess = FALSE;
                NSData *data = [cachedResp data];
                NSDictionary *userInfo = [cachedResp userInfo];
                NSString *httpMethod = [userInfo objectForKey:HTTP_METHOD_KEY]?:@"POST";
                NSURL *url = [[cachedResp response] URL];
                
                BOOL isStaticData = [self className] == nil;
                if(isStaticData)
                {
                    BOOL isImage = (BOOL)[userInfo objectForKey:IS_IMAGE_FILE]?:TRUE;
                    wasSuccess = [self sendStaticReqToServer:data HttpMethod:httpMethod AsImage:isImage];
                }
                else
                {
                    wasSuccess = [self sendModelToServer:data HttpMethod:httpMethod URL:url];
                }
                
                /* remove data from cache on success */
                if(wasSuccess)
                {
                    [[AOMModelStore sharedInstance] removeCachedResponseForRequest:[self request]];
                }
            }
        }
    }
    @catch(NSException *e) {
        NSLog(@"Exception thrown on executing task: %@", [e description]);
    }
}

#pragma mark Server Requests

void updateModel(AOMAbstractClientDataModel *obj, NSString *href)
{
    if([obj isOffline])
    {
        [obj setObjectState:ObjectState_PERSISTED];
        /* load again from server to get refrence URLs */
        AOMAbstractClientDataModel *tmpObj = [[[obj class] alloc] init];
        [[AOMDatastore sharedInstance] loadFromServerWithHref:href andStoreIn:tmpObj];
        /* walk through JSON data and replace local URLs with real URL */
        for (NSString *key in [tmpObj data])
        {
            if([key hasSuffix:@"Href"])
            {
                NSString *val = [[tmpObj data] objectForKey:key];
                [[obj data] setObject:val forKey:key];
            }
        }
        tmpObj = nil;
    }
}

- (BOOL) sendModelToServer:(NSData*) data HttpMethod:(NSString*) httpMethod URL:(NSURL*) _url
{
    BOOL isLivingObject = TRUE;
    BOOL wasSuccess = FALSE;
    NSURLRequest *getReq = nil;
    BOOL isReference = [self refName] != nil;
    /* Try to use references model, if not there create new one from JSON data */
    AOMAbstractClientDataModel* obj = [self object];
    if(obj == FALSE)
    {
        obj = [[NSClassFromString([self className]) alloc] init];
        [obj fromJson:data];
        isLivingObject = FALSE;
    }
    
    /* send request */
    if([httpMethod isEqualToString:@"POST"])
    {
        NSString *href = nil;
        
        if(isReference)
        {
            NSString *url = [_url absoluteString];
            /* Cleanup URL first */
            if([url hasSuffix:httpMethod])
            {
                url = [url stringByDeletingLastPathComponent];
            }
            NSArray *components = [url componentsSeparatedByString:@"/"];
            NSString *parentID = [components objectAtIndex:[components count] - 2];
            NSString *realURL = [[[[AOMModelStore sharedInstance] mapIdToHref] objectForKey:parentID] stringByAppendingPathComponent:[self refName]];
            
            href = [[AOMDatastore sharedInstance] postReferenceOnServer:nil Model:obj Href:realURL ParentHref:nil];
        }
        else
        {
            /* remove href else localID will be send to server and this is wrong */
            [obj setValue:nil forKey:@"href"];
            [[obj data] removeObjectForKey:@"id"];
            href = [[AOMDatastore sharedInstance] postOnServer:obj];
        }
        wasSuccess = href != nil;
        if(wasSuccess)
        {
            /* Add mapping from LocalId to HREF for follow-up requests on references */
            [[[AOMModelStore sharedInstance] mapIdToHref] setObject:href forKey:[self localId]];
            
            /* Update real model */
            if(isLivingObject)
            {
                [AOMModelHelper updateHref:href forModel:obj];
                updateModel(obj, href);
            }
        }
        
        getReq = CreateGetRequestFromUrl([[[[self request] URL] URLByAppendingPathComponent:localId] absoluteString], TRUE);
    }
    else if([httpMethod isEqualToString:@"PUT"])
    {
        /* Update all URLs for images in JSON */
        [self cleanupJson:obj];
        wasSuccess = [[AOMDatastore sharedInstance] updateOnServer:obj];
        /* Update real model */
        if(isLivingObject)
        {
            updateModel(obj, [obj getHref]);
        }
    }
    else if([httpMethod isEqualToString:@"DELETE"])
    {
        wasSuccess = [[AOMDatastore sharedInstance] deleteOnServer:obj];
    }
    /* remove also cached GET request and download data again */
    if(wasSuccess && getReq)
    {
        [[AOMModelStore sharedInstance] removeCachedResponseForRequest:getReq];
    }
    
    return wasSuccess;
}
- (BOOL) sendStaticReqToServer:(NSData*) data HttpMethod:(NSString*) httpMethod AsImage:(BOOL) isImage
{
    BOOL wasSuccess = FALSE;
    if([httpMethod isEqualToString:@"POST"])
    {
        NSString *href = [[AOMDatastore sharedInstance] postStaticDataOnServer:data asImage:isImage UsePersistentStorage:FALSE];
        wasSuccess = href != nil;
        /* Add mapping from LocalId to HREF for follow-up requests on references */
        if(wasSuccess)
        {
            [[[AOMModelStore sharedInstance] mapIdToHref] setObject:href forKey:[self localId]];
        }
    }
    else if([httpMethod isEqualToString:@"DELETE"])
    {
        NSString *href = [[[self request] URL] absoluteString];
        wasSuccess = [[AOMDatastore sharedInstance] deleteOnServerWithUrl:href UsePersistentStorage:FALSE];
    }
    return wasSuccess;
}

- (void) cleanupJson:(AOMAbstractClientDataModel*) obj
{
    if([obj isOffline])
    {
        BOOL updateFound = FALSE;
        /* walk through JSON data and replace local URLs with real URL */
        for (NSString *key in [obj data].copy) {
            if([key hasSuffix:@"URL"])
            {
                /* Replace HREF */
                NSString *dataLocalHref = [[obj data] objectForKey:key];
                NSString *dataLocalId = [[NSURL URLWithString:dataLocalHref] lastPathComponent];
                NSString *rHref = [[[AOMModelStore sharedInstance] mapIdToHref] objectForKey:dataLocalId];
                if(rHref)
                {
                    [[obj data] setObject:rHref forKey:key];
                    updateFound = TRUE;
                }
            }
        }
        if(updateFound)
        {
            /* Generate object again from updated JSON */
            [obj fromJson:[obj toJson]];
        }
        /* Set also real HREF */
        NSString *rHref = [[[AOMModelStore sharedInstance] mapIdToHref] objectForKey:[obj getID]];
        if(rHref)
        {
            [AOMModelHelper updateHref:rHref forModel:obj];
        }
    }
}

#pragma mark NSCoder

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self request] forKey:kAOMRequestKey];
    [encoder encodeObject:[self localId] forKey:kAOMLocalIdKey];
    [encoder encodeObject:[self refName] forKey:kAOMRefNameKey];
    [encoder encodeObject:[self timeStamp] forKey:kAOMTimestampKey];
    [encoder encodeObject:[self className] forKey:kAOMClassNameKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        NSURLRequest *_req = [decoder decodeObjectForKey:kAOMRequestKey];
        NSString *_localId = [decoder decodeObjectForKey:kAOMLocalIdKey];
        NSString *_refName = [decoder decodeObjectForKey:kAOMRefNameKey];
        NSDate *_timeStamp = [decoder decodeObjectForKey:kAOMTimestampKey];
        NSString *_className = [decoder decodeObjectForKey:kAOMClassNameKey];
        
        [self setRequest:_req];
        [self setLocalId:_localId];
        [self setRefName:_refName];
        [self setTimeStamp:_timeStamp];
        [self setClassName:_className];
    }
    
    return self;
}

@end
