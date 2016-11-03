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
#import "AOMDatastore.h"
#import "NSString+Base64.h"
#import "AOMAbstractClientDataModel.h"
#import "NSString+Extensions.h"
#import "AOMModelStore.h"
#import "AOMURLConnection.h"
#import "AOMModelHelper.h"
#import "Reachability.h"
#import "AOMTokenContainer.h"

#define KEY_ERROR_CODE      @"code"
#define KEY_ERROR_MESSAGE   @"message"
#define KEY_EXPECTED_CODES   @"expectedCodes"
#define CONNECTION_FAILED_CODE   0
#define CONNECTION_FAILED   @"CONNECTION_FAILED"

NSString *const ApiomatRequestException = @"ApiomatRequestException";
NSString *const EmptyHrefException = @"EmptyHrefException";
NSString *const AOM_HEADER_DELTA = @"X-apiomat-delta";
NSString *const AOM_HEADER_DELTA_DELETED = @"X-apiomat-delta-deleted";
NSString *const AOM_SSO_REDIRECT_URL = @"aomSSOUrl";
NSString *const AOM_SSO_REDIRECT_DATA = @"aomSSOData";

@interface AOMAbstractClientDataModel (FriendClass)
@property (weak, nonatomic) NSString *href;
@end

@interface AOMDatastore()

@property (nonatomic) BOOL cacheInitalized;
@property (nonatomic, strong) NSMutableDictionary *mapHrefToETag;
@property (nonatomic, strong) NSMutableDictionary *mapHrefToLastModified;
typedef void (^AOMResponseBlock)(NSString* responseBlock, NSError *error);


- (NSString*) createHref:(NSString*) _href;
- (NSString*) classNameFromHref:(NSString*)_modelHref;
- (NSString*) postOnServerWithData: (NSData*) _data
                           andHref: (NSString*) _href;

- (void) postASyncOnServerWithData: (NSData*) _data
                           andHref: (NSString*) _href
              UsePersistentStorage:(BOOL) _usePersistentStorage
                  andCompleteBlock:(AOMResponseBlock) _completeBlock;

- (NSString*) getAuthenticationHeader:(AOMAuthType) _authType;
- (void)setHeader:(NSMutableURLRequest *)urlRequest AOMRequest:(AOMRequest*) _aomRequest;

- (void)raiseConnectionFailedException;
- (void)raiseApiomatExceptionWithErrorCode:(NSInteger) errorCode andExpectedCode:(NSInteger) expectedCode andReason:(NSString*)reason;
- (void)raiseApiomatExceptionWithErrorCode:(NSInteger) errorCode andExpectedCodes:(NSArray*) expectedCodes andReason:(NSString*)reason;

- (NSError*)createApiomatError:(NSInteger) errorCode expectedCode:(NSArray*)expectedCodes reason:(NSString*) reason;

- (NSData*) sendSyncRequest:(AOMRequest*)_request;
- (NSData*) getBinaryData:(AOMRequest*)_request withResponse: (NSURLResponse**) response;

- (void) sendAsyncRequest:(AOMRequest*)_request;
+ (NSURL*) getURLMinusQuery:(NSURL*) _url;
- (void) initCache;
- (BOOL) shouldSaveOffline:(Class) _clazz;
- (BOOL) isOfflineSupported:(BOOL) _canBeOffline;
- (BOOL) prepareForDeltaSync:(NSMutableURLRequest*) _request;
- (void) createResponseFromDeltaSync:(AOMURLConnection *)connection Error:(NSError **)error_p responseData:(NSData**)_serverResponseData headerFields:(NSDictionary *)headerFields;
#ifndef IS_TESTING
@property (nonatomic) BOOL hasConnection;
#endif
/*!
 Method for posting the class instance to the server in an update manner. That is, at the point using this method the class instance
 has a HREF and exists on the server.
 
 @param _dataModel class instance to store in backend
 @param _href HREF of the class instance to post (or the address to post the class instance to)
 @return the HREF of the posted class instance
 */
- (NSString*) postOnServer: (AOMAbstractClientDataModel*) _dataModel withHref: (NSString*) _href;
- (void) loadCountFromServerAsyncWithUrl:(NSString*) _url andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithLongResults) _block;
- (long) loadCountFromServerWithUrl:(NSString*) _url andQuery:(NSString*)_query;
+ (AOMDatastore*) configureWithUrl:(NSString*)_baseUrl
                     andUsedSystem:(NSString*) _usedSystem
                         andApiKey: (NSString*)_apiKey andAuthType:(AOMAuthType) _authType
                     andModelStore:(id<AOMModelStoreProtocol>)_modelStore andCredentials:(NSArray*) _credentials;
@end

@implementation AOMDatastore

@synthesize baseUrl = m_baseUrl;
@synthesize apiKey = m_apiKey;
@synthesize userName = m_userName;
@synthesize password = m_password;
@synthesize usedSystem = m_usedSystem;
@synthesize sessionToken = m_sessionToken;
@synthesize modelStore;
@synthesize loadWithLinks, hasConnection, cacheInitalized;
@synthesize cacheStrategy, authType;
@synthesize mapHrefToETag;
@synthesize mapHrefToLastModified;
@synthesize useDeltaSync = m_useDeltaSync;
@synthesize memoryCacheSize = m_memoryCacheSize;
@synthesize discCacheSize = m_discCacheSize;
@synthesize idPHosts = m_idPHosts;
@synthesize checkObjectState = m_checkObjectState;
#ifdef IS_TESTING
@synthesize wasCacheHit;
@synthesize actualRequest;
#endif
@synthesize requestTimeout = m_requestTimeout;

- (id)init
{
    self = [super init];
    if (self) {
        cacheStrategy = AOM_NETWORK_ELSE_CACHE;
        hasConnection = TRUE;
        mapHrefToETag = [[NSMutableDictionary alloc] init];
        mapHrefToLastModified = [[NSMutableDictionary alloc] init];
        m_useDeltaSync = FALSE;
        authType = AOMAuthTypeGUEST;
        m_idPHosts = [[NSArray alloc] init];
        /* By default 3MB Memory Cache and 20MB Disc Cache */
        m_memoryCacheSize = 3;
        m_discCacheSize = 20;
        [self initCache];
        m_checkObjectState = TRUE;
        m_requestTimeout = 30;
    }
    return self;
}

+ (AOMDatastore *)sharedInstance
{
    static dispatch_once_t pred;
    static AOMDatastore* sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[AOMDatastore alloc] init];
    });
    return sharedInstance;
}

+ (AOMDatastore*) configureWithUrl:(NSString*)_baseUrl
                     andUsedSystem:(NSString*) _usedSystem
                         andApiKey: (NSString*)_apiKey andAuthType:(AOMAuthType) _authType
                     andModelStore:(id<AOMModelStoreProtocol>)_modelStore andCredentials:(NSArray*) _credentials
{
    [AOMDatastore sharedInstance].baseUrl = _baseUrl;
    [AOMDatastore sharedInstance].modelStore = _modelStore;
    //If we have a model store we always have to load referenced hrefs
    if(_modelStore) {
        [AOMDatastore sharedInstance].loadWithLinks = true;
    }
    [AOMDatastore sharedInstance].apiKey = _apiKey;
    /* Set authType */
    [AOMDatastore sharedInstance].authType = _authType;
    /* Set usedSystem */
    [AOMDatastore sharedInstance].usedSystem = _usedSystem;
    
    if(_authType == AOMAuthTypeUSERNAME_PASSWORD)
    {
        [AOMDatastore sharedInstance].userName = [_credentials objectAtIndex:0];
        [AOMDatastore sharedInstance].password = [_credentials objectAtIndex:1];
    }
    else if(_authType == AOMAuthTypeOAUTH2_TOKEN)
    {
        [AOMDatastore sharedInstance].sessionToken = [_credentials objectAtIndex:0];
    }
    
    /* clear cache lists */
    [[[AOMDatastore sharedInstance] mapHrefToETag] removeAllObjects];
    [[[AOMDatastore sharedInstance] mapHrefToLastModified] removeAllObjects];
    return [AOMDatastore sharedInstance];

}

+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user
{
    return [AOMDatastore configureWithCredentials:_user andModelStore:nil];
}

+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user andModelStore:(id<AOMModelStoreProtocol>)_modelStore
{
    return [AOMDatastore configureWithCredentials:_user Params:[[NSDictionary alloc] init] andModelStore:_modelStore];
}

+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user andLoadWithLinks: (BOOL)_loadWithLinks
{
    [AOMDatastore sharedInstance].loadWithLinks = _loadWithLinks;
    return [AOMDatastore configureWithCredentials:_user andModelStore:nil];
}
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user andParams:(NSDictionary*) _params
{
    return [AOMDatastore configureWithCredentials:_user Params:_params andModelStore:nil];
}
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user Params:(NSDictionary*) _params andModelStore:(id<AOMModelStoreProtocol>)_modelStore
{
    NSString *bUrl = [_params objectForKey:@"baseUrl"]?:baseUrl;
    NSString *usedSystem = [_params objectForKey:@"usedSystem"]?:[AOMAbstractClientDataModel getSystem];
    NSString *_apiKey = [_params objectForKey:@"apiKey"]?:apiKey;
    AOMAuthType authType = AOMAuthTypeGUEST;
    NSArray *credentials = nil;
    if(_user)
    {
        authType = AOMAuthTypeUSERNAME_PASSWORD;
        credentials = [NSArray arrayWithObjects:[_user userName], [_user password], nil];
    }
    return [AOMDatastore configureWithUrl:bUrl andUsedSystem:usedSystem andApiKey:_apiKey andAuthType:authType andModelStore:_modelStore andCredentials:credentials];
}
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user Params:(NSDictionary*) _params andLoadWithLinks: (BOOL)_loadWithLinks
{
    [AOMDatastore sharedInstance].loadWithLinks = _loadWithLinks;
    return [AOMDatastore configureWithCredentials:_user Params:_params andModelStore:nil];
}

+ (AOMDatastore*)configureWithUser:(AOMUser*)_user
{
    return [AOMDatastore configureWithCredentials:_user];
}

+ (AOMDatastore*)configureWithUser:(AOMUser*)_user andModelStore:(id<AOMModelStoreProtocol>)_modelStore
{
    return [AOMDatastore configureWithCredentials:_user andModelStore:_modelStore];
}

+ (AOMDatastore*)configureWithUser:(AOMUser*)_user andLoadWithLinks: (BOOL)_loadWithLinks
{
    return [AOMDatastore configureWithCredentials:_user andLoadWithLinks:_loadWithLinks];
}

+ (AOMDatastore*)configureAsGuestWithUrl:(NSString*)_baseUrl
                        andApiKey: (NSString*)_apiKey
{
    return [AOMDatastore configureAsGuestWithUrl:_baseUrl andApiKey:_apiKey andModelStore:nil];
}

