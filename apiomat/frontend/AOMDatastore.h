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
#import "AOMUser.h"
#import "AOMConstants.h"
#import "AOMURLConnection.h"
#import "Status.h"

static const long CACHE_TTL = 2629744; //~1month in seconds
extern NSString *const AOM_HEADER_DELTA;
extern NSString *const AOM_HEADER_DELTA_DELETED;

@class AOMAbstractClientDataModel;

/*!
 This class is your interface to the ApiOmat service. Each method lets your post, put, get or delete your class instances.
 Basic handling is already implemented in your generated module classes, so it won't be necessary in most cases to
 call the AOMDatastore methods directly.
 */
@interface AOMDatastore : NSObject<NSURLConnectionDataDelegate>

typedef enum {
    /**
     * Configuration without credentials.
     */
    AOMAuthTypeGUEST,
    /**
     * Configuration with username and password
     */
    AOMAuthTypeUSERNAME_PASSWORD,
    /**
     * Configuration with an OAuth2 token
     */
    AOMAuthTypeOAUTH2_TOKEN
} AOMAuthType;

/*!
 Singleton implementation of AOMDatastore.
 Call only this object if you need AOMDatastore methods
 
 @warning *Important*: Please configure AOMDatastore before call this method
 */
+ (AOMDatastore *) sharedInstance;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _member A user object which holds the login credentials
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithUser:(AOMUser*)_user;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _member A user object which holds the login credentials
 @param _modelStore An instance of ModelStore where you can persist objects (Caution! it is beta at the moment)
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithUser:(AOMUser*)_user andModelStore:(id<AOMModelStoreProtocol>)_modelStore;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _member A user object which holds the login credentials
 @param _loadWithLinks If true also the HREFs of referenced objects are loaded when getting objects
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithUser:(AOMUser*)_user andLoadWithLinks: (BOOL)_loadWithLinks;
/*!
 Configures and returns a AOMDatastore instance
 This method doesn't set Auth credits. Please use this only if your generated class is accessable as Guest
 
 @param _baseUrl The base URL of the APIOMAT service;
 usually <a href="https://apiomat.org/yambas/rest/apps/">https://apiomat.org/yambas/rest/apps/</a>
 (see the AOMUser class)
 @param _apiKey The api key of your application (see AOMUser class)
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureAsGuestWithUrl:(NSString*)_baseUrl
                        andApiKey: (NSString*)_apiKey;


/*!
 Configures and returns a AOMDatastore instance
 
 @deprecated Please use configureWithUser: instead
 
 @param _baseUrl The base URL of the APIOMAT service;
 usually <a href="https://apiomat.org/yambas/rest/apps/">https://apiomat.org/yambas/rest/apps/</a>
 (see the AOMUser class)
 @param _apiKey The api key of your application (see AOMUser class)
 @param _username Your username
 @param _password Your password
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureAsGuestWithUrl:(NSString*)_baseUrl
                        andApiKey: (NSString*)_apiKey
                    andModelStore:(id<AOMModelStoreProtocol>)_modelStore;


/*!
 Configures and returns a AOMDatastore instance
 This method doesn't set Auth credits. Please use this only if your generated class is accessable as Guest
 
 @param _baseUrl The base URL of the APIOMAT service;
 usually <a href="https://apiomat.org/yambas/rest/apps/">https://apiomat.org/yambas/rest/apps/</a>
 (see the AOMUser class)
 @param _apiKey The api key of your application (see AOMUser class)
 @param _modelStore If you set this parameter, objects will also be saved in a local model store
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*) configureAsGuestWithUrl:(NSString*)_baseUrl
                         andApiKey: (NSString*)_apiKey
                  andLoadWithLinks: (BOOL)_loadWithLinks;

+ (AOMDatastore*)configureAsGuestWithParams:(NSDictionary*) params;
+ (AOMDatastore*)configureAsGuestWithParams:(NSDictionary*) params andModelStore:(id<AOMModelStoreProtocol>)_modelStore;
+ (AOMDatastore*)configureAsGuestWithParams:(NSDictionary*) params andLoadWithLinks:(BOOL)_loadWithLinks;

/*!
 Configures and returns a AOMDatastore instance
 
 @param _user A user object which holds the login credentials
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _user A user object which holds the login credentials
 @param _modelStore An instance of ModelStore where you can persist objects (Caution! it is beta at the moment)
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user andModelStore:(id<AOMModelStoreProtocol>)_modelStore;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _user A user object which holds the login credentials
 @param _loadWithLinks If true also the HREFs of referenced objects are loaded when getting objects
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user andLoadWithLinks: (BOOL)_loadWithLinks;

/*!
 Configures and returns a AOMDatastore instance
 
 @param _user A user object which holds the login credentials
 @param _params Dictionary which contains different apiKey, baseUrl and system
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user andParams:(NSDictionary*) _params;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _user A user object which holds the login credentials
 @param _params Dictionary which contains different apiKey, baseUrl and system
 @param _modelStore An instance of ModelStore where you can persist objects (Caution! it is beta at the moment)
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user Params:(NSDictionary*) _params andModelStore:(id<AOMModelStoreProtocol>)_modelStore;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _user A user object which holds the login credentials
 @param _params Dictionary which contains different apiKey, baseUrl and system
 @param _loadWithLinks If true also the HREFs of referenced objects are loaded when getting objects
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithCredentials:(AOMUser*)_user Params:(NSDictionary*) _params andLoadWithLinks: (BOOL)_loadWithLinks;

/*!
 Configures and returns a AOMDatastore instance
 
 @param _user The user that has a session token attached
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithSessionTokenFromUser:(AOMUser*)_user;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _user The user that has a session token attached
 @param _modelStore An instance of ModelStore where you can persist objects (Caution! it is beta at the moment)
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithSessionTokenFromUser:(AOMUser*)_user andModelStore:(id<AOMModelStoreProtocol>)_modelStore;
/*!
 Configures and returns a AOMDatastore instance
 
 @param _user The user that has a session token attached
 @param _loadWithLinks If true also the HREFs of referenced objects are loaded when getting objects
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithSessionTokenFromUser:(AOMUser*)_user andLoadWithLinks: (BOOL)_loadWithLinks;

/*!
 Configures and returns a AOMDatastore instance
 This method doesn't set Auth credits. Please use this only if your generated class is accessable as Guest
 
 @param _sessionToken The session token to use for configuring the Datastore
 @param _baseUrl The base URL of the APIOMAT service;
 usually <a href="https://apiomat.org/yambas/rest/apps/">https://apiomat.org/yambas/rest/apps/</a>
 (see the AOMUser class)
 @param _apiKey The api key of your application (see AOMUser class)
 @param _username Your username
 @param _password Your password
 @param _modelStore If you set this parameter, objects will also saved in a local model store
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithSessionToken:(NSString*)_sessionToken andWithUrl:(NSString*)_baseUrl
                               andApiKey: (NSString*)_apiKey andUsedSystem: (NSString*)_usedSystem;


/*!
 Configures and returns a AOMDatastore instance
 This method doesn't set Auth credits. Please use this only if your generated class is accessable as Guest
 
 @param _baseUrl The base URL of the APIOMAT service;
 usually <a href="https://apiomat.org/yambas/rest/apps/">https://apiomat.org/yambas/rest/apps/</a>
 (see the AOMUser class)
 @param _apiKey The api key of your application (see AOMUser class)
 @param _loadWithLinks If true also the HREFs of referenced objects are loaded when getting objects from server
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithSessionToken:(NSString*)_sessionToken andWithUrl:(NSString*)_baseUrl
                                 andApiKey: (NSString*)_apiKey
                             andUsedSystem: (NSString*)_usedSystem
                             andModelStore:(id<AOMModelStoreProtocol>)_modelStore;


/*!
 Configures and returns a AOMDatastore instance
 
 @deprecated Please use configureWithUser:andLoadWithLinks: instead
 
 @param _baseUrl The base URL of the APIOMAT service;
 usually <a href="https://apiomat.org/yambas/rest/apps/">https://apiomat.org/yambas/rest/apps/</a>
 (see the AOMUser class)
 @param _apiKey The api key of your application (see AOMUser class)
 @param _username Your username
 @param _password Your password
 @param _loadWithLinks If true also the HREFs of referenced objects are loaded when getting objects from server
 @return A configured AOMDatastore instance
 */
