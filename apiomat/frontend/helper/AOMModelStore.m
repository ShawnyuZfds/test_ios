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
#import "AOMModelStore.h"
#import "AOMAbstractClientDataModel.h"
#import "AOMDatastore.h"
#import "AOMOfflineTask.h"
#import "AOMModelHelper.h"

#define AOMCacheFilename @"offlinedata.plist"

#pragma mark - Private Interface

@interface AOMModelStore ()
@property (nonatomic, strong) NSMutableDictionary *store;
@property (nonatomic) BOOL useIncompleteReferences;
/* Map which maps localID -> HREF */
@property (nonatomic, readwrite, strong) NSMutableDictionary *mapIdToHref;
@property (nonatomic, readwrite, strong) NSOperationQueue* offlineQueue;
@property (nonatomic, strong) NSString *filePath;
- (void) initClass;
- (NSDictionary*) addTaskInternal:(NSData *)_data withUrl:(NSString *)_url andHttpMethod:(NSString *)_httpMethod andClass:(NSString*) _className Object:(AOMAbstractClientDataModel*)_object AsImage:(BOOL)_isImage;
- (void) serializeMetadata;
- (void) deserializeMetadata;
@end

#pragma mark - Implementation

@implementation AOMModelStore

@synthesize offlineQueue, mapIdToHref;
@synthesize store = m_store;
@synthesize useIncompleteReferences = m_useIncompleteReferences;

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initClass];
    }
    return self;
}

- (id) initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path
{
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
    if (self)
    {
        [self initClass];
    }
    return self;
}

- (void) initClass
{
    m_store = [[NSMutableDictionary alloc] init];
    m_useIncompleteReferences = false;
    /* Find document path */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    self.filePath = [documentsDirectoryPath stringByAppendingPathComponent:AOMCacheFilename];
    
    /* Init offline queue */
    self.offlineQueue = [[NSOperationQueue alloc] init];
    self.offlineQueue.name = @"AOM Offline Queue";
    self.offlineQueue.maxConcurrentOperationCount = 1;
    [self.offlineQueue setSuspended:YES];
    self.mapIdToHref = [[NSMutableDictionary alloc] init];
    [self deserializeMetadata];
    /* implement observer for offlineQueue */
    [[self offlineQueue] addObserver:self forKeyPath:NSStringFromSelector(@selector(operations)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

+ (AOMModelStore*) sharedInstance
{
    return (AOMModelStore*)[self sharedURLCache];
}

#pragma mark -

- (void)addModel:(AOMAbstractClientDataModel*)_model
{
    NSMutableDictionary *models = (NSMutableDictionary*)[m_store objectForKey:NSStringFromClass([_model class])];
    
    if (models == nil)
    {
        models = [[NSMutableDictionary alloc] init];
        [m_store setObject:models forKey:NSStringFromClass([_model class])];
    }
    
    // add new object
    [models setObject:_model forKey:[_model getHref]];
}

- (void)removeModel:(AOMAbstractClientDataModel*)_model
{
    NSMutableDictionary *models = (NSMutableDictionary*)[m_store objectForKey:NSStringFromClass([_model class])];
    [models removeObjectForKey:[_model getHref]];
    
    // clean up
    if ([models count] == 0)
    {
        [m_store removeObjectForKey:NSStringFromClass([_model class])];
    }
}

- (AOMAbstractClientDataModel*)modelWithHref:(NSString*)_href
{
    for (NSMutableDictionary *models in [m_store allValues])
    {
        if ([models objectForKey:_href])
        {
            return [models objectForKey:_href];
        }
    }
    return nil;
}

- (AOMAbstractClientDataModel*)modelWithHref:(NSString*)_href andClass:(Class)_class
{
    NSMutableDictionary *models = (NSMutableDictionary*)[m_store objectForKey:NSStringFromClass(_class)];
    return (AOMAbstractClientDataModel*)[models objectForKey:_href];
}

- (NSMutableArray*)modelsWithClass:(Class)_class
{
    // sort list by creation time
    return [self modelsWithClass:_class sortedWithComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(AOMAbstractClientDataModel*)obj1 getCreatedAt] compare:[(AOMAbstractClientDataModel*)obj2 getCreatedAt]];
    }];
}