+ (AOMDatastore*)configureAsGuestWithUrl:(NSString*)_baseUrl
                        andApiKey: (NSString*)_apiKey
                    andModelStore:(id<AOMModelStoreProtocol>)_modelStore
{
    return [AOMDatastore configureWithUrl:_baseUrl andUsedSystem:[AOMAbstractClientDataModel getSystem] andApiKey:_apiKey andAuthType:AOMAuthTypeGUEST andModelStore:_modelStore andCredentials:nil];
}

+ (AOMDatastore*) configureAsGuestWithUrl:(NSString*)_baseUrl
                         andApiKey: (NSString*)_apiKey
                  andLoadWithLinks: (BOOL)_loadWithLinks
{
    [AOMDatastore sharedInstance].loadWithLinks = _loadWithLinks;
    return [AOMDatastore configureAsGuestWithUrl:_baseUrl andApiKey:_apiKey andModelStore:nil];
}

+ (AOMDatastore*)configureAsGuestWithParams:(NSDictionary*) params
{
    return [AOMDatastore configureAsGuestWithParams:params andModelStore:nil];
}
+ (AOMDatastore*)configureAsGuestWithParams:(NSDictionary*) params andModelStore:(id<AOMModelStoreProtocol>)_modelStore
{
    return [AOMDatastore configureWithCredentials:nil Params:params andModelStore:_modelStore];
}
+ (AOMDatastore*)configureAsGuestWithParams:(NSDictionary*) params andLoadWithLinks:(BOOL)_loadWithLinks
{
    [AOMDatastore sharedInstance].loadWithLinks = _loadWithLinks;
    return [AOMDatastore configureAsGuestWithParams:params andModelStore:nil];
}

+ (AOMDatastore*)configureWithSessionTokenFromUser:(AOMUser*)_user
{
    return [AOMDatastore configureWithSessionTokenFromUser:_user andModelStore:nil];
}

+ (AOMDatastore*)configureWithSessionTokenFromUser:(AOMUser*)_user andModelStore:(id<AOMModelStoreProtocol>)_modelStore
{
    return [AOMDatastore configureWithSessionToken:[_user sessionToken] andWithUrl:baseUrl andApiKey:apiKey andUsedSystem:[AOMAbstractClientDataModel getSystem] andModelStore:_modelStore];
}

+ (AOMDatastore*)configureWithSessionTokenFromUser:(AOMUser*)_user andLoadWithLinks: (BOOL)_loadWithLinks
{
    [AOMDatastore sharedInstance].loadWithLinks = _loadWithLinks;
    return [AOMDatastore configureWithSessionTokenFromUser:_user andModelStore:nil];
}
+ (AOMDatastore*)configureWithSessionToken:(NSString*)_sessionToken andWithUrl:(NSString*)_baseUrl
                                 andApiKey: (NSString*)_apiKey andUsedSystem: (NSString*)_usedSystem
{
    return [AOMDatastore configureWithSessionToken:_sessionToken andWithUrl:_baseUrl andApiKey:_apiKey andUsedSystem:_usedSystem andModelStore:nil];
}
+ (AOMDatastore*)configureWithSessionToken:(NSString*)_sessionToken andWithUrl:(NSString*)_baseUrl
                                 andApiKey: (NSString*)_apiKey
                             andUsedSystem: (NSString*)_usedSystem
                             andModelStore:(id<AOMModelStoreProtocol>)_modelStore
{
    NSString *bUrl = _baseUrl?:baseUrl;
    NSString *usedSystem = _usedSystem?:[AOMAbstractClientDataModel getSystem];
    NSString *aKey = _apiKey?:apiKey;
    return [AOMDatastore configureWithUrl:bUrl andUsedSystem:usedSystem andApiKey:aKey andAuthType:AOMAuthTypeOAUTH2_TOKEN andModelStore:_modelStore andCredentials:[NSArray arrayWithObject:_sessionToken]];
}

+ (AOMDatastore*)configureWithSessionToken:(NSString*)_sessionToken andWithUrl:(NSString*)_baseUrl
                                 andApiKey: (NSString*)_apiKey
                             andUsedSystem: (NSString*)_usedSystem
                          andLoadWithLinks: (BOOL)_loadWithLinks
{
    [AOMDatastore sharedInstance].loadWithLinks = _loadWithLinks;
    return [AOMDatastore configureWithSessionToken:_sessionToken andWithUrl:_baseUrl andApiKey:_apiKey                              andUsedSystem:_usedSystem andModelStore:nil];
}

+ (AOMDatastore*) setCachingStrategy:(AOMCacheStrategy) _cacheStrategy
{
    [[AOMDatastore sharedInstance] setCacheStrategy:_cacheStrategy];
    
    return [AOMDatastore sharedInstance];
}

+ (AOMDatastore*) setCacheSize:(long)_memoryCacheSize DiscCacheSize:(long)_discCacheSize
{
    [[AOMDatastore sharedInstance] setMemoryCacheSize:_memoryCacheSize];
    [[AOMDatastore sharedInstance] setDiscCacheSize:_discCacheSize];
    return [AOMDatastore sharedInstance];
}

+ (long) getMemoryCacheSize
{
    return [[AOMDatastore sharedInstance] memoryCacheSize];
}

+ (long) getDiscCacheSize
{
    return [[AOMDatastore sharedInstance] discCacheSize];
}

- (void) setDiscCacheSize: (long) _cacheSize
{
    m_discCacheSize = _cacheSize;
    /* Set also size of NSURLCache */
    if([self cacheInitalized] && [AOMModelStore sharedInstance])
    {
        [[AOMModelStore sharedInstance] setDiskCapacity:m_discCacheSize*1000000];
    }
}

- (void) setMemoryCacheSize: (long) _cacheSize
{
    m_memoryCacheSize = _cacheSize;
    /* Set also size in NSURLCache */
    if([self cacheInitalized] && [AOMModelStore sharedInstance])
    {
        [[AOMModelStore sharedInstance] setMemoryCapacity:m_memoryCacheSize*1000000];
    }
}

#pragma mark - Post requests
- (NSString*) postOnServer: (AOMAbstractClientDataModel*) _dataModel
{
    /* Check offline mode and if offline is supported for this class */
    if([self shouldSaveOffline:[_dataModel class]])
    {
        /* Send to offline storage */
        return [[AOMModelStore sharedInstance] addTask:_dataModel withUrl:nil andHttpMethod:@"POST" andReferenceName:nil];
    }
    else
    {
        return [self postOnServer:_dataModel withHref:[self createModelHrefFromClass:[_dataModel class]]];
    }
}

- (NSString*) postReferenceOnServer:(NSString*) _referenceName Model:(AOMAbstractClientDataModel*) _dataModel
                               Href: (NSString*) _href ParentHref:(NSString*)_parentHref
{
    /* Check offline mode and if offline is supported for this class */
    if([self shouldSaveOffline:[_dataModel class]])
    {
        /* Send to offline storage */
        if([NSString isEmptyString:_href])
        {
            /* Create HREF like on server */
            _href = [_parentHref stringByAppendingPathComponent:_referenceName];
        }
        return [[AOMModelStore sharedInstance] addTask:_dataModel withUrl:_href andHttpMethod:@"POST" andReferenceName:_referenceName];
    }
    else
    {
        return [self postOnServer:_dataModel withHref:_href];
    }
}

- (NSString*) postOnServer: (AOMAbstractClientDataModel*) _model
                  withHref: (NSString*) _href
{
    //check current state of object (If already in save process than throw error)
    if([_model isIllegalObjectState:@"POST"])
    {
        [self raiseApiomatExceptionWithErrorCode:AOMIN_PERSISTING_PROCESS andExpectedCode:201 andReason:[AOMStatus getReasonPhraseForCode:AOMIN_PERSISTING_PROCESS]];
        return FALSE;
    }
    [_model setObjectState:ObjectState_PERSISTING];
    
    NSString *href = nil;
    NSData* data = [_model toJson];
    @try {
        href = [self postOnServerWithData:data andHref:_href];
        [_model setHref:href];
        
        if([self modelStore]) {
            [[self modelStore] addModel:_model];
        }
    }
    @catch (NSException *exception) {
        [exception raise];
    }
    @finally {
        [_model setObjectState:ObjectState_PERSISTED];
    }
    return href;
}