+ (AOMDatastore*)configureWithSessionToken:(NSString*)_sessionToken andWithUrl:(NSString*)_baseUrl
                                andApiKey: (NSString*)_apiKey
                             andUsedSystem: (NSString*)_usedSystem
                         andLoadWithLinks: (BOOL)_loadWithLinks;

/*!
 Set caching strategy GET requests for singelton AOMDatastore.
 The default one is NO_CACHE.
 Please call configure for AOMDatastore before!
 
 @param _cacheStrategy the strategy to use
 
 @return configured AOMDatastore instance
 */
+ (AOMDatastore*) setCachingStrategy:(AOMCacheStrategy) _cacheStrategy;
/*!
 Set global offline strategy for all models.
 The default one is AOM_NO_OFFLINE.
 Please call configure for AOMDatastore before!
 
 @param _offlineStrategy the strategy to use
 
 @return configured AOMDatastore instance
 */
//+ (AOMDatastore*) setOfflineStrategy:(AOMOfflineStrategy) _offlineStrategy;

/*!
 Set size of cache which is used for offline storage
 Please call configure for AOMDatastore before!
 
 @param _memoryCacheSize size of the memory cache in megabyte
 @param _discCacheSize size of the disc cache in megabyte
 
 @return configured AOMDatastore instance
 */
