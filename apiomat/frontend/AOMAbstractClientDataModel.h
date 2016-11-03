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

/*!
 Enum which defines internal states for a class instance.
 
 You can't get a class instance if his state is  ObjectState_PERSISTING so the return is an ApiomatRequestException
 */
typedef enum objectState
{
    ObjectState_NEW,
    ObjectState_DELETING,
    ObjectState_DELETED,
    ObjectState_PERSISTING,
    ObjectState_PERSISTED,
    ObjectState_LOCAL_PERSISTED,
    ObjectState_LOCAL_DELETED
} ObjectState;

/*!
 This class defines the base class of all classes for frontend developers. All data is stored in a JSON data
 object except the HREF of an instance of this class, originally containing the type of this class.
 */
@interface AOMAbstractClientDataModel : NSObject<NSCoding>

/*!
 Returns the HREF of this class instance
 
 @return HREF of this class instance, NULL if it was created but not saved yet
 */
- (NSString *) getHref;
/*!
 Returns the ID of this object
 */
- (NSString*) getID;
/*!
 Returns the date when this object was created on server side
 
 @return date when this object was created on server side, NULL if it was created but not saved yet
 */
- (NSDate *) getCreatedAt;
/*!
 Returns the date when this object was modified last on server side
 
 @return date when this object was modified last on server side, NULL if it was created but not saved yet
 */
- (NSDate *) getLastModifiedAt;

/**
 * Returns the name of the app where this class instance belongs to
 *
 * @return name of the app where this class instance belongs to
 */

- (NSString *) getAppName;
/*!
 Returns the simple name of this class
 
 @return simple name of this class
 */
+ (NSString *) getSimpleName;
/*!
 Returns the module name where this class instance belongs to
 
 @return name of the module where this class instance belongs to
 */
+ (NSString *) getModuleName;
+ (NSString *) getSystem;
/*!
 Returns the foreign id for this object.
 A foreign id is a NON apiomat id (like facebook/twitter id)
 
 @return NSString the foreign id
 */
- (NSString *) getForeignId;

/*!
 Set the foreign id for this object.
 A foreign id is a NON apiomat id (like facebook/twitter id)
 
 @param _foreignID the foreign id
 */
- (void) setForeignId: (NSString*) _foreignID;

/*!
 Returns a boolean value if the access to resources is restricted by the defined roles for this object
 
 @return boolean value if the access to resources is restricted
 */
- (BOOL) getRestrictResourceAccess;
/*!
 Sets if the access to resources is restricted by the defined roles for this object
 
 @param restrictResourceAccess boolean value if the access to resources is restricted
 */
- (void) setRestrictResourceAccess: (BOOL)_restrictedResourceAccess;
/*!
 Returns a set of all role names allowed to grant privileges on this object
 
 @return set of all roles allowed to grant privileges on this object
 */
- (NSMutableArray*) getAllowedRolesGrant;
/*!
 Sets the set of all role names allowed to write this object
 
 @param allowedRolesGrant role names allowed to write this object
 */
- (void) setAllowedRolesGrant:(NSMutableArray*) _allowedRolesGrant;
/*!
 Returns a set of all role names allowed to write this object
 
 @return set of all roles allowed to write this object
 */
- (NSMutableArray*) getAllowedRolesWrite;
/*!
 Sets the set of all role names allowed to write this object
 
 @param allowedRolesWrite role names allowed to write this object
 */
- (void) setAllowedRolesWrite:(NSMutableArray*) _allowedRolesWrite;
/*!
 Returns a set of all role names allowed to read this object
 
 @return set of all roles allowed for this object
 */
- (NSMutableArray*) getAllowedRolesRead;
/*!
 Sets the set of all role names allowed to read this object
 
 @param allowedRolesRead names allowed to read this object
 */
- (void) setAllowedRolesRead:(NSMutableArray*) _allowedRolesRead;
/*!
 Decodes this class instance from a JSON string; used to communicate with the REST interface
 
 @param _jsonData JSON data for decoding
 */
- (void) fromJson : (NSData*) _jsonData;
/*!
 Decodes this class instance from a NSMutableDictionar; used to communicate with the REST interface
 
 @param _jsonObject Object in JSON format which is decoded to class instance
 */