- (NSString*) postOnServerWithData: (NSData*) _data
                           andHref: (NSString*) _href
{
    //Check if HREF exists
    NSParameterAssert([NSString isEmptyString:_href]==false);
    AOMRequest *request = [[AOMRequest alloc] initWithURL:_href httpMethod:@"POST" expectedCode:201 responseBlock:nil];
    [request setHttpBody:_data];
    NSData* result = [self sendSyncRequest:request];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

- (NSString*) postStaticDataOnServer: (NSData*) _rawData
                             asImage: (BOOL) _isImage UsePersistentStorage:(BOOL) _usePersistentStorage
{
    NSString* href = [self createStaticDataHref:_isImage];
    /* Check offline mode and if offline is supported for this class */
    if([self isOfflineSupported:_usePersistentStorage])
    {
        /* Send to offline storage */
        return [[AOMModelStore sharedInstance] addStaticTask:_rawData withUrl:href andHttpMethod:@"POST" IsImage:_isImage];
    }
    else
    {
        return [self postOnServerWithData:_rawData andHref:href];
    }
}

#pragma mark Async post request

- (void) postOnServerAsync:(AOMAbstractClientDataModel*)_dataModel UsePersistentStorage:(BOOL) _usePersistentStorage withFinishingBlock:(AOMBlockWithHref) _block
{
    [self postOnServerAsync:_dataModel withHref:[self createModelHrefFromClass:[_dataModel class]]  UsePersistentStorage:_usePersistentStorage andFinishingBlock:_block];
}

- (void) postReferenceOnServerAsync:(NSString*) _referenceName Model:(AOMAbstractClientDataModel*)_dataModel withHref: (NSString*) _href ParentHref:(NSString*) _parentHref UsePersistentStorage:(BOOL) _usePersistentStorage andFinishingBlock:(AOMBlockWithHref) _finishingBlock
{
    /* Check offline handling */
    if([self isOfflineSupported:_usePersistentStorage])
    {
        /* Send to offline storage */
        if([NSString isEmptyString:_href])
        {
            /* Create HREF like on server */
            _href = [_parentHref stringByAppendingPathComponent:_referenceName];
        }
        NSString *localHref = [[AOMModelStore sharedInstance] addTask:_dataModel withUrl:_href andHttpMethod:@"POST" andReferenceName:_referenceName];
        /* Call block */
        if(_finishingBlock)
        {
            _finishingBlock(localHref, nil);
        }
    }
    else
    {
        [self postOnServerAsync:_dataModel withHref:_href UsePersistentStorage:_usePersistentStorage andFinishingBlock:_finishingBlock];
    }
}

- (void) postOnServerAsync:(AOMAbstractClientDataModel*)_dataModel  withHref: (NSString*) _href UsePersistentStorage:(BOOL)_usePersistentStorage andFinishingBlock:(AOMBlockWithHref) _finishingBlock
{
    //check current state of object (If already in save process than throw error)
    if([_dataModel isIllegalObjectState:@"POST"])
    {
        if(_finishingBlock)
        {
            _finishingBlock(Nil, [self createApiomatError:AOMIN_PERSISTING_PROCESS expectedCode:[NSArray arrayWithObjects:[NSNumber numberWithInt:200], nil] reason:[AOMStatus getReasonPhraseForCode:AOMIN_PERSISTING_PROCESS]]);
        }
        return;
    }
    
    /* Check if offline */
    if([self isOfflineSupported:_usePersistentStorage])
    {
        NSString *localHref = [[AOMModelStore sharedInstance] addTask:_dataModel withUrl:nil andHttpMethod:@"POST" andReferenceName:nil];
        /* Call block */
        if(_finishingBlock)
        {
            _finishingBlock(localHref, nil);
        }
    }
    else
    {
        [_dataModel setObjectState:ObjectState_PERSISTING];
        NSData* data = [_dataModel toJson];
        AOMResponseBlock completeBlock = ^(NSString *responseStr, NSError *error){
            if(error==FALSE)
            {
                [_dataModel setHref:responseStr];
                
                if([self modelStore]) {
                    [[self modelStore] addModel:_dataModel];
                }
            }
            [_dataModel setObjectState:ObjectState_PERSISTED];
            //For normal post req responseStr==HREF of new object
            if (_finishingBlock) {
                _finishingBlock(responseStr, error);
            }
        };
        
        [self postASyncOnServerWithData:data andHref:_href UsePersistentStorage:_usePersistentStorage andCompleteBlock:completeBlock];
    }
}

- (void) postStaticDataOnServerAsync:(NSData*) _rawData  asImage:(BOOL) _isImage UsePersistentStorage:(BOOL) _usePersistentStorage andFinishingBlock:(AOMBlockWithHref) _block
{
    NSString* href = [self createStaticDataHref:_isImage];
    AOMResponseBlock completeBlock = ^(NSString *responseStr, NSError *error){
        //For post req responseStr==HREF of object
        if (_block) {
            _block(responseStr, error);
        }
    };
    /* Check offline mode and if offline is supported for this class */
    if([self isOfflineSupported:_usePersistentStorage])
    {
        /* Send to offline storage */
        NSString *imgHref = [[AOMModelStore sharedInstance] addStaticTask:_rawData withUrl:href andHttpMethod:@"POST" IsImage:_isImage];
        completeBlock(imgHref, nil);
    }
    else
    {
        [self postASyncOnServerWithData:_rawData andHref:href
                   UsePersistentStorage:_usePersistentStorage andCompleteBlock:completeBlock];
    }
}

- (void) postASyncOnServerWithData: (NSData*) _data
                           andHref: (NSString*) _href
              UsePersistentStorage:(BOOL) _usePersistentStorage andCompleteBlock:(AOMResponseBlock) _completeBlock;
{
    NSParameterAssert([NSString isEmptyString:_href]==false);
    /* convert data block to string block */
    AOMResponseDataBlock completeBlock = ^(NSData *responseData, NSError *aomError) {
        NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        _completeBlock(responseString, aomError);
    };
    
    AOMRequest *request = [[AOMRequest alloc] initWithURL:_href httpMethod:@"POST" expectedCode:201 responseBlock:completeBlock];
    [request setHttpBody:_data];
    [request setStoreInCache:_usePersistentStorage];
    
    [self sendAsyncRequest:request];
}
#pragma mark - Delete requests
- (BOOL) deleteOnServerWithUrl:(NSString *)_modelHref UsePersistentStorage:(BOOL) _usePersistentStorage
{
    BOOL wasSuccess = FALSE;
    //Check if HREF exists
    NSParameterAssert([NSString isEmptyString:_modelHref]==false);
    
    /* Check offline mode and if offline is supported for this class */
    if([self isOfflineSupported:_usePersistentStorage])
    {
        NSString *localHref = [[AOMModelStore sharedInstance] addStaticTask:nil withUrl:_modelHref andHttpMethod:@"DELETE" IsImage:FALSE];
        wasSuccess = localHref != nil;
    }
    else
    {
        AOMRequest *request = [[AOMRequest alloc] initWithURL:_modelHref httpMethod:@"DELETE" expectedCode:204 responseBlock:nil];
        NSData* responseString = [self sendSyncRequest:request];
        wasSuccess = responseString != nil;
    }
    if([self modelStore]) {
        AOMAbstractClientDataModel *model = [[self modelStore] modelWithHref:_modelHref];
        if(model)
        {
            [[self modelStore] removeModel:model];
        }
    }
    
    return wasSuccess;
}

- (BOOL) deleteOnServer: (AOMAbstractClientDataModel*) _model
{
    BOOL retValue = FALSE;
    NSString *urlString = [_model getHref];
    /* Check offline mode and if offline is supported for this class */
    if([self shouldSaveOffline:[_model class]])
    {
        NSString *localHref = [[AOMModelStore sharedInstance] addTask:_model withUrl:urlString andHttpMethod:@"DELETE" andReferenceName:nil];
        retValue = localHref != nil;
    }
    else
    {
        retValue = [self deleteOnServerWithUrl:urlString UsePersistentStorage:FALSE];
    }
    
    return retValue;
}

#pragma mark - async delete requests
- (void) deleteOnServerAsyncWithUrl:(NSString *)_modelHref UsePersistentStorage:(BOOL) _usePersistentStorage withFinishingBlock:(AOMEmptyBlock)_block
{
    //Check if HREF exists
    NSParameterAssert([NSString isEmptyString:_modelHref]==false);
    
    //only handle isOfflineSupported again if it is resource request and called from external
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1]; // Example: 1   UIKit                               0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    
    NSLog(@"Function caller = %@", [array objectAtIndex:4]);
    BOOL wasCalledInternal = [[array objectAtIndex:4]  isEqual: @"deleteOnServerAsync:UsePersistentStorage:withFinishingBlock:"];
    /* Check offline mode and if offline is supported for this case */
    if(wasCalledInternal == FALSE && [self isOfflineSupported:_usePersistentStorage])
    {
        [[AOMModelStore sharedInstance] addStaticTask:nil withUrl:_modelHref andHttpMethod:@"DELETE" IsImage:FALSE];
        if(_block)
        {
            _block(nil);
        }
    }
    else
    {
        AOMRequest *request = [[AOMRequest alloc] initWithURL:_modelHref httpMethod:@"DELETE" expectedCode:204 responseBlock:^(NSData *responseBlock, NSError *error) {
            //Delete also from modelstore
            if([self modelStore]) {
                AOMAbstractClientDataModel *model = [[self modelStore] modelWithHref:_modelHref];
                if(model)
                {
                    [[self modelStore] removeModel:model];
                }
            }
            if(_block)
            {
                _block(error);
            }
        } ];
        
        [request setStoreInCache:_usePersistentStorage];
        [self sendAsyncRequest:request];
    }
}
- (void) deleteOnServerAsync:(AOMAbstractClientDataModel*) _model UsePersistentStorage:(BOOL) _usePersistentStorage withFinishingBlock:(AOMEmptyBlock)_block
{
    /* Check offline mode and if offline is supported */
    if([self isOfflineSupported:_usePersistentStorage])
    {
        [[AOMModelStore sharedInstance] addTask:_model withUrl:[_model getHref] andHttpMethod:@"DELETE" andReferenceName:nil];
        if(_block)
        {
            _block(nil);
        }
    }
    else
    {
        [self deleteOnServerAsyncWithUrl:[_model getHref] UsePersistentStorage:_usePersistentStorage withFinishingBlock:_block];
    }
}

#pragma mark - Update requests
- (BOOL) updateOnServer: (AOMAbstractClientDataModel*) _model
{
    BOOL response = FALSE;
    
    //check current state of object (If already in save process than throw error)
    if([_model isIllegalObjectState:@"PUT"])
    {
        [self raiseApiomatExceptionWithErrorCode:AOMIN_PERSISTING_PROCESS andExpectedCode:200 andReason:[AOMStatus getReasonPhraseForCode:AOMIN_PERSISTING_PROCESS]];
        return FALSE;
    }
    [_model setObjectState:ObjectState_PERSISTING];
    
    NSString *urlString = [_model getHref];
    
    if([self shouldSaveOffline:[_model class]])
    {
        /* Send to offline storage */
        NSString *tmpHref = [[AOMModelStore sharedInstance] addTask:_model withUrl:urlString andHttpMethod:@"PUT" andReferenceName:nil];
        response = tmpHref != nil;
    }
    else
    {
        NSData* jsonStr = [_model toJson];
        @try {
            response = [self updateOnServerWithUrl:urlString andJson:jsonStr];
        }
        @catch (NSException *exception) {
            [exception raise];
        }
        @finally {
            [_model setObjectState:ObjectState_PERSISTED];
        }
    }
    
    return response;
}

- (BOOL) updateOnServerWithUrl: (NSString*) _url andJson: (NSData*) _json
{
    //Check if URL exists
    NSParameterAssert([NSString isEmptyString:_url]==false);
    NSData* responseData = nil;
    
    @try {
        AOMRequest *request = [[AOMRequest alloc] initWithURL:_url httpMethod:@"PUT" expectedCode:200 responseBlock:nil];
        [request setHttpBody:_json];
        responseData = [self sendSyncRequest:request];
    }
    @catch (NSException *exception) {
        [exception raise];
    }
    
    return responseData != nil;
}

- (void) updateOnServerAsync: (AOMAbstractClientDataModel*) _model UsePersistentStorage:(BOOL)_usePersistentStorage withFinishingBlock:(AOMEmptyBlock)_block
{
    //check current state of object (If already in save process than throw error)
    if([_model isIllegalObjectState:@"PUT"])
    {
        if(_block)
        {
            _block([self createApiomatError:AOMIN_PERSISTING_PROCESS expectedCode:[NSArray arrayWithObjects:[NSNumber numberWithInt:200], nil] reason:[AOMStatus getReasonPhraseForCode:AOMIN_PERSISTING_PROCESS]]);
        }
        return;
    }
    [_model setObjectState:ObjectState_PERSISTING];
    
    NSString *href = [_model getHref];
    
    if([self isOfflineSupported:_usePersistentStorage])
    {
        /* Send to offline storage */
        [[AOMModelStore sharedInstance] addTask:_model withUrl:href andHttpMethod:@"PUT" andReferenceName:nil];
        if(_block)
        {
            _block(nil);
        }
    }
    else
    {
        [self updateOnServerAsyncWithUrl: href withJson:[_model toJson] UsePersistentStorage:_usePersistentStorage andWithFinishingBlock:^(NSError *error) {
            [_model setObjectState:ObjectState_PERSISTED];
            if(_block)
            {
                _block(error);
            }
        }];
    }
}