+ (AOMDatastore*) setCacheSize:(long)_memoryCacheSize DiscCacheSize:(long)_discCacheSize;
+ (long) getDiscCacheSize;
+ (long) getMemoryCacheSize;

#pragma mark - Post requests
/*!
 Save class instance on server.
 
 @param _dataModel class instance to store in backend
 @return HREF of the saved class instance
 */
- (NSString*) postOnServer: (AOMAbstractClientDataModel*) _dataModel;


/*!
Posting a reference to the server under the given reference HREF
 
 @param _referenceName The name of the reference
 @param _dataModel class instance to store in backend
 @param _href referenced HREF
 @return the HREF of the posted class instance
 */
- (NSString*) postReferenceOnServer:(NSString*) _referenceName Model:(AOMAbstractClientDataModel*) _dataModel
                               Href: (NSString*) _href ParentHref:(NSString*)_parentHref;

/*!
 Method to save static data on server.
 Do not forget to store the HREF returned by method to the owner model,
 since this method only stores the byte array on the server.
 
 @param _rawData raw data as byte array
 @param _isImage TRUE to store the raw data as image, FALSE to store as video
 */
- (NSString*) postStaticDataOnServer: (NSData*) _rawData
                             asImage: (BOOL) _isImage UsePersistentStorage:(BOOL) _usePersistentStorage;

#pragma mark - load requests

- (AOMAbstractClientDataModel*) loadFromServerWithHref:(NSString*) _modelHref
                                            andStoreIn:(AOMAbstractClientDataModel*) _model;
- (NSMutableArray*) loadListFromServerWithClass:(Class)_class andQuery: (NSString*) _query;

/*!
 Loads existing class instances from server
 
 @param _modelHref HREF of the class instances
 @param _class Classname of loaded class instances
 @param _query a query string to filter the results
 @return all class instances fitting the search parameters
 */
- (NSMutableArray*) loadFromServerWithHref:(NSString*) _modelHref andClass: (Class) _class andQuery:(NSString*) _query;

/*!
 Loads a resource, e.g. an image with the user credentials.
 
 @param href the URl of the image
 @return the resource as byte array
 @throws ApiomatRequestException
 */
- (NSData*) loadResourceWithHref: (NSString*) _href;

/*!
 Loads a resource, e.g. an image with the user credentials in the background.
 
 @param href the URl of the image
 @param _block block which will executed after finished request
 */