- (void) fromJSONWithObject:(NSMutableDictionary*) _jsonObject;
/*!
 Encodes this class instance as a JSON string; used to communicate with the REST interface
 
 @return this class instance as JSON string
 */
- (NSData *) toJson;
#pragma mark - CRUD operrations
/*!
 Saves this class instance. It is - based on its HREF - automatically determined, if this class instance exists on the server,
 leading to an update, or not, leading to an post command.
 
 @return TRUE if save operations was successful
 */
- (BOOL) save;
/*!
 Saves this class instance. It is - based on its HREF - automatically determined, if this class instance exists on the server,
 leading to an update, or not, leading to an post command.
 
 @param _loadAfterwards Indicates whether after saving the object, the local object should be loaded with the values from
 the server (on the first save, new values like createdAt and href get added on the server)
 @return TRUE if save operations was successful
 */
- (BOOL) saveAndLoad:(BOOL) _loadAfterwards;
/*!
 Loads (updates) this class instance with server values
 */
- (void) load;
/*!
 Loads (updates) this class instance with server values. Since you have to pass the HREF for this method, only use it
 when loading a class instance which has no HREF in it (was not sent/loaded before). Else use {@link #load()}
 
 @param _href The HREF of this class instance
 */
- (void) loadWithHref: (NSString*) _href;
/*!
 Deletes this class instance on the server
 */
- (BOOL) delete;
#pragma mark - Async CRUD operations
/*!
 Saves object in background and not on the UI thread
 
 @param _block block will be called when request finished. If error==Nil then request was successful
 */
- (void) saveAsyncWithBlock:(AOMEmptyBlock) _block;
/*!
 Saves object in background and not on the UI thread
 
 @param _block block will be called when request finished. If error==Nil then request was successful
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 */
- (void) saveAsyncUsePersistentStorage:(BOOL) _usePersistentStorage WithBlock:(AOMEmptyBlock) _block;
/*!
 Saves this class instance in background and not on the UI thread. It is - based on its HREF - automatically determined, if this class instance exists on the server,
 leading to an update, or not, leading to an post command.
 
 @param _loadAfterwards Indicates whether after saving the object, the local object should be loaded with the values from
 the server (on the first save, new values like createdAt and href get added on the server)
 */
- (void) saveAndLoadAsync:(BOOL) _loadAfterwards withBlock:(AOMEmptyBlock) _block;
/*!
 Saves this class instance in background and not on the UI thread. It is - based on its HREF - automatically determined, if this class instance exists on the server,
 leading to an update, or not, leading to an post command.
 
 @param _loadAfterwards Indicates whether after saving the object, the local object should be loaded with the values from
 the server (on the first save, new values like createdAt and href get added on the server)
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block will be called when request finished. If error==Nil then request was successful
 */
- (void) saveAndLoadAsync:(BOOL) _loadAfterwards UsePersistentStorage:(BOOL) _usePersistentStorage withBlock:(AOMEmptyBlock) _block;
/*!
 load object in background and not on the UI thread
 
 @param _block block will be called when request finished. If error==Nil then request was successful.
 */
- (void) loadAsyncWithBlock:(AOMEmptyBlock) _block;
/*!
 load object in background and not on the UI thread
 
 @param _block block will be called when request finished. If error==Nil then request was successful.
 @param _storeOffline if parameter is set to true class instance will be saved in disc-cache
 */
- (void) loadAsyncWithBlock:(AOMEmptyBlock) _block andStoreOffline:(BOOL)_storeOffline;
/*!
 load object with given HREF.
 Method will be invoked on NON-UI Thread.
 
 @param _modelHref HREF of object which will be loaded
 @param _block block will be called when request finished. If error==Nil then request was successful.
 */
- (void) loadAsyncWithHref:_modelHref andBlock:(AOMEmptyBlock) _block;
/*!
 load object with given HREF.
 Method will be invoked on NON-UI Thread.
 
 @param _modelHref HREF of object which will be loaded
 @param _block block will be called when request finished. If error==Nil then request was successful.
 @param _storeOffline if parameter is set to true class instance will be saved in disc-cache
 */