- (void) updateOnServerAsyncWithUrl: (NSString*) _url withJson: (NSData*) _json UsePersistentStorage:(BOOL)_usePersistentStorage andWithFinishingBlock:(AOMEmptyBlock)_block
{
    //Check if _url exists
    NSParameterAssert([NSString isEmptyString:_url]==false);
    AOMRequest *request = [[AOMRequest alloc] initWithURL:_url httpMethod:@"PUT" expectedCode:200 responseBlock:^(NSData *responseBlock, NSError *error) {
        if(_block)
        {
            _block(error);
        }
    }];
    [request setHttpBody:_json];
    [request setStoreInCache:_usePersistentStorage];
    
    [self sendAsyncRequest:request];
}

#pragma mark - Getter requests
- (AOMAbstractClientDataModel*) loadFromServerWithHref: (NSString*) _modelHref
                                           andStoreIn :(AOMAbstractClientDataModel*) _dataModel
{
    NSParameterAssert([NSString isEmptyString:_modelHref]==false);
    //check current state of object (If already in save process than throw error)
    if(_dataModel && [_dataModel isIllegalObjectState:@"GET"])
    {
        [self raiseApiomatExceptionWithErrorCode:AOMIN_PERSISTING_PROCESS andExpectedCode:200 andReason:[AOMStatus getReasonPhraseForCode:AOMIN_PERSISTING_PROCESS]];
        return _dataModel;
    }
    NSString *urlString = [AOMDatastore concatHref: _modelHref withQuery: nil];
    AOMRequest *request = [[AOMRequest alloc] initWithURL:urlString httpMethod:@"GET" expectedCodes:[NSArray arrayWithObjects:[NSNumber numberWithInt:200],[NSNumber numberWithInt:204], nil] responseBlock:nil];
    NSData* responseData = [self sendSyncRequest:request];
    
    if (responseData)
    {
        [_dataModel fromJson:responseData];
        
        //If we got empty response ignore and return nil
        if ([NSString isEmptyString:[_dataModel getHref]]) {
            return nil;
        }
        if([self modelStore]) {
            [[self modelStore] addModel:_dataModel];
        }
    } else {
        [self raiseConnectionFailedException];
    }
    return _dataModel;
}

- (NSMutableArray*) loadListFromServerWithClass:(Class)_class andQuery: (NSString*) _query
{
    NSString* url = [self createModelHrefFromClass:_class];
    return [self loadFromServerWithHref:url andClass:_class andQuery:_query];
}

- (NSMutableArray*) loadFromServerWithHref:(NSString*) _modelHref andClass: (Class) _class andQuery:(NSString*) _query {
    NSMutableArray* resultArray = nil;
    
    NSParameterAssert([NSString isEmptyString:_modelHref]==false);
    
    NSString *urlString = [AOMDatastore concatHref: _modelHref withQuery: _query];
    AOMRequest *request = [[AOMRequest alloc] initWithURL:urlString httpMethod:@"GET" expectedCode:200 responseBlock:nil];
    NSData* results = [self sendSyncRequest:request];
    
    if (results)
    {
        NSError* error;
        NSMutableArray* jsonArray = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        resultArray = [[NSMutableArray alloc] init];
        
        for (NSMutableDictionary* jsonRep in jsonArray)
        {
            AOMAbstractClientDataModel* obj = nil;
            NSString *className = [AOMAbstractClientDataModel objectTypeFromJson:jsonRep];
            if(className)
            {
                obj = [[NSClassFromString(className) alloc] init];
                /* if we  can't init object with this class name we check for AOM prefix and try it again */
                if(_class && [NSStringFromClass(_class) hasPrefix:@"AOM"])
                {
                   obj = [[NSClassFromString([@"AOM" stringByAppendingString:className]) alloc] init];
                }
            }

            if(obj == nil)
            {
                obj = [[_class alloc] init];
            }
            [obj fromJSONWithObject:jsonRep];
            [resultArray addObject:obj];
            if([self modelStore])
            {
                [[self modelStore] addModel:obj];
            }
        }
    }
    return resultArray;
}

- (long) loadCountFromServerWithClass:(Class) _class andQuery:(NSString*) _query
{

    NSString* cntUrl = [NSString stringWithFormat:@"%@/count", [self createModelHrefFromClass:_class]];
    return [self loadCountFromServerWithUrl:cntUrl andQuery:_query];
}
- (long) loadCountFromServerWithHref:(NSString*) _href andQuery:(NSString*) _query ForReference:(NSString*)_refName
{
    NSString* cntUrl = [NSString stringWithFormat:@"%@/%@/count", _href, _refName];
    return [self loadCountFromServerWithUrl:cntUrl andQuery:_query];
}

- (long) loadCountFromServerWithUrl:(NSString*) _url andQuery:(NSString*)_query
{
    long long cnt = 0;
    NSParameterAssert([NSString isEmptyString:_url]==false);
    
    NSString *urlString = [AOMDatastore concatHref: _url withQuery: _query];
    AOMRequest *request = [[AOMRequest alloc] initWithURL:urlString httpMethod:@"GET" expectedCode:200 responseBlock:nil];
    NSData* results = [self sendSyncRequest:request];
    if (results) {
        /* Convert to long */
        NSString* cntStr = [[NSString alloc] initWithData:results encoding:NSUTF8StringEncoding];
        cnt = [cntStr longLongValue];
    }
    return cnt;
}

#pragma mark - Async getter methods
- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andFinishingBlock:(AOMBlockWithResult) _block andStoreOffline:(BOOL)_storeOffline
{
    [self loadFromServerAsyncWithHref:_modelHref andStoreIn:Nil andFinishingBlock:_block andStoreOffline:_storeOffline];
}
- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andStoreIn:(AOMAbstractClientDataModel*) _model andFinishingBlock:(AOMBlockWithResult) _block andStoreOffline:(BOOL)_storeOffline
{
    NSParameterAssert([NSString isEmptyString:_modelHref]==false);
    //check current state of object (If already in save process than throw error)
    if(_model && [_model isIllegalObjectState:@"GET"])
    {
        if(_block)
        {
            _block(Nil, [self createApiomatError:AOMIN_PERSISTING_PROCESS expectedCode:[NSArray arrayWithObjects:[NSNumber numberWithInt:200], nil] reason:[AOMStatus getReasonPhraseForCode:AOMIN_PERSISTING_PROCESS]]);
        }
        return ;
    }
    NSString *urlString = [AOMDatastore concatHref: _modelHref withQuery: nil];
    AOMResponseDataBlock completeBlock = ^(NSData *responseData, NSError *error) {
        bool isOk = TRUE;
        AOMAbstractClientDataModel *obj = _model;
        if (responseData && error==FALSE)
        {
            if(obj==FALSE)
            {
                NSString *className = [self classNameFromHref:_modelHref ];
                obj = [[NSClassFromString(className) alloc] init];
            }
            [obj fromJson:responseData];
            
            //If we got empty response ignore and return nil
            if ([NSString isEmptyString:[obj getHref]])
            {
                isOk = FALSE;
            }
            if([self modelStore])
            {
                [[self modelStore] addModel:obj];
            }
        }
        if(_block)
        {
            _block(isOk?obj:Nil, error);
        }
    };
    
    AOMRequest *request = [[AOMRequest alloc] initWithURL:urlString httpMethod:@"GET" expectedCodes:[NSArray arrayWithObjects:[NSNumber numberWithInt:200],[NSNumber numberWithInt:204], nil] responseBlock:completeBlock];
    [request setStoreInCache:_storeOffline];
    [self sendAsyncRequest:request];
}

- (void) loadListFromServerAsyncWithClass:(Class)_class andQuery: (NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block
{
    NSString* url = [self createModelHrefFromClass:_class];
    [self loadFromServerAsyncWithHref:url andClass:_class andQuery:_query andFinishingBlock:_block andStoreOffline:FALSE];
}
- (void) loadListFromServerAsyncWithClass:(Class)_class andQuery: (NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block andStoreOffline:(BOOL)_storeOffline
{
    NSString* url = [self createModelHrefFromClass:_class];
    [self loadFromServerAsyncWithHref:url andClass:_class andQuery:_query andFinishingBlock:_block andStoreOffline:_storeOffline];
}

- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andClass: (Class) _class andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block
{
    [self loadFromServerAsyncWithHref:_modelHref andClass:_class andQuery:_query andFinishingBlock:_block andStoreOffline:FALSE];
}

- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andClass: (Class) _class andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block andStoreOffline:(BOOL)_storeOffline
{
    NSParameterAssert([NSString isEmptyString:_modelHref]==false);
    
    AOMResponseDataBlock completeBlock = ^(NSData *result, NSError *error){
        NSMutableArray *resultArray = Nil;
        if (result && error==FALSE)
        {
            NSMutableArray* jsonArray = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            resultArray = [[NSMutableArray alloc] init];
            
            for (NSMutableDictionary* jsonRep in jsonArray)
            {
                AOMAbstractClientDataModel* obj = nil;
                NSString *className = [AOMAbstractClientDataModel objectTypeFromJson:jsonRep];
                if(className)
                {
                    obj = [[NSClassFromString(className) alloc] init];
                    /* if we  can't init object with this class name we check for AOM prefix and try it again */
                    if(_class && [NSStringFromClass(_class) hasPrefix:@"AOM"])
                    {
                        obj = [[NSClassFromString([@"AOM" stringByAppendingString:className]) alloc] init];
                    }
                }
                
                if(obj == nil)
                {
                    obj = [[_class alloc] init];
                }
                
                [obj fromJSONWithObject:jsonRep];
                [resultArray addObject:obj];
                if([self modelStore])
                {
                    [[self modelStore] addModel:obj];
                }
            }
        }
        
        //Call caller
        if (_block)
        {
            _block(resultArray, error);
        }
    };
    
    NSString *urlString = [AOMDatastore concatHref: _modelHref withQuery: _query];
    AOMRequest *request = [[AOMRequest alloc] initWithURL:urlString httpMethod:@"GET" expectedCode:200 responseBlock:completeBlock];
    [request setStoreInCache:_storeOffline];
    [self sendAsyncRequest:request];
}

- (NSData*) loadResourceWithHref:(NSString *)_href
{
    NSParameterAssert([NSString isEmptyString:_href]==false);
    
    NSData *result = nil;
    NSURLResponse *response = nil;
    AOMRequest *request = [[AOMRequest alloc] initWithURL:_href httpMethod:@"GET" expectedCodes:[NSArray arrayWithObjects:[NSNumber numberWithInt:200],[NSNumber numberWithInt:206], nil] responseBlock:nil];
    [request setIsBinaryData:TRUE];
    
    result = [self getBinaryData:request withResponse:&response];
    
    if (result)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if([httpResponse statusCode] != 200 && [httpResponse statusCode] != 206)
        {
            NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            [self raiseApiomatExceptionWithErrorCode:[httpResponse statusCode] andExpectedCode:200 andReason:responseString];
        }
        else
        {
            //add returned last modified/eTag to list for req
            if(cacheStrategy != AOM_NETWORK_ONLY)
            {
                NSURL *reqURL = [AOMDatastore getURLMinusQuery:[response URL]];
                NSString *lastModified = [[httpResponse allHeaderFields] objectForKey:@"Last-Modified"];
                /* Update list with lastModified */
                if(lastModified)
                {
                    [mapHrefToLastModified setObject:lastModified forKey:reqURL];
                }
                NSString *eTag = [[httpResponse allHeaderFields] objectForKey:@"ETag"];
                /* Update list with eTag */
                if(eTag)
                {
                    [mapHrefToETag setObject:eTag forKey:reqURL];
                }
            }
        }
    }
    else
    {
        [self raiseConnectionFailedException];
    }
    
    return result;
}

- (void) loadResourceAsyncWithHref: (NSString*) _href StoreOffline:(BOOL)_storeOffline andWithFinishingBlock:(AOMBlockWithNSDataResults) _block
{
    NSParameterAssert([NSString isEmptyString:_href]==false);
    
    AOMRequest *request = [[AOMRequest alloc] initWithURL:_href httpMethod:@"GET" expectedCodes:[NSArray arrayWithObjects:[NSNumber numberWithInt:200],[NSNumber numberWithInt:206], nil] responseBlock:^(NSData *responseData, NSError *aomError) {
        if(_block)
        {
            _block(responseData, aomError);
        }
    }];
    [request setIsBinaryData:true];
    [request setStoreInCache:_storeOffline];
    [self sendAsyncRequest:request];
}

- (void) loadCountFromServerAsyncWithClass:(Class) _class andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithLongResults) _block
{
    NSString* cntUrl = [NSString stringWithFormat:@"%@/count", [self createModelHrefFromClass:_class]];
    [self loadCountFromServerAsyncWithUrl:cntUrl andQuery:_query andFinishingBlock:_block];
}