- (void) loadResourceAsyncWithHref: (NSString*) _href StoreOffline:(BOOL)_storeOffline  andWithFinishingBlock:(AOMBlockWithNSDataResults) _block;
/*!
 * Counts existing class instances from server
 *
 * @param _class
 *        class of the objects
 * @param _query
 *        a query string to filter the results
 * @return count of existing class instances from server
 * @throws ApiomatRequestException
 */
- (long) loadCountFromServerWithClass:(Class) _class andQuery:(NSString*) _query;
/*!
 * Counts existing references from server
 *
 * @param _class
 *        class of the objects
 * @param _query
 *        a query string to filter the results
 * @param _refName
 *       the attribute name of the reference
 * @return count of existing class instances from server
 * @throws ApiomatRequestException
 */
- (long) loadCountFromServerWithHref:(NSString*) _href andQuery:(NSString*) _query ForReference:(NSString*)_refName;
/*!
 * Counts existing class instances from server in background
 * The callback method will called after finished the request
 *
 * @param _class
 *        class of the objects
 * @param _query
 *        a query string to filter the results
 * @param _block
 *        block which will executed after finished request
 * @throws ApiomatRequestException
 */
- (void) loadCountFromServerAsyncWithClass:(Class) _class andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithLongResults) _block;
/*!
 * Counts existing class instances from server in background
 * The callback method will called after finished the request
 *
 * @param _class
 *        name of the reference attribute
 * @param _query
 *        a query string to filter the results
 * @param _refName
 *        name of the reference attribute
 * @param _block
 *        block which will executed after finished request
 * @throws ApiomatRequestException
 */
- (void) loadCountFromServerAsyncWithHref:(NSString*) _href andQuery:(NSString*) _query ForReference:(NSString*)_refName andFinishingBlock:(AOMBlockWithLongResults) _block;

#pragma mark - delete requests
- (BOOL) deleteOnServerWithUrl:(NSString *)_modelHref UsePersistentStorage:(BOOL) _usePersistentStorage;
- (BOOL) deleteOnServer: (AOMAbstractClientDataModel*) _model;

#pragma mark - update requests
- (BOOL) updateOnServer: (AOMAbstractClientDataModel*) _model;
/*!
 Send a PUT request to the server with given JSON string as content.
 
 @param _url The URL where JSON will be send
 @param _json The JSON data to be send
 
 @return true if request was successfull, otherwise false
 */
- (BOOL) updateOnServerWithUrl: (NSString*) _url andJson: (NSData*) _json;
#pragma mark - async post req
/*!
 Save class instance on server in background process.
 If request is finished block parameter will executed
 
 @param _dataModel class instance to store in backend
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block which will executed after finished request
 */
- (void) postOnServerAsync:(AOMAbstractClientDataModel*)_dataModel  UsePersistentStorage:(BOOL) _usePersistentStorage withFinishingBlock:(AOMBlockWithHref) _block;
/*!
 Save class instance on server in background process.
 If request is finished block method will executed
 
 @param _dataModel class instance which will saved in backend
 @param _href HREF (URI) of the class instance to post (or the address to post the class instance to)
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param block block which will executed after finished request
 */
- (void) postReferenceOnServerAsync:(NSString*) _referenceName Model:(AOMAbstractClientDataModel*)_dataModel  withHref: (NSString*) _href ParentHref:(NSString*) _parentHref UsePersistentStorage:(BOOL) _usePersistentStorage andFinishingBlock:(AOMBlockWithHref) _finishingBlock;
/*!
 Save class instance on server in background process.
 If request is finished block method will executed
 
 @param _dataModel class instance which will saved in backend
 @param _href HREF (URI) of the class instance to post (or the address to post the class instance to)
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param block block which will executed after finished request
 */
- (void) postOnServerAsync:(AOMAbstractClientDataModel*)_dataModel withHref: (NSString*) _href UsePersistentStorage:(BOOL) _usePersistentStorage andFinishingBlock:(AOMBlockWithHref) block;
/*!
 Method to save static data on server. Will be executed in background process.
 Do not forget to store the HREF given to _block parameter to the owner model,
 since this method only stores the byte array on server.
 
 @param _rawData raw data as byte array
 @param _isImage TRUE to store the raw data as image, FALSE to store as video
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block which will executed after finished request
 */