- (NSMutableArray*)modelsWithClass:(Class)_class sortedWithComparator:(NSComparator)_cmptr
{
    NSMutableDictionary *result = (NSMutableDictionary*)[m_store objectForKey:NSStringFromClass(_class)];
    if (result == nil) return nil;
    
    NSMutableArray *models = [[result allValues] mutableCopy];
    
    if (_cmptr)
    {
        [models sortUsingComparator:_cmptr];
    }
    
    return models ;
}

- (NSMutableArray*)modelsWithClass:(Class)_class andPredicate:(NSPredicate*)_predicate sortedWithComparator:(NSComparator)_cmptr
{
    return [[[self modelsWithClass:_class sortedWithComparator:_cmptr] filteredArrayUsingPredicate:_predicate] mutableCopy];
}

- (NSUInteger)size
{
    return [m_store count];
}

- (void)clear
{
    [m_store removeAllObjects];
    [self save];
}


#pragma mark - Debug

- (NSString*)description
{
    NSString *descr = @"";
    for (NSString *class in m_store)
    {
        descr = [descr stringByAppendingFormat:@"In Store: %@", class];
        for (NSString *href in [m_store objectForKey:class])
        {
            descr = [descr stringByAppendingFormat:@"\n--> %@", href];
        }
        descr = [descr stringByAppendingString:@"\n"];
    }
    return descr;
}

#pragma mark - Persistence

- (NSString *)modelStoreFilePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"ModelStore.plist"];
}

- (BOOL)save
{
    return [NSKeyedArchiver archiveRootObject:m_store
                                       toFile:[self modelStoreFilePath]];
}