- (void) loadCountFromServerAsyncWithHref:(NSString*) _href andQuery:(NSString*) _query ForReference:(NSString*)_refName andFinishingBlock:(AOMBlockWithLongResults) _block
{
    NSString* cntUrl = [NSString stringWithFormat:@"%@/%@/count", _href, _refName];
    [self loadCountFromServerAsyncWithUrl:cntUrl andQuery:_query andFinishingBlock:_block];
}

- (void) loadCountFromServerAsyncWithUrl:(NSString*) _url andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithLongResults) _block
{
    NSParameterAssert([NSString isEmptyString:_url]==false);
    
    NSString *urlString = [AOMDatastore concatHref:_url withQuery: _query];
    
    AOMResponseDataBlock completeBlock = ^(NSData *result, NSError *error){
        long long cnt = 0;
        if (result && error==FALSE)
        {
            /* Convert to long */
            NSString* cntStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            cnt = [cntStr longLongValue];
        }
        
        //Call caller
        if (_block)
        {
            _block(cnt, error);
        }
    };
    
    AOMRequest *request = [[AOMRequest alloc] initWithURL:urlString httpMethod:@"GET" expectedCode:200 responseBlock:completeBlock];
    
    [self sendAsyncRequest:request];
}

- (void) requestSessionTokenAsync:(NSString*) _refreshToken FinishingBlock: (AOMResponseSessionBlock) _block
{
    
    NSRange range = [[self baseUrl] rangeOfString:@"yambas"];
    NSString *oauthURL =  [[[self baseUrl] substringToIndex:range.location+6] stringByAppendingString:@"/oauth/token"];

    AOMResponseDataBlock responseBlock = ^(NSData* result, NSError *error)
    {
        AOMTokenContainer *sessionData = nil;
        if(result && error == FALSE)
        {
            
            NSError* jsonError;
            /* Convert response to JSON */
            NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&jsonError];
            /* Convert date */
            NSDate *expirationDate = nil;
            if([jsonData objectForKey:@"expires_in"])
            {
                double expiresInS = [[jsonData objectForKey:@"expires_in"] doubleValue];
                if(expiresInS)
                {
                    expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresInS];
                }
            }
            sessionData = [[AOMTokenContainer alloc] initWithSessionToken:[jsonData objectForKey:@"access_token"] refreshToken:[jsonData objectForKey:@"refresh_token"] expirationDate:expirationDate extra:[jsonData objectForKey:@"aom_extra"]];
            [sessionData setModel:[jsonData objectForKey:@"aom_model"]];
            [sessionData setModule:[jsonData objectForKey:@"aom_module"]];
        }
        //Call caller
        if (_block)
        {
            _block(sessionData, error);
        }
    };
    
    AOMRequest* request = [[AOMRequest alloc] initWithURL:oauthURL httpMethod:@"POST" expectedCode:200 responseBlock:responseBlock];
    
    [request setUseAuthorization:FALSE];
    
	[request setAddtionalHeaders:[NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded", @"Content-Type",  m_usedSystem, @"X-apiomat-system", nil]];
    
    NSURL *url = [NSURL URLWithString:[[self baseUrl] lastPathComponent]];
    
    NSString *appName = [url lastPathComponent];
    NSString *grantType = _refreshToken ? @"refresh_token": @"aom_user";
    NSString *httpParams = [NSString stringWithFormat:@"grant_type=%@&client_id=%@&client_secret=%@", grantType, [NSString encodeToPercentEscapeString:appName], [NSString encodeToPercentEscapeString:[self apiKey]]];
    
    /* Additional parameters needed if no refreshToken is given */
    if(_refreshToken == FALSE)
    {
        httpParams = [httpParams stringByAppendingFormat:@"&scope=%@&username=%@&password=%@&app=%@&system=%@", [NSString encodeToPercentEscapeString:@"read write"],[NSString encodeToPercentEscapeString:m_userName], [NSString encodeToPercentEscapeString:m_password], [NSString encodeToPercentEscapeString:appName], [NSString encodeToPercentEscapeString:m_usedSystem]];
    }
    else
    {
        httpParams = [httpParams stringByAppendingFormat:@"&refresh_token=%@", [NSString encodeToPercentEscapeString:_refreshToken]];
    }
    [request setProcessResponse:FALSE];
    [request setHttpBody:[httpParams dataUsingEncoding:NSUTF8StringEncoding]];

    [self sendAsyncRequest:request];
}

#pragma mark - Helper methods

- (NSData*) sendSyncRequest:(AOMRequest*)_request
{
    NSString *httpMethod = [_request httpMehod];
    NSURLResponse *response = nil;
    NSData *responseData = [self getBinaryData:_request withResponse:&response];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headerFields = [httpResponse allHeaderFields];
    NSInteger statusCode = [httpResponse statusCode];

    /* Delete manually from cache if it was DELETE request */
    if([httpMethod isEqualToString:@"DELETE"] && statusCode == 204)
    {
        NSString *url = [AOMDatastore concatHref:[_request url] withQuery:nil];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [[AOMModelStore sharedInstance] removeCachedResponseForRequest:urlRequest];
    }
    
    NSArray *expectedCodes = [_request expectedCodes];
    if (responseData)
    {
        /* decompile cached collection data and get JSON for saved hrefs in list */
        if([headerFields  objectForKey:IS_COLLECTION_KEY])
        {
            NSDictionary *retDict = [AOMModelStore getCachedDataForCollection:responseData];
            responseData = [retDict objectForKey:CACHED_RETURN_DATA_KEY];
        }
        
        if([expectedCodes containsObject:[NSNumber numberWithInteger:statusCode]] == false)
        {
            
            NSString *errorStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            [self raiseApiomatExceptionWithErrorCode:[httpResponse statusCode] andExpectedCodes:expectedCodes andReason:errorStr];
        }
        else
        {
            //Set responseString to location from header if POST request
            if([httpMethod isEqualToString: @"POST"])
            {
                NSString *locationStr = [[httpResponse allHeaderFields] objectForKey:@"Location"];
                responseData = [locationStr dataUsingEncoding:NSUTF8StringEncoding];
            }
            //add returned last modified/eTag to list for req
            else if([httpMethod isEqualToString: @"GET"] && cacheStrategy != AOM_NETWORK_ONLY)
            {
                NSURL *reqURL = [AOMDatastore getURLMinusQuery:[response URL]];
                NSString *lastModified = [[httpResponse allHeaderFields] objectForKey:@"Last-Modified"];
                /* Update list with lastModified */
                if(lastModified)
                {
                    [mapHrefToLastModified setObject:lastModified forKey:reqURL];
                }
                NSString *eTag = [[httpResponse allHeaderFields] objectForKey:@"ETag"];
                /* Update list with eTag */
                if(eTag)
                {
                    [mapHrefToETag setObject:eTag forKey:reqURL];
                }
            }
        }
    }
    else
    {
        [self raiseConnectionFailedException];
    }
    
    return responseData;
}


- (NSData*) getBinaryData:(AOMRequest*)_request withResponse: (NSURLResponse**) response
{
    NSURL *url = [[NSURL alloc] initWithString:[self createHref:[_request url]]];
    AOMCacheStrategy cacheStrat = [self cacheStrategy];
    /* We use NETWORK_ELSE_CACHE for sync requests when FIRST cache strategies specified */
    if(cacheStrat == AOM_CACHE_ELSE_NETWORK || cacheStrat == AOM_CACHE_THEN_NETWORK)
    {
        cacheStrat = AOM_NETWORK_ELSE_CACHE;
    }
    NSURLRequestCachePolicy cachePolicy = convertToCachePolicy(cacheStrat);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:cachePolicy timeoutInterval:self.requestTimeout];
    [urlRequest setHTTPMethod:[_request httpMehod]];
    NSData *httpBody = [_request httpBody];
    if(httpBody)
    {
        [urlRequest setHTTPBody:httpBody];
    }
    [self setHeader:urlRequest AOMRequest:_request];
    /* Is deltaSync used?
    if([_request isBinaryData] == FALSE && [[_request httpMehod] isEqualToString:@"GET"] && [self useDeltaSync])
    {
        BOOL useDeltaSync = [self prepareForDeltaSync:urlRequest];
        [_request setUseDeltaSync:useDeltaSync];
    }
    */
    NSData *responseData;
    NSError* error = nil;
#ifdef IS_TESTING
    /* Reset caching variable */
    [[AOMDatastore sharedInstance] setWasCacheHit:FALSE];
#endif
    responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:response error:&error];
    
    return responseData;
}