- (void) postStaticDataOnServerAsync:(NSData*) _rawData  asImage:(BOOL) _isImage UsePersistentStorage:(BOOL) _usePersistentStorage andFinishingBlock:(AOMBlockWithHref) _block;

#pragma mark - async update requests
/*!
 Update a class instance in a background process.
 This method will call the given _block if request is finished
 
 @param _model The class instance to update on server
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block which will called after request is finished. If error==Nil requet was success.
 */
- (void) updateOnServerAsync: (AOMAbstractClientDataModel*) _model UsePersistentStorage:(BOOL)_usePersistentStorage withFinishingBlock:(AOMEmptyBlock)_block;
/*!
 Send a PUT request to the server with given JSON string as content.
 This method will call the given _block if request is finished
 
 @param _url URL where data will be send
 @param _json The JSON data to be send
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block which will called after request is finished. If error==Nil requet was success.
 */
- (void) updateOnServerAsyncWithUrl: (NSString*) _url withJson: (NSData*) _json UsePersistentStorage:(BOOL)_usePersistentStorage andWithFinishingBlock:(AOMEmptyBlock)_block;
#pragma mark - async delete requests
/*!
 Deletes the class instance from the server based on its href
 @param _modelHref Href of the class instance
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block which will called after request is finished. If error==Nil requet was success.
 */
- (void) deleteOnServerAsyncWithUrl:(NSString *)_modelHref UsePersistentStorage:(BOOL) _usePersistentStorage withFinishingBlock:(AOMEmptyBlock)_block;
/*!
 Deletes the class instance from the server
 @param _model the class instance
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block which will called after request is finished. If error==Nil requet was success.
 */
- (void) deleteOnServerAsync: (AOMAbstractClientDataModel*) _model UsePersistentStorage:(BOOL) _usePersistentStorage withFinishingBlock:(AOMEmptyBlock)_block;

#pragma mark - async load req
/*!
 !Attention! Beta method. Please report bugs to info@apiomat.com
 
 Loads existing class instance from server
 This is done in background and not on the UI thread
 
 @param _modelHref Href of existing class instance
 @param _block block which will be executed after request is finished (could be NIL). Contains returned class instance and error information
 @param _storeOffline boolean to decide if response will be cached on disc
 */
- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andFinishingBlock:(AOMBlockWithResult) _block andStoreOffline:(BOOL)_storeOffline;
/*!
 Loads existing class instance from server
 This is done in background and not on the UI thread
 
 @param _modelHref Href of existing class instance
 @param _model the class instance were information will be stored after request is finished
 @param _block block which will be executed after request is finished (could be NIL). Contains returned class instance and error information
 @param _storeOffline boolean to decide if response will be cached on disc
 */
- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andStoreIn:(AOMAbstractClientDataModel*) _model andFinishingBlock:(AOMBlockWithResult) _block andStoreOffline:(BOOL)_storeOffline;
/*!
 Loads list of existing class instances from server
 This is done in background and not on the UI thread
 
 @param _class Class of objects to load
 @param _query query string to filter the results
 @param _block block which will be executed after request is finished (could be NIL). Contains returned class instances and error information
 */