- (void) loadAsyncWithHref:_modelHref andBlock:(AOMEmptyBlock) _block andStoreOffline:(BOOL)_storeOffline;
/*!
 delete object on server in background.
 Method will be invoked on NON-UI Thread.
 
 @param _block block will be called when request finished. If error==Nil then request was successful.
 */
- (void) deleteAsyncWithBlock:(AOMEmptyBlock) _block;
/*!
 delete object on server in background.
 Method will be invoked on NON-UI Thread.
 
 @param _usePersistentStorage Indicates whether to save the response in persistent storage. Has a higher priority than the setting per class.
 @param _block block will be called when request finished. If error==Nil then request was successful.
 */
- (void) deleteAsyncUsePersistentStorage:(BOOL) _usePersistentStorage WithBlock:(AOMEmptyBlock) _block;

# pragma mark - other stuff
- (id) init;

+ (NSMutableArray*)getWithQuery: (NSString*) _query;
/*!
 Get list of Conference objects from server.
 Method will executed in background and call _block when request finishing.
 
 @param _query filter for model list
 @param _block block which will called when request is finishing
 */
+ (void)getAsyncWithQuery: (NSString*) _query withBlock:(AOMBlockWithResults) _block;
/*!
 Get list of Conference objects from server.
 Method will executed in background and call _block when request finishing.
 You can set also if the response will be saved in disc cache and is available if device is offline
 
 @param _query filter for model list
 @param _block block which will called when request is finishing
 @param _storeOffline If set to TRUE response will be stored in disc cache
 */
+ (void)getAsyncWithQuery: (NSString*) _query withBlock:(AOMBlockWithResults) _block andStoreOffline:(BOOL) _storeOffline;
/*!
 * Returns a count  of objects of this class filtered by the given query from server
 * @param a _query filtering the results in SQL style (@see <a href="http://doc.apiomat.com">documentation</a>)
 */
+ (long)getCountWithQuery: (NSString*) _query;
/*!
 * Get a count of objects of this class filtered by the given query from server
 * This method works in the background and call the callback function when finished
 *
 * @param _query a query filtering the results in SQL style (@see <a href="http://doc.apiomat.com">documentation</a>)
 * @param _block The callback method which will called when request is finished
 */
+ (void)getCountAsyncWithQuery: (NSString*) _query withBlock:(AOMBlockWithLongResults) _block;

- (NSMutableDictionary* ) getRefModelHrefs;
- (NSMutableArray* ) getRefModelHrefsForName:(NSString*) _name;
- (void) addRefModelHrefWithName:(NSString*) _name andHref:(NSString*)_href;
- (void) removeFromRefModelHrefsWithName:(NSString*)_name andHref:(NSString*)_href;

- (void) initAttributes;

#pragma mark Offline handling
/*!
 Check if offline handling is supported by this class
 */
- (BOOL) handleOffline;
/*!
 Set this property to store instances of this class in disc-cache
 */
+ (void) setStoreOffline:(BOOL)_storeOffline;
/*!
 Returns true if instances of this class will be stored in disc-cache
 */
+ (BOOL) storeOffline;
/*!
 Returns TRUE if object is offline and not synced to the server
 */
- (BOOL) isOffline;

#pragma mark Persistent helper
+ (void) clearCacheForClassWithQuery: (NSString*) _query;
- (void) clearCachedResult;
/*!
 Add a class instance to the offline store so that can be accessed later
 */
//- (void) saveInOfflineStore;
/*!
 Get a class instance for a given Href from the offline store
 @param _href The href
 @return instance for given href from offline store or nil
 */
//+ (AOMAbstractClientDataModel*) getFromOfflineStore:_href;
/*!
 */
//+ (void) saveCollectionInOfflineStore:(NSArray*) _instances withQuery:(NSString*)_query;

#pragma mark properties

@property (strong, nonatomic) NSMutableDictionary *data;
@property (nonatomic) ObjectState objectState;
- (BOOL) isIllegalObjectState:(NSString*) _httpMethod;
/*!
 Return type of this object
 */
@property (readonly, strong, nonatomic) NSString *type;
- (NSString*) objectType;
+ (NSString*) objectTypeFromJson:(NSDictionary*) jsonDict;
+ (NSString*) objectTypeFromType:(NSString*) type;
@end