- (void) sendAsyncRequest:(AOMRequest*)_request
{
    /* Completion block which will be called from network delegate */
    CompleteBlock completionBlock = ^(AOMURLConnection* connection) {
        AOMRequest *req = [connection request];
        NSURLResponse *response = connection.response;
        NSData *responseData = connection.data;
        NSError *error = connection.error;
        NSString *httpMethod = [req httpMehod];
        NSArray *expectedCodes = [req expectedCodes];
        NSError *aomError = nil;
        NSURL *reqUrl = [[connection currentRequest] URL];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [httpResponse statusCode];
        /* Delete manually from cache if it was DELETE request */
        if([httpMethod isEqualToString:@"DELETE"] && statusCode == 204)
        {
            NSString *url = [AOMDatastore concatHref:[req url] withQuery:nil];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [[AOMModelStore sharedInstance] removeCachedResponseForRequest:urlRequest];
        }
        /*  trying to get data manually from cache */
        if([error code] == -1009)
        {
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:[connection currentRequest]];
            if (cachedResponse != nil)
            {
                responseData = [cachedResponse data];
                if(responseData)
                {
                    httpResponse = (NSHTTPURLResponse *)cachedResponse.response;
                    statusCode = [httpResponse statusCode];
                }
            }
        }
        if (responseData)
        {
            NSDictionary *headerFields = [httpResponse allHeaderFields];
            
            /* If response was GET, statusCode=304 and responseData.length = 0 get from cache */
            if([httpMethod isEqualToString: @"GET"] && statusCode == 304 && responseData.length <= 0)
            {
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:reqUrl cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:self.requestTimeout];
                NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:urlRequest];
                httpResponse = (NSHTTPURLResponse *)resp.response;
                headerFields = [httpResponse allHeaderFields];
                responseData = resp.data;
                if(responseData != nil)
                {
                    statusCode = 200;
                }
                else if([self hasConnection])
                {
                    /* Restart req again without etag/lm if no data in cache */
                    AOMCacheStrategy oldStrategy = [self cacheStrategy];
                    [AOMDatastore setCachingStrategy:AOM_NETWORK_ONLY];
                    [self sendAsyncRequest:_request];
                    [AOMDatastore setCachingStrategy:oldStrategy];
                }
                else
                {
                    aomError = [AOMDatastore createApiomatErrorWithStatus:AOMMODEL_NOT_FOUND];
                }
            }
            /* Check if it was delta-sync request */
            else if([self useDeltaSync] && [httpMethod isEqualToString: @"GET"] && [req useDeltaSync])
            {
                [self createResponseFromDeltaSync:connection Error:&error responseData:&responseData headerFields:headerFields];
            }
            
            /* decompile cached collection data and get JSON for saved hrefs in list */
            if([headerFields objectForKey:IS_COLLECTION_KEY])
            {
                NSDictionary *retDict = [AOMModelStore getCachedDataForCollection:responseData];
                responseData = [retDict objectForKey:CACHED_RETURN_DATA_KEY];
            }
            
            /* First check if it is maybe POST request for SSO */
            NSURL *responseURL = response.URL;
            NSString *contentType = [[httpResponse allHeaderFields]objectForKey:@"Content-Type"];
            if([contentType hasPrefix:@"text/html"])
            {
                NSURL *tmpUrl = [self isSSOHost:responseData];
                if(tmpUrl)
                {
                    responseURL = tmpUrl;
                    connection.isRedirectToSSO = TRUE;
                }
            }
            
            if(connection.isRedirectToSSO)
            {
                NSLog(@"Redirect to SSO");
                /* Create error object */
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:responseData forKey:AOM_SSO_REDIRECT_DATA];
                [userInfo setObject:responseURL forKey:AOM_SSO_REDIRECT_URL];
                aomError = [AOMDatastore createApiomatErrorWithStatus:AOMSSO_REDIRECT WithUserInfo:userInfo];
            }
            else if([expectedCodes containsObject:[NSNumber numberWithInteger:statusCode]] == false)
            {
                NSString* reasonStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                aomError = [self createApiomatError:statusCode  expectedCode:expectedCodes reason:reasonStr];
            }
            else if([req processResponse])
            {                
                //Set responseString to location from header if POST request
                if([httpMethod isEqualToString: @"POST"])
                {
                    NSString* location = [[httpResponse allHeaderFields] objectForKey:@"Location"];
                    responseData = [location dataUsingEncoding:NSUTF8StringEncoding];
                }
                else if([httpMethod isEqualToString: @"GET"] && cacheStrategy != AOM_NETWORK_ONLY)
                {
                    NSURL *reqURLCleaned = [AOMDatastore getURLMinusQuery:reqUrl];
                    NSString *lastModified = [[httpResponse allHeaderFields] objectForKey:@"Last-Modified"];
                    
                    /* Update list with lastModified */
                    if(lastModified)
                    {
                        [mapHrefToLastModified setObject:lastModified forKey:reqURLCleaned];
                    }
                    NSString *eTag = [[httpResponse allHeaderFields] objectForKey:@"ETag"];
                    /* Update list with eTag */
                    if(eTag)
                    {
                        [mapHrefToETag setObject:eTag forKey:reqURLCleaned];
                    }
                }
            }
        }
        else
        {
            /* Check first common network error */
            /* resource unavailable, maybe occures if network is unreachable and nothing in cache */
            if(error && [error code] == -1008)
            {
                NSLog(@"Common network error occureed: %@", [error description]);
                if([self hasConnection] == FALSE && [httpMethod  isEqualToString:@"GET"])
                {
                    aomError = [AOMDatastore createApiomatErrorWithStatus:AOMID_NOT_FOUND_OFFLINE];
                }
                else
                {
                    /* Create 404 */
                    aomError = [AOMDatastore createApiomatErrorWithStatus:AOMMODEL_NOT_FOUND];
                }
            }
            else
            {
                aomError = [self createApiomatError:[error code] expectedCode:expectedCodes reason:[error localizedDescription]];
            }
        }
        /* Callback caller */
        [req responseBlock](responseData, aomError);
    };
    
    NSString *urlString = [_request url];
    NSString *httpMethod = [_request httpMehod];
    AOMResponseDataBlock responseBlock = [_request responseBlock];
    NSData *httpBody = [_request httpBody];
    BOOL isBinaryDataReq = [_request isBinaryData];
    NSURL *reqUrl = [[NSURL alloc] initWithString:[self createHref:urlString]];
    NSURLRequestCachePolicy cachePolicy = convertToCachePolicy([self cacheStrategy]);
    
#ifdef IS_TESTING
    /* Reset caching variable */
    [[AOMDatastore sharedInstance] setWasCacheHit:FALSE];