- (void) loadListFromServerAsyncWithClass:(Class)_class andQuery: (NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block;
/*!
 Loads list of existing class instances from server
 This is done in background and not on the UI thread. If you set _storeOffline to TRUE then response will be safed in disc-cache and also available if network connection is lost
 
 @param _class Class of objects to load
 @param _query query string to filter the results
 @param _block block which will be executed after request is finished (could be NIL). Contains returned class instances and error information
 @param _storeOffline boolean to decide if response will be cached on disc
 */
- (void) loadListFromServerAsyncWithClass:(Class)_class andQuery: (NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block  andStoreOffline:(BOOL) _storeOffline;

/*!
 Loads existing class instances from server
 This is done in background and not on the UI thread
 
 @param _modelHref HREF of the class instances
 @param _class Class of objects to load
 @param _query a query string to filter the results
 @param _block block which will be executed after request is finished (could be NIL). Contains returned class instances and error information
 */
- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andClass: (Class) _class andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block;
/*!
 Loads existing class instances from server
 This is done in background and not on the UI thread
 
 @param _modelHref HREF of the class instances
 @param _class Class of objects to load
 @param _query a query string to filter the results
 @param _block block which will be executed after request is finished (could be NIL). Contains returned class instances and error information
 @param _storeOffline decide if response will be stored in disc-cache
 */
- (void) loadFromServerAsyncWithHref:(NSString*) _modelHref andClass: (Class) _class andQuery:(NSString*) _query andFinishingBlock:(AOMBlockWithResults) _block andStoreOffline:(BOOL) _storeOffline;

/*!
 Request a session token from server.
 This is done in background and not on the UI thread.
 
 @param _refreshToken (Optional) if you set this parameter, refresh token will be used to get new session token
 @param _block callback block which will called, when request finished

 */
- (void) requestSessionTokenAsync:(NSString*) _refreshToken FinishingBlock: (AOMResponseSessionBlock) _block;

/*!
 Helper method which throws an ApiOmat exception with given AOMStatusCode
 */
+ (void)raiseApiomatExceptionWithStatus:(AOMStatusCode) status;
#pragma mark Helper methods
/*!
 Helper method which create an NSError object for ApiOmat from given AOMStatusCode
 */
+ (NSError*)createApiomatErrorWithStatus:(AOMStatusCode) status;
/*!
 Helper method which create an NSError object for ApiOmat from given AOMStatusCode
 */
+ (NSError*)createApiomatErrorWithStatus:(AOMStatusCode) _status WithUserInfo:(NSDictionary*) _userInfo;

+ (NSString*) concatHref: (NSString*) _href withQuery: (NSString*) _query;
- (NSString*) createStaticDataHref:(BOOL) isImage;
- (NSString*) createModelHrefFromClass:(Class) class;
#pragma mark Cache helper
/*!
 Remove all entries for this and query from cache
 @param _class objects of this class
 @param _query query (can be null)
 */
- (void) clearCachedResultForClass:(Class) _class andQuery:(NSString*)_query;
/*!
 Remove given object from cache (memory and persitent storage)
 @param _model the model to remove
 */
- (void) clearCachedResultForObject:(AOMAbstractClientDataModel*) _model;
/*!
 Remove result for given url from cache (memory and persitent storage)
 @param url as string
 */
- (void) clearCachedResult:(NSString*) url;
#pragma mark properties
@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *usedSystem;
@property (strong, nonatomic) NSString *sessionToken;
@property (strong, nonatomic) id<AOMModelStoreProtocol> modelStore;
@property (nonatomic) BOOL loadWithLinks;
#ifdef IS_TESTING
@property (nonatomic) BOOL hasConnection;
@property (nonatomic) BOOL wasCacheHit;
@property (strong, nonatomic)  AOMURLConnection *actualRequest;
#else
//@property (nonatomic) BOOL hasConnection;
@property (readonly, nonatomic) BOOL hasConnection;
#endif
@property (nonatomic) AOMCacheStrategy cacheStrategy;
@property (nonatomic) BOOL useDeltaSync;
@property (nonatomic) AOMAuthType authType;
/*!
 size of memory cache in megabyte which is used by offline strategy
*/
@property (nonatomic) long memoryCacheSize;
/*!
 size of disc cache in megabyte which is used by offline strategy
*/
@property (nonatomic) long discCacheSize;
/*!
 Define array of Identity Provider hosts for SSO/SAML
 */
@property (strong, nonatomic) NSArray* idPHosts;
/*!
 Set to false if you want to by-pass object state checks
 */
@property (nonatomic) BOOL checkObjectState;
/*!
 Sets the maximum time to wait for an input stream read (complete response) before giving up.
 Reading will fail with an ApiomatRequestException if the timeout elapses before the whole response was read.
 */
@property (nonatomic) NSTimeInterval requestTimeout;
@end
