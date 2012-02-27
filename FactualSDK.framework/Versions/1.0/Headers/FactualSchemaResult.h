//
//  FactualSchemaResult.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!@abstract The return object type associated with a schema query. 
 @discussion
 
 An successful getTableSchema call returns a FactualSchemaResult which
 provides schema metadata information about a Factual Table.
 
 */
@interface FactualSchemaResult : NSObject

/*! @property 
 @discussion The id of the Factual Table
 */ 
@property (nonatomic,readonly) NSString* tableId;

/*! @property 
 @discussion The table name of the Factual Table
 */ 
@property (nonatomic,readonly) NSString* tableName;
/*! @property 
 @discussion The Table description
 */ 
@property (nonatomic,readonly) NSString* tableDescription;
/*! @property 
 @discussion The user who created the Table
 */ 
@property (nonatomic,readonly) NSString* creator;
/*! @property 
 @discussion The date/time on which this table was created.
 */ 
@property (nonatomic,readonly) NSString* createdAt;
/*! @property 
 @discussion The date/time on which this table was last updated.
 */ 
@property (nonatomic,readonly) NSString* updatedAt;
/*! @property 
 @discussion boolean that is set to True if the table has support for Geo
 queries.
 */ 
@property (nonatomic,readonly) BOOL isGeoEnabled;
/*! @property 
 @discussion boolean that is set to True if the table is enabled for bulk 
 download.
 */ 
@property (nonatomic,readonly) BOOL isDownloadable;
/*! @property 
 @discussion attribution information for this table
 */ 
@property (nonatomic,readonly) NSString* source;
/*! @property 
 @discussion total row count for this table
 */ 
@property (nonatomic,readonly) NSUInteger      totalRowCount;
/*! @property 
 @discussion an array of FactualFieldMetadata objects for each field in the 
 table.
 */ 
@property (nonatomic,readonly) NSArray*  fieldMetadata;

@end