#endif
    
    /* Check if device is connected to network */
    if([self hasConnection] == FALSE)
    {
        if([httpMethod isEqualToString: @"GET"])
        {
            /* if caching is deactivated return immediatlly */
            if([self cacheStrategy] == AOM_NETWORK_ONLY)
            {
                responseBlock(nil, [AOMDatastore createApiomatErrorWithStatus:AOMNO_NETWORK]);
                return;
            }
            else
            {
                /* Try to load from local cache */
                cachePolicy = NSURLRequestReturnCacheDataDontLoad;
            }
        }
    }
    else if([httpMethod isEqualToString:@"GET"] && [self cacheStrategy] == AOM_CACHE_THEN_NETWORK)
    {
        /* Because we can't access reqUrl in switch statement below we moved this to extra else/if */
        /* Get data from local cache and call back */
        NSURLRequest *cacheReq = [NSURLRequest requestWithURL:reqUrl cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:self.requestTimeout];
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:cacheReq];
        /* Create dummy connection object for completion block */
        AOMURLConnection *conn = [[AOMURLConnection alloc] initWithRequest:cacheReq delegate:nil startImmediately:NO];
        conn.response = cachedResponse.response;
        conn.data = cachedResponse.data.mutableCopy;
        conn.request = _request;
        completionBlock(conn);
        /* Send req over network and call back again */
        cachePolicy = convertToCachePolicy(AOM_NETWORK_ONLY);
    }
    else if([httpMethod isEqualToString: @"GET"] && [self cacheStrategy] == AOM_NETWORK_ELSE_CACHE)
    {
        /* if online and AOM_NETWORK_ELSE_CACHE then prevent cache access before request sent against server, but if server responds with 304 try to get cached data (handled in complete bock) */
        cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    else if([httpMethod isEqualToString: @"PUT"] && [self cacheStrategy] != AOM_NETWORK_ONLY)
    {
        /* When updating an object, the offline object needs to be updated as well for this and maybe other cases:
         * When using cache_else_network, loading an obj (gets stored in cache), updating it and then loading again
         *  -> loads from cache, so it's important the update has been applied to the cached object
         */
        NSURL *tempUrl = reqUrl;
        NSURLRequest *cacheReq = [NSURLRequest requestWithURL:reqUrl cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:self.requestTimeout];
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:cacheReq];
        /* try to find withReferencedHrefs parameter */
        if(cachedResponse == nil || cachedResponse.data == nil)
        {
            NSString *url = [AOMDatastore concatHref:urlString withQuery:nil];
            tempUrl = [NSURL URLWithString:url];
            cacheReq = [NSURLRequest requestWithURL:tempUrl cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:self.requestTimeout];
            cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:cacheReq];
        }
        if(cachedResponse && [cachedResponse data])
        {
            NSError* error;
            NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:_request.httpBody options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            /* Set new lastmodified */
            [jsonData setObject:[NSNumber numberWithLong:[[NSDate new] timeIntervalSince1970]*1000] forKey:@"lastModifiedAt"];
            
            NSURLResponse *response = cachedResponse.response;
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:kNilOptions error:&error];
            /* Save cache response for item */
            NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                                   initWithURL:reqUrl
                                                   statusCode:200
                                                   HTTPVersion:@"HTTP/1.1"
                                                   headerFields:[HTTPResponse allHeaderFields]];
            NSCachedURLResponse *newResponse = [[NSCachedURLResponse alloc]
                                               initWithResponse:modifiedResponse
                                               data:data
                                               userInfo:cachedResponse.userInfo
                                               storagePolicy:cachedResponse.storagePolicy];
            [[NSURLCache sharedURLCache] storeCachedResponse:newResponse forRequest:cacheReq];
        }
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:reqUrl cachePolicy:cachePolicy timeoutInterval:self.requestTimeout];
    [urlRequest setHTTPMethod:httpMethod];
    
    /* Is deltaSync used? */
    if(isBinaryDataReq == FALSE && [httpMethod isEqualToString:@"GET"] && [self useDeltaSync])
    {
        BOOL useDeltaSync = [self prepareForDeltaSync:urlRequest];
        [_request setUseDeltaSync:useDeltaSync];
    }
    
    if(httpBody)
    {
        [urlRequest setHTTPBody:httpBody];
    }
    
    [self setHeader:urlRequest AOMRequest:_request];
    
    /* We use delegate and our own implementation of NSURLConnection */
    AOMURLConnection *con = [[AOMURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    
    con.request = _request;
    con.completionBlock = completionBlock;
#ifdef IS_TESTING
    [self setActualRequest:con];
#endif
    [con start];
}

+ (NSString*) concatHref: (NSString*) _href
               withQuery: (NSString*) _query
{
    NSString* result;
    result= [NSString stringWithFormat:@"%@?withReferencedHrefs=%@",_href,[[AOMDatastore sharedInstance] loadWithLinks]?@"true":@"false" ];
    if(_query){
        result= [NSString stringWithFormat:@"%@&q=%@",result,[NSString encodeToPercentEscapeString:_query]];
    }
    
    return result;
    
}

- (NSString*) getAuthenticationHeader:(AOMAuthType) _authType
{
    NSString *authenticationString = @"";
    
    if(_authType == AOMAuthTypeUSERNAME_PASSWORD)
    {
        NSString *credentials = [NSString stringWithFormat:@"%@:%@", m_userName,m_password];
        authenticationString = [@"Basic " stringByAppendingString:[credentials stringByEncodingBase64]];
    }
    else if (_authType == AOMAuthTypeOAUTH2_TOKEN)
    {
        authenticationString = [@"Bearer " stringByAppendingString:m_sessionToken];
    }

    return authenticationString;
}

- (NSString*) createModelHrefFromClass: (Class) _class
{
    NSString* _modulName = [_class performSelector:@selector(getModuleName)];
    NSString* _simpleModelName = [_class performSelector:@selector(getSimpleName)];
    return [NSString stringWithFormat:@"%@/models/%@/%@", m_baseUrl , _modulName,_simpleModelName ];
}

- (NSString*) createStaticDataHref:(BOOL) isImage {
    return [NSString stringWithFormat:@"%@/data/%@/", m_baseUrl , isImage?@"images":@"files" ];
}

- (NSString*) createHref:(NSString *)_href
{
    if ( [_href hasPrefix:@"http"] )
    {
        return _href;
    }
    
    if ( [_href hasPrefix:@"/apps" ] )
    {
        NSRange range = [[self baseUrl] rangeOfString:@"/apps"];
        return [[[self baseUrl] substringToIndex:range.location] stringByAppendingString:_href];
    }
    
    return [[self baseUrl] stringByAppendingFormat:@"/%@", _href ];
}

- (NSString*) classNameFromHref:(NSString*)_modelHref
{
    NSString *tmpStr = [_modelHref stringByReplacingOccurrencesOfString:[self baseUrl] withString:@""];
    NSArray *uriParts = [tmpStr componentsSeparatedByString:@"/"];
    if(uriParts && [uriParts count] > 3)
    {
        return uriParts[3];
    }
    return Nil;
}

- (void)setHeader:(NSMutableURLRequest *)urlRequest AOMRequest:(AOMRequest*) _aomRequest
{
    if([_aomRequest isBinaryData])
    {
        [urlRequest setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    }
    else
    {
        [urlRequest setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    if(_aomRequest && [_aomRequest addtionalHeaders])
    {
        for (NSString* key in [_aomRequest addtionalHeaders])
        {
            [urlRequest setValue:[[_aomRequest addtionalHeaders] objectForKey:key] forHTTPHeaderField:key];
        }

    }
    
    [urlRequest setValue:@"true" forHTTPHeaderField:@"X-apiomat-fullupdate"];
    
    BOOL useAuth = _aomRequest == FALSE || (_aomRequest && [_aomRequest useAuthorization]);
    
    //TODO determine about auth method
    if(useAuth)
    {
        [urlRequest setValue:[self getAuthenticationHeader:authType] forHTTPHeaderField:@"Authorization"];
    }
    [urlRequest setValue:m_apiKey forHTTPHeaderField:@"X-apiomat-apikey"];
    [urlRequest setValue:sdkVersion forHTTPHeaderField:@"X-apiomat-sdkVersion"];
    [urlRequest setValue:m_usedSystem forHTTPHeaderField:@"X-apiomat-system"];
    /* Check caching and send headers if there */
    if(cacheStrategy!=AOM_NETWORK_ONLY)
    {
        NSURL *reqURL = [AOMDatastore getURLMinusQuery:[urlRequest URL]];
        NSString* lastModified = [mapHrefToLastModified objectForKey:reqURL];
        /* Reset to 'empty' value else NSURLConnection will create automatically header with wrong value (hh:mm:ss)*/
        if([NSString isEmptyString:lastModified])
        {
            lastModified =[NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSince1970:0]];
        }
        [urlRequest setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
        NSString *eTag = [mapHrefToETag objectForKey:reqURL];
        if([NSString isEmptyString:eTag])
        {
            eTag = @"0";
        }
        [urlRequest setValue:eTag forHTTPHeaderField:@"If-None-Match"];
    }
}

+ (NSURL*) getURLMinusQuery:(NSURL*) _url
{
    NSURL *newURL = [[NSURL alloc] initWithScheme:[_url scheme]
                                             host:[_url host]
                                             path:[_url path]];
    return newURL;
}

- (void) createResponseFromDeltaSync:(AOMURLConnection *)connection Error:(NSError **)error_p responseData:(NSData**)_serverResponseData headerFields:(NSDictionary *)headerFields
{
    AOMRequest *req = [connection request];
    /* Only use delta data if we send some IDs to server */
    if([req useDeltaSync])
    {
        /* Get request from cache */
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[[connection currentRequest] URL] cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:self.requestTimeout];
        NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:urlRequest];
        NSData *localData = resp.data;
        if(localData && localData.length > 0)
        {
            NSArray *deletedIds = nil;

            NSString *deletedIdsStr = [headerFields objectForKey:AOM_HEADER_DELTA_DELETED];
            if(deletedIdsStr)
            {
                NSData *deletedIdsData = [deletedIdsStr dataUsingEncoding:NSUTF8StringEncoding];
                deletedIds = [NSJSONSerialization JSONObjectWithData:deletedIdsData options:NSJSONReadingMutableContainers |NSJSONReadingMutableLeaves error:&(*error_p)];
            }
            NSArray *localJsonArray = [NSJSONSerialization JSONObjectWithData:localData options:NSJSONReadingMutableLeaves error:&(*error_p)];
            NSMutableArray *newJsonArray = [NSJSONSerialization JSONObjectWithData:*_serverResponseData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&(*error_p)];
            /* Remove every entry which is in AOM_HEADER_DELTA_DELETED */
            NSPredicate *removeDeletedHrefs = [NSPredicate predicateWithBlock:^BOOL(NSString *href, NSDictionary *bindings) {
                return [deletedIds containsObject:[AOMModelHelper getIDFromHref:href]] == false;
            }];
            NSMutableArray *cleanLocalJsonA = [[localJsonArray filteredArrayUsingPredicate:removeDeletedHrefs] mutableCopy];
            /* Intersect with responseData */
            if([cleanLocalJsonA count] > 0)
            {
                [newJsonArray enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger idx, BOOL *stop) {
                    NSString *hrefURL = [AOMDatastore concatHref:[data objectForKey:@"href"] withQuery:nil];
                    if([cleanLocalJsonA containsObject:hrefURL])
                    {
                        [cleanLocalJsonA  removeObject:hrefURL];
                    }
                }];
                
                NSDictionary *retData = [AOMModelStore getCachedDataForHrefs:cleanLocalJsonA];
                NSData *cachedElemsData = [retData objectForKey:CACHED_RETURN_DATA_KEY];
                NSArray *cachedElemsA = [NSJSONSerialization JSONObjectWithData:cachedElemsData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&(*error_p)];
                /* add to response data */
                [newJsonArray addObjectsFromArray:cachedElemsA];
                *_serverResponseData = [NSJSONSerialization dataWithJSONObject:newJsonArray options:kNilOptions error:&(*error_p)];
            }
            /* Save response back to cache */
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:[resp response] data:*_serverResponseData userInfo:[resp userInfo] storagePolicy:[resp storagePolicy]];
            [[AOMModelStore sharedInstance] storeCachedResponse:cachedResponse forRequest:urlRequest];
        }
    }
}

/*!
 Check if http response body contains sso host and return host from HTML if there
 @param responseData HTTP response body
 @return SSO redirect host or nil
*/
- (NSURL*) isSSOHost: (NSData*) responseData
{
    NSURL* ssoRedirectUrl = nil;
    /* Check if html body contains correct title */
    /* <title>Shibboleth Authentication Request</title> */
    NSString *htmlTitle = @"<title>Shibboleth.*?</title>";
    NSString *htmlContent = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if([htmlContent rangeOfString:htmlTitle options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].length > 0)
    {
        /* Check if there is any configured SSO host in action of form */
        NSString *htmlFormActionRegEx = @"<form.+method.?=.?\"POST\".+?action=.?\"(.*?)\".*?>";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:htmlFormActionRegEx options:NSRegularExpressionCaseInsensitive error:&error];
        if (error)
        {
            NSLog(@"Couldn't create regex with given string and options");
        }
        else
        {
            NSTextCheckingResult *match = [regex firstMatchInString:htmlContent options:NSMatchingReportProgress range:NSMakeRange(0, htmlContent.length)];
            if(match)
            {
                NSRange matchRange = [match rangeAtIndex:1];
                NSString *foundActionHost = [htmlContent substringWithRange:matchRange];
                NSString *actionHost = [foundActionHost stringByReplacingOccurrencesOfString:@"&#58;" withString:@":"];
                NSURL *url = [NSURL URLWithString:actionHost];
                NSString *rHost = [url host];
                /* Redirect Host seems to be in configured IdPs */
                if([self.idPHosts containsObject:rHost])
                {
                    ssoRedirectUrl = url;
                }
                else
                {
                    NSLog(@"The target host '%@' in the redirect html page doesn't match the IdP that you configured in the SDK", rHost);
                }
            }
        }
    }
    return ssoRedirectUrl;
}

# pragma mark Helper for NSError and NSException
- (void)raiseConnectionFailedException {
    NSMutableDictionary *error = [[NSMutableDictionary alloc] init];
    
    [error setObject:[NSString stringWithFormat:@"%i", CONNECTION_FAILED_CODE]
              forKey:KEY_ERROR_CODE];
    [error setObject:@"Connection failed"
              forKey:KEY_ERROR_MESSAGE];
    
    [[NSException exceptionWithName:CONNECTION_FAILED
                             reason:[error objectForKey:KEY_ERROR_CODE]
                           userInfo:error] raise];
}

- (void)raiseApiomatExceptionWithErrorCode:(NSInteger) errorCode andExpectedCodes:(NSArray*) expectedCodes andReason:(NSString*)reason {
    NSMutableDictionary *error = [[NSMutableDictionary alloc] init];
    NSString* reasonString = [NSString stringWithFormat:@"Return code %li does not match expected one(s) (%@) - %@", (long)errorCode, [expectedCodes description],reason ];
    
    /* Check if it is a status code*/
    AOMStatusCode statusCode =  [AOMStatus getStatusForCode:errorCode];
    if(statusCode)
    {
        reasonString  = [AOMStatus getReasonPhraseForCode:statusCode];
    }
    
    [error setObject:[NSString stringWithFormat:@"%li", (long)errorCode]
              forKey:KEY_ERROR_CODE];
    [error setObject:reasonString
              forKey:KEY_ERROR_MESSAGE];
    [error setObject:expectedCodes forKey:KEY_EXPECTED_CODES];
    
    [[NSException exceptionWithName:ApiomatRequestException
                             reason:[error objectForKey:KEY_ERROR_CODE]
                           userInfo:error] raise];
}
- (void)raiseApiomatExceptionWithErrorCode:(NSInteger) errorCode andExpectedCode:(NSInteger) expectedCode andReason:(NSString*)reason {
    [self raiseApiomatExceptionWithErrorCode:errorCode andExpectedCodes:[NSArray arrayWithObjects: [NSNumber numberWithInteger:expectedCode], nil] andReason:reason];
}