- (BOOL)load
{
    // store already loaded?
    if ([self.store count] > 0)
    {
        return YES;
    }
    
    NSString *filePath =[self modelStoreFilePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        @try
        {
            self.store = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            if (self.store && [self.store count] > 0)
            {
                return YES;
            }
            return YES;
        }
        @catch (NSException *exception)
        {
            NSLog(@"Can't load store from file: %@", exception);
            
            // For error information
            NSError *error;
            // Create file manager
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            
            // Attempt to delete the file at filePath
            if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
                NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
    }
    return NO;
}

- (BOOL)useIncompleteReferences
{
    return m_useIncompleteReferences;
}
- (void)setUseIncompleteReferences:(BOOL) useIncompleteRefs
{
    m_useIncompleteReferences = useIncompleteRefs;
}

#pragma mark - Offline Handling POST/PUT

NSMutableURLRequest* CreateGetRequestFromUrl(NSMutableString *urlString, BOOL _concatHref)
{
    NSString *getUrlString = _concatHref?[AOMDatastore concatHref:urlString withQuery:nil]:urlString;
    NSURL *url = [NSURL URLWithString:getUrlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:100];
    [req setHTTPMethod:@"GET"];
    return req;
}

- (NSString*) addTask:(AOMAbstractClientDataModel*) _model withUrl:(NSString*) _url andHttpMethod:(NSString*)_httpMethod andReferenceName:(NSString*)_refName
{
    if(_url == nil && _refName)
    {
        return nil;
    }
    else if(_url == nil)
    {
        /* Create URL based on class infos */
        _url = [[[AOMDatastore sharedInstance] createModelHrefFromClass:[_model class]] mutableCopy];
    }
    
    NSString *className = NSStringFromClass([_model class]);
    /* Mark as offline object */
    [[_model data] setObject:[NSNumber numberWithBool:TRUE] forKey:@"isOffline"];
    
    NSData *data = [_model toJson];
    NSDictionary *returnDict = [self addTaskInternal:data withUrl:_url andHttpMethod:_httpMethod andClass:className Object:_model AsImage:FALSE];
    
    NSString *returnedUrl = [returnDict objectForKey:@"HREF"];
    AOMOfflineTask *task = [returnDict objectForKey:@"TASK"];
    /* Set reference information if there */
    if(_refName && task)
    {
        [task setRefName:_refName];
    }
    if([_httpMethod isEqualToString:@"POST"])
    {
        /* Set Local Href */
        [AOMModelHelper updateHref:returnedUrl forModel:_model];
    }
    
    NSMutableURLRequest *req = CreateGetRequestFromUrl(returnedUrl, TRUE);
    
    if([_httpMethod isEqualToString:@"DELETE"])
    {
        [_model setObjectState:ObjectState_LOCAL_DELETED];
        /* Delete also GET from cache */
        [self removeCachedResponseForRequest:req];
    }
    else
    {
        [_model setObjectState:ObjectState_LOCAL_PERSISTED];
        /* Add also a new cache entry for GET request with local ID */
        /*  Generate data again because we addd HREF, ObjectState */
        data = [_model toJson];
        NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] init];
        [headerFields setObject:[NSString stringWithFormat:@"max-age=%lddl",CACHE_TTL] forKey:@"Cache-Control"];
        NSHTTPURLResponse *httpUrlResp = [[NSHTTPURLResponse alloc] initWithURL:[req URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
        NSCachedURLResponse *resp = [[NSCachedURLResponse alloc] initWithResponse:httpUrlResp data:data];
        /* Store also GET request/response in cache */
        [[AOMModelStore sharedInstance] storeCachedResponse:resp forRequest:req];
        
        /* Also add GET request/response for reference in cache */
        req = CreateGetRequestFromUrl(_url, TRUE);
        httpUrlResp = [[NSHTTPURLResponse alloc] initWithURL:[req URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
        resp = [[NSCachedURLResponse alloc] initWithResponse:httpUrlResp data:data];
        /* Store also GET request/response in cache */
        [[AOMModelStore sharedInstance] storeCachedResponse:resp forRequest:req];        
    }
    
    return returnedUrl;
}

- (NSString*) addStaticTask:(NSData*) _rawData withUrl:(NSString*) _url andHttpMethod:(NSString*)_httpMethod IsImage: (BOOL) _isImage
{
    NSDictionary *returnDict = [self addTaskInternal:_rawData withUrl:_url andHttpMethod:_httpMethod andClass:nil Object:nil AsImage:_isImage];
    NSString *returnedUrl = [returnDict objectForKey:@"HREF"];
    /* Add also a new cache entry for GET request with local ID */
    NSMutableURLRequest *req = CreateGetRequestFromUrl([AOMModelHelper getResourceURL:returnedUrl WithSuffix:@".img"], FALSE);
    NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] init];
    [headerFields setObject:[NSString stringWithFormat:@"max-age=%ldl", CACHE_TTL] forKey:@"Cache-Control"];
    NSHTTPURLResponse *httpUrlResp = [[NSHTTPURLResponse alloc] initWithURL:[req URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
    NSCachedURLResponse *resp = [[NSCachedURLResponse alloc] initWithResponse:httpUrlResp data:_rawData];
    /* Store also GET request/response in cache */
    [[AOMModelStore sharedInstance] storeCachedResponse:resp forRequest:req];
    
    return returnedUrl;
}

- (NSDictionary*) addTaskInternal:(NSData *)_data withUrl:(NSString *)_url andHttpMethod:(NSString *)_httpMethod andClass:(NSString*) _className Object:(AOMAbstractClientDataModel*)_object AsImage:(BOOL)_isImage
{
    NSMutableString *localId = nil;
    NSMutableString *refName = nil;
    NSDate *timeStamp = [[NSDate alloc] init];
    
    NSMutableString *returnedUrl = [_url mutableCopy];
    if([_httpMethod  isEqualToString:@"POST"])
    {
        localId = [NSMutableString stringWithFormat:@"%d", arc4random() % 10000000];
        if([returnedUrl hasSuffix:@"/"])
        {
            [returnedUrl appendString:localId];
        }
        else
        {
            [returnedUrl appendFormat:@"/%@", localId];
        }
    }
    NSURL *reqUrl = [NSURL URLWithString:_url];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:reqUrl cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:100];
    
    [req setHTTPMethod:_httpMethod];
    [req setHTTPBody:_data];
    NSURLResponse *urlResp = [[NSURLResponse alloc] initWithURL:reqUrl MIMEType:@"application/json" expectedContentLength:[_data length] textEncodingName:@"utf8"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSNumber numberWithBool:_isImage] forKey:IS_IMAGE_FILE];
    NSCachedURLResponse *resp = [[NSCachedURLResponse alloc] initWithResponse:urlResp data:nil userInfo:userInfo storagePolicy:NSURLCacheStorageAllowed];
    /* Store in cache */
    [[AOMModelStore sharedInstance] storeCachedResponse:resp forRequest:req];
    
    /* add task to offline queue */
    AOMOfflineTask *task = [[AOMOfflineTask alloc] initWithURLRequest:req localId:localId refName:refName timeStamp:timeStamp className:_className Object:_object];
    [[self offlineQueue] addOperation:task];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:returnedUrl forKey:@"HREF"];
    if(localId)
    {
        [dict setObject:localId forKey:@"LOCAL_ID"];
    }
    
    [dict setObject:task forKey:@"TASK"];
    
    /* persists */
    [self serializeMetadata];
    
    return (NSDictionary*)dict;
}

