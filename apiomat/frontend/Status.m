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

#import "Status.h"

@implementation AOMStatus

+ (NSString*) getReasonPhraseForCode: (AOMStatusCode) _code {
    NSString* phrase = @"Unknown error";
    switch (_code) {
        case AOMSCRIPT_ERROR: 
            phrase = @"Script error!"; 
            break;
        case AOMAPPLICATION_NOT_ACTIVE: 
            phrase = @"Application is deactivated!"; 
            break;
        case AOMBAD_IMAGE: 
            phrase = @"Image format seems to be corrupted!"; 
            break;
        case AOMBAD_ID: 
            phrase = @"ID format is wrong!"; 
            break;
        case AOMCONCURRENT_ACCESS: 
            phrase = @"Concurrent access forbidden!"; 
            break;
        case AOMAPPLICATION_SANDBOX: 
            phrase = @"Application is in sandbox mode!"; 
            break;
        case AOMMODEL_NOT_DEPLOYED: 
            phrase = @"Class is not deployed!"; 
            break;
        case AOMWRONG_REF_TYPE: 
            phrase = @"Wrong reference type!"; 
            break;
        case AOMATTRIBUTE_NOT_SET: 
            phrase = @"Attribute not set!"; 
            break;
        case AOMOPERATION_NOT_POSSIBLE: 
            phrase = @"CRUD operation not possible on this class!"; 
            break;
        case AOMAPPLICATION_NAME_MISMATCH: 
            phrase = @"Application name does not match the one defined in the class!"; 
            break;
        case AOMWRONG_AUTH_HEADER: 
            phrase = @"Wrong authentication header format, must be 'username:password'"; 
            break;
        case AOMMODEL_STILL_USED: 
            phrase = @"Class is still used by other attributes, scripts or subclasses!'"; 
            break;
        case AOMCOLLECTION_NOT_ALLOWED: 
            phrase = @"Collection is not supported for this class type!"; 
            break;
        case AOMFB_NO_VALID_MEMBER: 
            phrase = @"Request send from no valid member"; 
            break;
        case AOMFB_NO_OAUTH_TOKEN: 
            phrase = @"Requesting member has no oAuth token, please authenticate! See http://doc.apiomat.com"; 
            break;
        case AOMFB_POST_ID_MISSING: 
            phrase = @"Facebook post id has to be set!"; 
            break;
        case AOMRESTORE_NO_DUMPS_FOUND: 
            phrase = @"No dumps for app on this date exist!"; 
            break;
        case AOMTW_NO_VALID_MEMBER: 
            phrase = @"Request send from no valid member"; 
            break;
        case AOMTW_NO_OAUTH_TOKEN: 
            phrase = @"Requesting member has no oAuth token, please authenticate! See http://doc.apiomat.com"; 
            break;
        case AOMIMEXPORT_WRONG_ENCODING: 
            phrase = @"Wrong Encoding"; 
            break;
        case AOMIMEXPORT_WRONG_CONTENT: 
            phrase = @"Wrong Filecontent"; 
            break;
        case AOMPUSH_PAYLOAD_EXCEEDED: 
            phrase = @"Payload size exceeded!"; 
            break;
        case AOMPUSH_ERROR: 
            phrase = @"Error in push request!"; 
            break;
        case AOMBAD_EMAIL: 
            phrase = @"eMail format is wrong!"; 
            break;
        case AOMBAD_PROMOTIONCODE_DISCOUNT: 
            phrase = @"Discount value is wrong!"; 
            break;
        case AOMBAD_PROMOTIONCODE_CODE: 
            phrase = @"Code is invalid"; 
            break;
        case AOMPLAN_PRICE: 
            phrase = @"Plan price must be >= 0!"; 
            break;
        case AOMPLAN_NO_SYSTEMS: 
            phrase = @"Plan must have at least one system!"; 
            break;
        case AOMSCRIPT_TIME_ERROR: 
            phrase = @"Script was interrupted, execution took too long."; 
            break;
        case AOMINVALID_NAME: 
            phrase = @"Name must start with a letter, followed only by letters or numbers."; 
            break;
        case AOMATTRIBUTE_IN_SUPERCLASS: 
            phrase = @"Attribute is already defined in superclass."; 
            break;
        case AOMJSON_TYPE_ERROR: 
            phrase = @"The @type is not correctly defined in your JSON (must be: MODULENAME$CLASSNAME"; 
            break;
        case AOMTBLR_NO_VALID_MEMBER: 
            phrase = @"Request send from no valid member"; 
            break;
        case AOMTBLR_NO_OAUTH_TOKEN: 
            phrase = @"Requesting member has no oAuth token, please authenticate! See http://doc.apiomat.com"; 
            break;
        case AOMTBLR_POST_ID_MISSING: 
            phrase = @"Tumblr post id has to be set!"; 
            break;
        case AOMLOCATION_INVALID: 
            phrase = @"Location data is invalid (latitude or longitude missing)!"; 
            break;
        case AOMSCRIPT_EXCEPTION: 
            phrase = @"Exception was raised in external code!"; 
            break;
        case AOMBAD_ACCOUNTNAME: 
            phrase = @"Account name must contain only characters A-Z,a-z or 0-9!"; 
            break;
        case AOMBAD_IMAGE_ALPHA: 
            phrase = @"alpha is wrong (must be a double value between 0.0 and 1.0)"; 
            break;
        case AOMBAD_IMAGE_BGCOLOR: 
            phrase = @"bgcolor is wrong (must be an RGB hex value without #, like 'FF0000' for red)"; 
            break;
        case AOMBAD_IMAGE_FORMAT: 
            phrase = @"format is wrong (can only be png, gif, bmp or jpg/jpeg)"; 
            break;
        case AOMQUERY_ERROR: 
            phrase = @"Query could not be parsed!"; 
            break;
        case AOMBAD_TYPE_IN_QUERY: 
            phrase = @"The query contains a value with the wrong type"; 
            break;
        case AOMUNKNOWN_CLASS_IN_QUERY: 
            phrase = @"The definition of the class couldn't be found"; 
            break;
        case AOMWRONG_NUM_FORMAT_IN_QUERY: 
            phrase = @"A number was supplied in the wrong format"; 
            break;
        case AOMQUERY_PARSE_ERROR: 
            phrase = @"The query couldn't be parsed"; 
            break;
        case AOMUNKNOWN_ATTRIBUTE_IN_QUERY: 
            phrase = @"An attribute that was used in the query doesn't exist in the class"; 
            break;
        case AOMFOREIGNID_NOT_SET: 
            phrase = @"Foreign ID must be set to a unique value for this class!"; 
            break;
        case AOMCLASSES_MISSING: 
            phrase = @"Not all classes for this module are contained in the jar! This will lead to compile errors."; 
            break;
        case AOMINVALID_ATTRIBUTE_TYPE: 
            phrase = @"Attributes type is invalid"; 
            break;
        case AOMTOKEN_VALUE_EXISTS: 
            phrase = @"The token value already exists"; 
            break;
        case AOMJSON_FORMAT_ERROR: 
            phrase = @"JSON could not be parsed"; 
            break;
        case AOMMODULE_DEPLOYMENT: 
            phrase = @"Module is currently deploying. Please try again later."; 
            break;
        case AOMBAD_USERNAME: 
            phrase = @"User name must not contain a ':'."; 
            break;
        case AOMCSV_ZIP_FORMAT: 
            phrase = @"CSV import only accepts a single .zip file!"; 
            break;
        case AOMVERIFICATION: 
            phrase = @"Verification error"; 
            break;
        case AOMMODULE_STILL_USED: 
            phrase = @"Module is still used by other modules of this app!'"; 
            break;
        case AOMCLASS_NOT_IN_MODULE: 
            phrase = @"Model name not found for this module!"; 
            break;
        case AOMORDER_TRANSACTION_TIMESTAMP_OUTDATED: 
            phrase = @"Transaction outdated!"; 
            break;
        case AOMORDER_TRANSACTION_ID_INVALID: 
            phrase = @"Transaction ID invalid!"; 
            break;
        case AOMORDER_TRANSACTION_SECRET_INVALID: 
            phrase = @"Transaction secret invalid!"; 
            break;
        case AOMMANDATORY_FIELD: 
            phrase = @"Mandatory fields must not be empty or null!"; 
            break;
        case AOMINVALID_PASSWD_LENGTH: 
            phrase = @"Password must have a length of at least 6 characters!"; 
            break;
        case AOMBAD_PROMOTIONCODE_VALID: 
            phrase = @"Valid from/to of Code is null"; 
            break;
        case AOMBAD_CLASS_NAME_SAME_AS_MODULE: 
            phrase = @"Class name must not be the same as the module name!"; 
            break;
        case AOMNO_ORG_MEMBER: 
            phrase = @"Customer is not a member of the organization"; 
            break;
        case AOMMODULE_CLASS_NOT_CONTAINED: 
            phrase = @"Module main class is not contained in the uploaded file! Probably wrong module uploaded?"; 
            break;
        case AOMBAD_GROUP_NAME: 
            phrase = @"Account name must contain only characters A-Z,a-z or 0-9!"; 
            break;
        case AOMAPPLICATION_NOT_FOUND: 
            phrase = @"Application was not found!"; 
            break;
        case AOMCUSTOMER_NOT_FOUND: 
            phrase = @"Customer was not found!"; 
            break;
        case AOMID_NOT_FOUND: 
            phrase = @"ID was not found!"; 
            break;
        case AOMMODEL_NOT_FOUND: 
            phrase = @"Class was not found!"; 
            break;
        case AOMMODULE_NOT_FOUND: 
            phrase = @"Module was not found!"; 
            break;
        case AOMMETAMODEL_NOT_FOUND: 
            phrase = @"Meta Class was not found!"; 
            break;
        case AOMPLAN_NOT_FOUND: 
            phrase = @"Plan was not found!"; 
            break;
        case AOMPROMOCODE_NOT_FOUND: 
            phrase = @"Promotion code not valid!"; 
            break;
        case AOMDEMOAPP_NOT_FOUND: 
            phrase = @"This language has no demo content"; 
            break;
        case AOMORGANIZATION_NOT_FOUND: 
            phrase = @"Organization was not found!"; 
            break;
        case AOMGROUP_NOT_FOUND: 
            phrase = @"Group was not found!"; 
            break;
        case AOMACCOUNT_NOT_FOUND: 
            phrase = @"Account was not found!"; 
            break;
        case AOMDEFAULT_MODULE_NOT_FOUND: 
            phrase = @"Default module was not found for the given account"; 
            break;
        case AOMMODULE_USE_FORBIDDEN: 
            phrase = @"Required module is not attached to app"; 
            break;
        case AOMPUSH_ERROR_APIKEY: 
            phrase = @"No API Key defined for Push service!"; 
            break;
        case AOMPUSH_ERROR_CERTIFICATE: 
            phrase = @"No certificate defined for Push service!"; 
            break;
        case AOMSAME_NAME_USED_IN_SUPERCLASS: 
            phrase = @"Same name is already used in a superclass."; 
            break;
        case AOMPAYMENT_MAX_MODULE: 
            phrase = @"Maximum number of used modules exceeded for this plan."; 
            break;
        case AOMPAYMENT_SYSTEM: 
            phrase = @"Selected system use is not allowed for this plan."; 
            break;
        case AOMPAYMENT_DOWNGRADE: 
            phrase = @"Up/Downgrading plans is only allowed for super admins."; 
            break;
        case AOMSAVE_REFERENECE_BEFORE_REFERENCING: 
            phrase = @"Object you are trying to reference is not on the server. Please save it first."; 
            break;
        case AOMPAYMENT_DB_SIZE: 
            phrase = @"Used database size exceeds plan"; 
            break;
        case AOMENDPOINT_PATH_NOT_ALLOWED: 
            phrase = @"Endpoint not allowed for app; please add path to your app's config."; 
            break;
        case AOMPAYMENT_NO_CRON: 
            phrase = @"Cronjobs are not allowed for this plan."; 
            break;
        case AOMPAYMENT_MODULE_NOT_FREE: 
            phrase = @"This module is not available for free plan."; 
            break;
        case AOMNATIVEMODULE_DEACTIVATED: 
            phrase = @"Native Module feature is not activated for this installation."; 
            break;
        case AOMLICENSE_INVALID: 
            phrase = @"Your license does not allow this action."; 
            break;
        case AOMPAYMENT_NO_CUSTOMERROLES: 
            phrase = @"Customer role usage is not available for free plan."; 
            break;
        case AOMWHITELABEL: 
            phrase = @"Only available for whitelabel installations."; 
            break;
        case AOMWHITELABEL_NOT: 
            phrase = @"Not available for whitelabel installations."; 
            break;
        case AOMMODULE_CONFIG_NO_DOT: 
            phrase = @"No dot allowed in module config key."; 
            break;
        case AOMPLAN_FALLBACK: 
            phrase = @"Application cannot be activated without valid plan."; 
            break;
        case AOMPLAN_INACTIVE: 
            phrase = @"Plan is not selectable!"; 
            break;
        case AOMENTERPRISE: 
            phrase = @"Only available for enterprise installations."; 
            break;
        case AOMACCOUNT_UNACCEPTED_CONTRACTS: 
            phrase = @"Account has unaccepted Contracts"; 
            break;
        case AOMDELETE_MANDATORY_DEFAULT_MODULE: 
            phrase = @"It is not allowed to remove this default module"; 
            break;
        case AOMID_EXISTS: 
            phrase = @"ID exists!"; 
            break;
        case AOMNAME_RESERVED: 
            phrase = @"Name is reserved!"; 
            break;
        case AOMCIRCULAR_DEPENDENCY: 
            phrase = @"You can't set circular inheritance!"; 
            break;
        case AOMNAME_EXISTS: 
            phrase = @"Name is already used!"; 
            break;
        case AOMEMAIL_EXISTS: 
            phrase = @"E-mail is already used!"; 
            break;
        case AOMCUSTOMER_IN_ORG: 
            phrase = @"Customer is already member of an organization"; 
            break;
        case AOMUNAUTHORIZED: 
            phrase = @"Authorization failed!"; 
            break;
        case AOMWRONG_APIKEY: 
            phrase = @"API Key was not correct!"; 
            break;
        case AOMEVALANCHE_UNAUTH: 
            phrase = @"Authorization failed! Maybe username/password was not set for evelanche configuration?"; 
            break;
        case AOMPW_CHANGE_W_TOKEN: 
            phrase = @"Not authorized to change a user's password when authenticating with a token."; 
            break;
        case AOMTOKEN_AUTH_ERROR: 
            phrase = @"The token could not be authenticated"; 
            break;
        case AOMTOKEN_READ_ONLY: 
            phrase = @"The token can only be used for read requests."; 
            break;
        case AOMCRUD_ERROR: 
            phrase = @"Internal error during CRUD operation"; 
            break;
        case AOMIMEXPORT_ERROR: 
            phrase = @"Error during im/export!"; 
            break;
        case AOMCOMPILE_ERROR: 
            phrase = @"Classes could not be compiled!"; 
            break;
        case AOMREFERENCE_ERROR: 
            phrase = @"Error in class reference!"; 
            break;
        case AOMPUSH_PAYLOAD_ERROR: 
            phrase = @"Failed to create payload!"; 
            break;
        case AOMPUSH_SEND_ERROR: 
            phrase = @"Failed to send message(s)!"; 
            break;
        case AOMPUSH_INIT_FAILED: 
            phrase = @"Failed to initialize push service!"; 
            break;
        case AOMFACEBOOK_ERROR: 
            phrase = @"An error occured while communicating with facebook!"; 
            break;
        case AOMFACEBOOK_OAUTH_ERROR: 
            phrase = @"facebook throws oAuth error! Please show login dialog again"; 
            break;
        case AOMFACEBOOK_OAUTH_ERROR2: 
            phrase = @"Received OAuth2 error from Facebook"; 
            break;
        case AOMMEMBER_NOT_FOUND: 
            phrase = @"Can't find member with this id/username"; 
            break;
        case AOMWORDPRESS_FETCH_DATA_ERROR: 
            phrase = @"Can't fetch data for wordpress blog"; 
            break;
        case AOMTUMBLR_OAUTH_ERROR: 
            phrase = @"tumblr threw oAuth error! Please show login dialog again"; 
            break;
        case AOMTUMBLR_ERROR: 
            phrase = @"Error communicating with tumblr!"; 
            break;
        case AOMEXECUTE_METHOD_ERROR_PRIMITIVE: 
            phrase = @"Only primitive types are allowed"; 
            break;
        case AOMEXECUTE_METHOD_ERROR: 
            phrase = @"Execute method failed"; 
            break;
        case AOMOAUTH_TOKEN_REQUEST_ERROR: 
            phrase = @"An error occured during requesting an ApiOmat OAuth2 token"; 
            break;
        case AOMFINDING_RESOURCE_ERROR: 
            phrase = @"An error occured while trying to find the resource"; 
            break;
        case AOMNATIVEMODULE_DEPLOY: 
            phrase = @"Executing onDeploy failed"; 
            break;
        case AOMTOKEN_SEARCH_ERROR: 
            phrase = @"An error occured while searching for tokens"; 
            break;
        case AOMMODULE_CONFIG_MISSING: 
            phrase = @"Your module seems not to be configured properly"; 
            break;
        case AOMNATIVEMODULE_INIT: 
            phrase = @"Could not initialize git repository"; 
            break;
        case AOMNATIVEMODULE_PULL: 
            phrase = @"Could not pull git repository"; 
            break;
        case AOMNATIVEMODULE_PUSH: 
            phrase = @"Could not push git repository"; 
            break;
        case AOMNO_DOGET_RETURN: 
            phrase = @"The module's doGet didn't return a model"; 
            break;
        case AOMCUSTOMER_TWO_ORGS: 
            phrase = @"The customer was found in two organizations"; 
            break;
        case AOMNATIVEMODULE_HOOKS_NOT_FOUND: 
            phrase = @"Annotated hook class not found"; 
            break;
        case AOMANALYTICS_ERROR: 
            phrase = @"The analytics instance couldn't process the request correctly"; 
            break;
        case AOMEMAIL_ERROR: 
            phrase = @"Error during sending email"; 
            break;
        case AOMHREF_NOT_FOUND: 
            phrase = @"Class has no HREF; please save it first!"; 
            break;
        case AOMWRONG_URI_SYNTAX: 
            phrase = @"URI syntax is wrong"; 
            break;
        case AOMWRONG_CLIENT_PROTOCOL: 
            phrase = @"Client protocol is wrong"; 
            break;
        case AOMIO_EXCEPTION: 
            phrase = @"IOException was thrown"; 
            break;
        case AOMUNSUPPORTED_ENCODING: 
            phrase = @"Encoding is not supported"; 
            break;
        case AOMINSTANTIATE_EXCEPTION: 
            phrase = @"Error on class instantiation"; 
            break;
        case AOMIN_PERSISTING_PROCESS: 
            phrase = @"Object is in persisting process. Please try again later"; 
            break;
        case AOMVERIFY_SOCIALMEDIA: 
            phrase = @"Can't verify against social media provider"; 
            break;
        case AOMTOO_MANY_LOCALIDS: 
            phrase = @"Can't create more localIDs. Please try again later"; 
            break;
        case AOMMAX_CACHE_SIZE_REACHED: 
            phrase = @"The maximum cache size is reached."; 
            break;
        case AOMCANT_WRITE_IN_CACHE: 
            phrase = @"Can't persist data to cache."; 
            break;
        case AOMBAD_DATASTORE_CONFIG: 
            phrase = @"For requesting a session token without a refresh token, the Datastore must be configured with a username and password"; 
            break;
        case AOMNO_TOKEN_RECEIVED: 
            phrase = @"The response didn't contain a token"; 
            break;
        case AOMNO_NETWORK: 
            phrase = @"No network connection available"; 
            break;
        case AOMID_NOT_FOUND_OFFLINE: 
            phrase = @"ID was not found in offline storage"; 
            break;
        case AOMATTACHED_HREF_MISSING: 
            phrase = @"HREF of attached image / file / reference is missing"; 
            break;
        case AOMREQUEST_TIMEOUT: 
            phrase = @"The request timed out during connecting or reading the response"; 
            break;
        case AOMASYNC_WAIT_ERROR: 
            phrase = @"An error occured during waiting for an async task to finish"; 
            break;
        case AOMIN_DELETING_PROCESS: 
            phrase = @"Object is in deleting process. Please try again later"; 
            break;
        case AOMSSO_REDIRECT: 
            phrase = @"The request was redirected to an SSO Identity Provider"; 
            break;
        case AOMMANUAL_CONCURRENT_WRITE_FAILED: 
            phrase = @"Concurrent write to own concurrent data type failed"; 
            break;
        case AOMSAVE_FAILED: 
            phrase = @"Load not executed because save already failed"; 
            break;
        case AOMMALICIOUS_MEMBER: 
            phrase = @"Malicious use of member detected!"; 
            break;
        default:
            break;
    }
    return phrase;
}
+ (AOMStatusCode) getStatusForCode: (NSInteger) _code
{
    for(int i = AOMSCRIPT_ERROR; i < AOMMALICIOUS_MEMBER; ++i) {
        if (_code  == i) {
            return i;
        }
    }
    return FALSE;
}
@end