- (NSError*)createApiomatError:(NSInteger) errorCode expectedCode:(NSArray*)expectedCodes reason:(NSString*) reason
{
    NSString* reasonString = [NSString stringWithFormat:@"Return code %li does not match expected one(s) (%@) - %@", (long)errorCode, [expectedCodes description],reason ];
    
    /* Check if it is a valid status code */
    AOMStatusCode statusCode =  [AOMStatus getStatusForCode:errorCode];
    if(statusCode)
    {
        reasonString  = [AOMStatus getReasonPhraseForCode:statusCode];
    }
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSString stringWithFormat:@"%li", (long)errorCode]
                 forKey:KEY_ERROR_CODE];
    [userInfo setObject:reasonString
                 forKey:KEY_ERROR_MESSAGE];
    [userInfo setObject:expectedCodes forKey:KEY_EXPECTED_CODES];
    
    return [NSError errorWithDomain:@"com.apiomat.frontend" code:errorCode userInfo:userInfo];
}

+ (NSError*)createApiomatErrorWithStatus:(AOMStatusCode) status {
    return [self createApiomatErrorWithStatus:status WithUserInfo:[[NSDictionary alloc] init]];
}

+ (NSError*)createApiomatErrorWithStatus:(AOMStatusCode) _status WithUserInfo:(NSDictionary*) _userInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:_userInfo];
    [userInfo setObject:[NSString stringWithFormat:@"%i", _status]
                 forKey:KEY_ERROR_CODE];
    [userInfo setObject:[AOMStatus getReasonPhraseForCode:_status ]
                 forKey:KEY_ERROR_MESSAGE];
    
    return [NSError errorWithDomain:@"com.apiomat.frontend" code:_status  userInfo:userInfo];
}

+ (void)raiseApiomatExceptionWithStatus:(AOMStatusCode) status {
    NSMutableDictionary *error = [[NSMutableDictionary alloc] init];
    
    
    [error setObject:[NSString stringWithFormat:@"%i", status]
              forKey:KEY_ERROR_CODE];
    [error setObject:[AOMStatus getReasonPhraseForCode:status ]
              forKey:KEY_ERROR_MESSAGE];
    
    [[NSException exceptionWithName:ApiomatRequestException
                             reason:[error objectForKey:KEY_ERROR_CODE]
                           userInfo:error] raise];
}
#pragma mark Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    ((AOMURLConnection *)connection).data = [[NSMutableData alloc] init];
    ((AOMURLConnection *)connection).response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [((AOMURLConnection *)connection).data appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    ((AOMURLConnection *)connection).data = nil;
    ((AOMURLConnection *)connection).error = error;
    [((AOMURLConnection *)connection) onComplete];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    /* Callback block */
    [((AOMURLConnection *)connection) onComplete];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSURLResponse *response = cachedResponse.response;
    //  if ([response isKindOfClass:NSHTTPURLResponse.class]) return cachedResponse;
    
    /* Check if we request delta sync */
    NSString *deltaIdsStr = [[[connection currentRequest] allHTTPHeaderFields] objectForKey:AOM_HEADER_DELTA];
    if(deltaIdsStr)
    {
        NSError *error = nil;
        NSData *deltaIdsData = [deltaIdsStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *deltaIds = [NSJSONSerialization JSONObjectWithData:deltaIdsData options:NSJSONReadingMutableLeaves error:&error];
        if(deltaIds && [deltaIds count] > 0)
        {
            return nil;
        }
    }
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
    NSDictionary *headers = HTTPResponse.allHeaderFields;
    if (headers[@"Cache-Control"]) return cachedResponse;
    
    NSMutableDictionary *modifiedHeaders = headers.mutableCopy;
    modifiedHeaders[@"Cache-Control"] = [NSString stringWithFormat:@"max-age=%ldl", CACHE_TTL];
    NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                           initWithURL:HTTPResponse.URL
                                           statusCode:HTTPResponse.statusCode
                                           HTTPVersion:@"HTTP/1.1"
                                           headerFields:modifiedHeaders];
    /* set correct storage policy also here according to LOCAL offlineStrategy */
    BOOL storeInCache = FALSE;
    if([connection isKindOfClass:AOMURLConnection.class])
    {
        if([[(AOMURLConnection*) connection request] storeInCache])
        {
            storeInCache = [[(AOMURLConnection*) connection request] storeInCache];
        }
    }
    
    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageNotAllowed;
    if(storeInCache && [self cacheStrategy] != AOM_NETWORK_ONLY)
    {
        storagePolicy = NSURLCacheStorageAllowed;
    }
    else if([self cacheStrategy] != AOM_NETWORK_ONLY)
    {
        storagePolicy = NSURLCacheStorageAllowedInMemoryOnly;
    }
    cachedResponse = [[NSCachedURLResponse alloc]
                      initWithResponse:modifiedResponse
                      data:cachedResponse.data
                      userInfo:cachedResponse.userInfo
                      storagePolicy:storagePolicy];
    return cachedResponse;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    /* Check if redirectResponse is redirect to SSO/SAML provider */
    if(redirectResponse)
    {
        NSString *redirectLocation = [((NSHTTPURLResponse*)redirectResponse).allHeaderFields objectForKey:@"Location"];
        if(redirectLocation)
        {
            NSString *rHost = [[NSURL URLWithString:redirectLocation] host];
            /* Redirect Host seems to be in configured IdPs */
            if([self.idPHosts containsObject:rHost]  && [connection isKindOfClass:AOMURLConnection.class])
            {
                ((AOMURLConnection*)connection).isRedirectToSSO = TRUE;
            }
        }
       
    }
    return request;
}

#pragma mark Cache methods

- (void) initCache
{
    if([self cacheInitalized] == false)
    {
        NSString *dataPath = @"HTTPCache";
        
        /* Init cache with given memory and disc cache size */
        self.modelStore = [[AOMModelStore alloc] initWithMemoryCapacity:[self memoryCacheSize]*1048576 diskCapacity:[self discCacheSize]*1048576 diskPath:dataPath];
        [NSURLCache setSharedURLCache:self.modelStore];
        
        /* Init reachablity framework */
        if ([Reachability class])
        {
            /* Register observer and call notifcationChanged when sth happen */
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
            Reachability *reach = [Reachability reachabilityForInternetConnection];
            BOOL started = [reach startNotifier];
            NSLog(@"Started Reachability notifier: %@", started?@"true":@"false");
            [self networkChanged:[reach currentReachabilityStatus]];
        }
        else
        {
            NSLog(@"No Reachability class there. Maybe you forgot to add System Configuration framework?");
        }
        [self setCacheInitalized:true];
    }
}

- (BOOL) shouldSaveOffline:(Class)_clazz
{
    BOOL _storeOffline = FALSE;
    if(_clazz)
    {
        SEL selector = @selector(storeOffline);
        NSMethodSignature *sig = [_clazz methodSignatureForSelector:selector];
        NSInvocation *getOp = [NSInvocation invocationWithMethodSignature:sig];
        [getOp setSelector:selector];
        [getOp invokeWithTarget:_clazz];
        [getOp getReturnValue:&_storeOffline];
    }
    return [self isOfflineSupported:_storeOffline];
}

- (BOOL) isOfflineSupported:(BOOL) _canBeOffline
{
    return _canBeOffline && [self cacheStrategy] != AOM_NETWORK_ONLY && [self hasConnection] == FALSE;
}

- (void) setHasConnection:(BOOL)_hasConnection
{
    /* inform ModelStore */
    [[AOMModelStore sharedInstance] executeTasks:_hasConnection];
    hasConnection = _hasConnection;
}

- (void)networkChanged:(NetworkStatus)netStatus
{
#ifndef IS_TESTING
    switch (netStatus)
    {
        case NotReachable:
            NSLog(@"Network not reachable");
            [self setHasConnection:FALSE];
            break;
        default:
            NSLog(@"Network reachable again: %ld", netStatus);
            [self setHasConnection:TRUE];
            break;
    }
#endif
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityDidChange:(NSNotification *)note
{
    Reachability* reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    [self networkChanged:netStatus];
}

- (BOOL) prepareForDeltaSync:(NSMutableURLRequest*) _request
{
    BOOL useDeltaSync = FALSE;
    /* Check if sth is in cache */
    NSDictionary *savedIds = [[AOMModelStore sharedInstance] getSavedIDsForRequest:_request];
    if(savedIds && savedIds.count > 0)
    {
        NSError *error = nil;
        NSString *jsonData = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:savedIds options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
        /* Set Delta-Sync header */
        [_request setValue:jsonData forHTTPHeaderField:AOM_HEADER_DELTA];
        useDeltaSync = TRUE;
    }
    return useDeltaSync;
}

NSURLRequestCachePolicy convertToCachePolicy(AOMCacheStrategy cacheStrategy)
{
    NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;
    switch (cacheStrategy) {
        case AOM_NETWORK_ONLY:
            policy = NSURLRequestReloadIgnoringLocalCacheData;
            break;
        case AOM_NETWORK_ELSE_CACHE:
            policy = NSURLRequestUseProtocolCachePolicy;
            break;
        case AOM_CACHE_ELSE_NETWORK:
            policy = NSURLRequestReturnCacheDataElseLoad;
            break;
        default:
            break;
    }
    return policy;
}

#pragma mark Cache helper
- (void) clearCachedResultForClass:(Class) _class andQuery:(NSString*)_query
{
    NSString* url = [self createModelHrefFromClass:_class];
    url = [AOMDatastore concatHref: url withQuery: _query];
    [self clearCachedResult:url];
}

- (void) clearCachedResultForObject:(AOMAbstractClientDataModel*) _model
{
    NSString *url = [AOMDatastore concatHref:[_model getHref] withQuery:nil];
    [self clearCachedResult:url];
}

- (void) clearCachedResult:(NSString*) url
{
    if([NSString isEmptyString:url] == FALSE && [self cacheInitalized] && [AOMModelStore sharedInstance])
    {
        /* Prepare URLRequest */
        NSURL *realURL = [NSURL URLWithString:url];
        NSURLRequest *urlReq = [NSURLRequest requestWithURL:realURL];
        
        [[AOMModelStore sharedInstance] removeCachedResponseForRequest:urlReq];
        /* Also clear lastModified and etag but here we need without query */
        NSURL *reqURLCleaned = [AOMDatastore getURLMinusQuery:realURL];
        [self.mapHrefToLastModified removeObjectForKey:reqURLCleaned];
        [self.mapHrefToETag removeObjectForKey:reqURLCleaned];
    }
}


@end