- (void) executeTasks:(BOOL)_executeTasks
{
    [[self offlineQueue] setSuspended:_executeTasks == false];
}

#pragma mark - NSURLCache overriding

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
//    NSLog(@"Try to get from cache: %@", [request URL]);
    NSString *httpMethod = [request HTTPMethod];
    if([httpMethod isEqualToString:@"GET"] == FALSE)
    {
        /* handle POST/PUT/DELETE requests */
        NSMutableURLRequest *urlReq = request.mutableCopy;
        [urlReq setHTTPMethod:@"GET"];
        [urlReq setHTTPBody:nil];
        [urlReq setURL:[[urlReq URL] URLByAppendingPathComponent:httpMethod]];
        request = urlReq;
    }
    
    NSCachedURLResponse *response = [super cachedResponseForRequest:request];
#ifdef IS_TESTING
    [[AOMDatastore sharedInstance] setWasCacheHit:response != nil];
#endif
    return response;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    /* Store only if strategy is NOT network only */
    if([[AOMDatastore sharedInstance] cacheStrategy] != AOM_NETWORK_ONLY)
    {
//        NSLog(@"Trying to store %@", [request URL]);
        NSString *httpMethod = [request HTTPMethod];
        NSData *results = cachedResponse.data;
        /* check HTTP method other then GET, transform to GET and save, because we must save this for offline handling of POST/PUT/DELETE */
        if([httpMethod isEqualToString:@"GET"] == FALSE)
        {
            NSURLResponse *response = cachedResponse.response;
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
            /* Avoid overriding of existing cache entries with other HTTP methods by adding the HTTP method in front of URL */
            NSURL *url = [[HTTPResponse URL] URLByAppendingPathComponent:httpMethod];
            NSMutableURLRequest *singleReq = [NSMutableURLRequest requestWithURL:url];
            [singleReq setHTTPMethod:@"GET"];
            NSMutableDictionary *userInfo = cachedResponse.userInfo.mutableCopy;
            if (userInfo == FALSE) {
                userInfo = [[NSMutableDictionary alloc] init];
            }
            [userInfo setObject:httpMethod forKey:HTTP_METHOD_KEY];
            
            NSDictionary *oldHeader = nil;
            @try {
                oldHeader = [HTTPResponse allHeaderFields];
            }
            @catch (NSException *exception) {
                if(oldHeader == FALSE)
                {
                    oldHeader = [[NSDictionary alloc] init];
                }
            }
            
            NSMutableDictionary *header = oldHeader.mutableCopy;
            header[@"Cache-Control"] = [NSString stringWithFormat:@"max-age=%ldl", CACHE_TTL];
            NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                                   initWithURL:url
                                                   statusCode:200
                                                   HTTPVersion:@"HTTP/1.1"
                                                   headerFields:header];
            cachedResponse = [[NSCachedURLResponse alloc]
                              initWithResponse:modifiedResponse
                              data:[request HTTPBody]
                              userInfo:userInfo
                              storagePolicy:NSURLCacheStorageAllowed];
            request = singleReq;
        }
        else
        {
            if(results)
            {
                /* check if it is collection and store every item in single cache item */
                NSError* error;
                NSMutableArray* jsonArray = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
                
                /* seems to be an JSON array */
                if(error == false && jsonArray && [jsonArray isKindOfClass:[NSArray class]])
                {
//                    NSLog(@"Collection will be stored in cache");
                    NSMutableArray *hrefList = [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
                    NSURLResponse *response = cachedResponse.response;
                    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
                    
                    /* Save every item in single cache entry */
                    for (NSMutableDictionary* jsonRep in jsonArray)
                    {
                        NSString *href=[AOMDatastore concatHref:[jsonRep objectForKey: (@"href")] withQuery:nil];
                        NSURL *hrefURL = [NSURL URLWithString:href];
                        /* Convert Dictionary back to JSON string */
                        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonRep options:kNilOptions error:&error];
                        /* Save cache response for item */
                        NSURLRequest *singleReq = [NSURLRequest requestWithURL:hrefURL];
                        NSMutableDictionary *userInfo = [cachedResponse.userInfo mutableCopy];
                        NSMutableSet *linkedCollections = [[NSMutableSet alloc] init];
                        /* Check if there is already cache entry */
                        NSCachedURLResponse *singleCachedResp = [self cachedResponseForRequest:singleReq];
                        if(singleCachedResp)
                        {
                            /* Get old userInfo */
                            NSSet *oldLinkedCollections = [singleCachedResp.userInfo objectForKey:LINKED_COLLECTIONS_KEY];
                            if(oldLinkedCollections)
                            {
                                [linkedCollections addObjectsFromArray:[oldLinkedCollections allObjects]];
                            }
                        }
                        /* add href of collection request to userInfo */
                        [linkedCollections addObject:[request URL]];
                        if(userInfo == FALSE)
                        {
                            userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                        }
                        [userInfo setObject:linkedCollections forKey:LINKED_COLLECTIONS_KEY];
                        
                        NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                                               initWithURL:hrefURL
                                                               statusCode:HTTPResponse.statusCode
                                                               HTTPVersion:@"HTTP/1.1"
                                                               headerFields:HTTPResponse.allHeaderFields];
                        NSCachedURLResponse *singleResp = [[NSCachedURLResponse alloc]
                                                           initWithResponse:modifiedResponse
                                                           data:data
                                                           userInfo:userInfo
                                                           storagePolicy:cachedResponse.storagePolicy];
                        [[NSURLCache sharedURLCache] storeCachedResponse:singleResp forRequest:singleReq];
                        [hrefList addObject:href];
                    }
                    /* The cached response data for this collection request is a list of hrefs in JSON format */
                    NSMutableDictionary *userInfo = cachedResponse.userInfo.mutableCopy;
                    if(userInfo ==false)
                    {
                        userInfo = [[NSMutableDictionary alloc] init];
                    }
                    [userInfo setObject:[NSNumber numberWithBool:true] forKey:IS_COLLECTION_KEY];
                    NSData *collectionData = [NSJSONSerialization dataWithJSONObject:hrefList options:kNilOptions error:&error];
                    /* add custom header field to mark response as collection response */
                    NSMutableDictionary *modifiedHeaders = HTTPResponse.allHeaderFields.mutableCopy;
                    modifiedHeaders[IS_COLLECTION_KEY] = @"1";
                    NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                                           initWithURL:HTTPResponse.URL
                                                           statusCode:HTTPResponse.statusCode
                                                           HTTPVersion:@"HTTP/1.1"
                                                           headerFields:modifiedHeaders];
                    cachedResponse = [[NSCachedURLResponse alloc]
                                      initWithResponse:modifiedResponse
                                      data:collectionData
                                      userInfo:userInfo
                                      storagePolicy:cachedResponse.storagePolicy];
                }
            }
        }
        [super storeCachedResponse:cachedResponse forRequest:request];
    }
}

+ (NSDictionary*) getCachedDataForHrefs:(NSArray*) jsonArray
{
    NSData *retData =  nil;
    NSMutableArray *failedHrefs = [[NSMutableArray alloc] init];
    NSError *error = nil;

    BOOL notFound = false;
    /* Save every item in single cache entry */
    NSMutableArray *retA = [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
    for (NSString* href in jsonArray)
    {
        /* Get elem from cache */
        NSURLRequest *singleReq = [NSURLRequest requestWithURL:[NSURL URLWithString:href]];
        NSCachedURLResponse *singleResp =[[NSURLCache sharedURLCache] cachedResponseForRequest:singleReq];
        if(singleResp)
        {
            NSData *singleData = singleResp.data;
            if(singleData)
            {
                /* Convert data to JSON */
                NSDictionary *singleDict = [NSJSONSerialization JSONObjectWithData:singleData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
                [retA addObject:singleDict];
            }
            else
            {
                [failedHrefs addObject:href];
                notFound = true;
            }
        }
        else
        {
            [failedHrefs addObject:href];
            notFound = true;
        }
    }
    /* Convert collection array to JSON and set as data */
    retData = [NSJSONSerialization dataWithJSONObject:retA options:kNilOptions error:&error];
    
    if(notFound)
    {
        NSLog(@"Not all objects of collection were found in cache. Returned list maybe incomplete");
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:retData, CACHED_RETURN_DATA_KEY, failedHrefs, CACHED_RETURN_FAILED_KEY, nil];
}

+ (NSDictionary*) getCachedDataForCollection:(NSData*) collectionData
{
    NSError *error = nil;
    NSDictionary *retData = [NSDictionary dictionaryWithObjectsAndKeys:collectionData, CACHED_RETURN_DATA_KEY, nil, CACHED_RETURN_FAILED_KEY, nil];
    
    NSMutableArray* jsonArray = [NSJSONSerialization JSONObjectWithData:collectionData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    
    /* seems to be an JSON array */
    if(error == false && jsonArray && [jsonArray isKindOfClass:[NSArray class]])
    {
        retData = [self getCachedDataForHrefs:jsonArray];
#ifdef IS_TESTING
        [[AOMDatastore sharedInstance] setWasCacheHit:TRUE];
#endif
    }
    return retData;
}

#pragma mark Serializing/Deserializing of queues and maps
- (void) serializeMetadata
{
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    if(self.offlineQueue)
    {
        [saveDict setObject:[[self offlineQueue] operations] forKey:@"offlineQueue"];
    }
    
    if(self.mapIdToHref)
    {
        [saveDict setObject:[self mapIdToHref] forKey:@"mapIdToHref"];
    }
    
    [NSKeyedArchiver archiveRootObject:saveDict toFile:[[self filePath] stringByExpandingTildeInPath]];
}
- (void) deserializeMetadata
{
    NSMutableDictionary* storedData = [NSKeyedUnarchiver unarchiveObjectWithFile:[[self filePath] stringByExpandingTildeInPath]];
    if(storedData)
    {
        if(self.offlineQueue)
        {
            NSArray *storedOperations = [storedData objectForKey:@"offlineQueue"];
            [[self offlineQueue] addOperations:storedOperations waitUntilFinished:FALSE];
        }
        
        if(self.mapIdToHref)
        {
            NSDictionary *map = [storedData objectForKey:@"mapIdToHref"];
            if(map)
            {
                [self setMapIdToHref:map.mutableCopy];
            }
            map = nil;
        }
    }
}

- (void) updateCache
{
    [self serializeMetadata];
}

- (void)clearCache
{
    [self removeAllCachedResponses];
    /* Remove also persisted metadata */
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"operations"]) {
        if(change)
        {
            NSUInteger oldCnt = [[change objectForKey:@"old"] count];
            NSUInteger newCnt = [[change objectForKey:@"new"] count];
            /* Seems that task are completed so persist again */
            if(newCnt < oldCnt)
            {
                [self serializeMetadata];
            }
        }
    }
}

- (NSDictionary*) getSavedIDsForRequest:(NSURLRequest*)_request
{
    NSMutableDictionary *savedIds = [[NSMutableDictionary alloc] init];
    NSCachedURLResponse *cachedResponse = [[AOMModelStore sharedInstance] cachedResponseForRequest:_request];
    if(cachedResponse && [cachedResponse data])
    {
        /* Extract IDs */
        NSError *error = nil;
        NSDictionary *retData = [AOMModelStore getCachedDataForCollection:[cachedResponse data]];
        NSData *responseData = [retData objectForKey:CACHED_RETURN_DATA_KEY];
        NSArray *failedHrefs = [retData objectForKey:CACHED_RETURN_FAILED_KEY];
        NSMutableArray* jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        
        for (NSMutableDictionary* jsonRep in jsonArray)
        {
            /* Use dummy model */
            AOMAbstractClientDataModel* obj = [[AOMUser alloc] init];
            [obj fromJSONWithObject:jsonRep];
            NSNumber *lastModified = [NSNumber numberWithDouble:([[obj getLastModifiedAt] timeIntervalSince1970] * 1000)];
            NSString *objId = [obj getID];
            [savedIds setObject:lastModified forKey:objId];
        }
        /* Also add failed elements then maybe they were be deleted from previous requests */
        NSNumber *currentLM = [NSNumber numberWithDouble:([[NSDate date] timeIntervalSince1970])*1000 ];
        for (NSString *href in failedHrefs)
        {
            NSString *objId = [AOMModelHelper getIDFromHref:href];
            [savedIds setObject:currentLM forKey:objId];
        }
    }
    return (NSDictionary*)savedIds;
}

- (void) removeCachedResponseForRequest:(NSURLRequest *)request
{
    NSCachedURLResponse *cachedResponse = [self cachedResponseForRequest:request];
    [super removeCachedResponseForRequest:request];
    if(cachedResponse)
    {
        NSURL *collectionUrl = [request URL];
        NSData *collectionData = [cachedResponse data];
        if(collectionData)
        {
            NSError *error = NULL;
            /* Check if cache entry is collection */
            NSMutableArray* jsonArray = [NSJSONSerialization JSONObjectWithData:collectionData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            if(error == FALSE && jsonArray)
            {
                for (NSString *href in jsonArray)
                {
                    /* Check each cached object if this list is last link on it */
                    NSURLRequest *singleReq = [NSURLRequest requestWithURL:[NSURL URLWithString:href]];
                    NSCachedURLResponse *singleResp =[[NSURLCache sharedURLCache] cachedResponseForRequest:singleReq];
                    if(singleResp)
                    {
                       /* Check */
                       NSMutableSet *linkedCollections = [[singleResp.userInfo objectForKey:LINKED_COLLECTIONS_KEY] mutableCopy];
                        if([linkedCollections containsObject:collectionUrl])
                        {
                            /* Remove collection link */
                            [linkedCollections removeObject:collectionUrl];
                        }
                        /* Check if linkedCollections set is empty then delete object from cache */
                        if([linkedCollections count] == false)
                        {
                            [super removeCachedResponseForRequest:singleReq];
                        }
                        else
                        {
                            NSMutableDictionary *userInfo = [singleResp.userInfo  mutableCopy];
                            [userInfo setObject:linkedCollections forKey:LINKED_COLLECTIONS_KEY];
                            
                            /* Update single cache object */
                            singleResp =[[NSCachedURLResponse alloc] initWithResponse:singleResp.response data:singleResp.data userInfo:userInfo storagePolicy:singleResp.storagePolicy];
                            [self storeCachedResponse:singleResp forRequest:singleReq];
                        }
                    }
                }
              
            }
        }
    }
}

@end
