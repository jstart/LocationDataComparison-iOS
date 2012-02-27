//
//  FactualTableRow.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!@abstract Object that encapsulates one row worth of data.
 @discussion
 This object cotains a collection of values, one for each field in the 
 associated Factual table. Rows are returned as a result of initiating a 
 FactualQuery. 
 
 Values can be accessed by their index position (using the FactualSchemaResult
 object for fieldName to index position resolution) or by their field name. In
 the latter case, the row will use an internal field name to index map for 
 index resolution. 
 
 Values can objects of the types: NSNumber (for numeric values),NSString,
 NSArray (for scalar results), or NSDictionary (for JSON objects). There are also
 two convenience methods, stringValueForName and stringValueAtIndex that coerce
 the source object type into a string before returning. 
 
 You can update a row's value by using the setValue methods, although any
 modifications to the row are strictly local; there is no way to update a 
 Factual Table directly via the manipulation of a FactualRow object. You have 
 to use the submitRowData method in FactualAPI to accomplish this task. You may
 however use the valuesAsDictionary method to return a collection of key/value
 pairs contained in the FactualRow object. This, however, involves an expensive 
 copy operation and should only be used in special circumstances. 
 
 Lastly, each row is identified in the Factual system by a special Row 
 Identifier. This Row Id is an opaque string and can be retrieved via the 
 rowId property of the row object. You can use this rowId to associate updates
 with a specific Factual Row. 
 
*/

@interface FactualRow : NSObject<NSCopying> 


/*! @property 
 @discussion The opaque row identifier associated with this particular row object
 */ 
@property (nonatomic,readonly) NSString* rowId;

/*! @property 
 @discussion The number of values in this row object 
 */ 
@property (nonatomic,readonly)    NSInteger valueCount;

/*! @property 
 @discussion The array of value objects.
 Each element in the array can be an NSNull,NSString,NSNumber,or NSArray.
 */ 
@property (nonatomic,readonly)    NSArray* values;

/*! @property 
 @discussion A dictionary of name value pairs.
 Each tuple consists of a column name and associated value object.
 NOTE: This is more heavyweight than using the above NSArray based values 
 method.
 */ 
@property (nonatomic,readonly)    NSDictionary* namesAndValues;


/*! @method
 @discussion Rows can be cloned
*/
- (id)copyWithZone:(NSZone *)zone;

@end

/*!@abstract Convenince methods available to a row object
*/
@interface FactualRow(FactualRowImplementation)

/*! @method
 @discussion Get a field index given a field name. Returns -1 for invalid fields.
 */
-(NSInteger)   fieldIndexForName:(NSString*) fieldName;

/*! @method
 @discussion Get a field field name given index. Returns nil for invalid 
 field indexes. 
 */
-(NSString*)   fieldNameAtIndex:(NSUInteger) index;

/*! @method
 @discussion Get a field value given a field name. 
 Note: Null values are returned as NSNull objects
 */
-(id) valueForName:(NSString*) fieldName;

/*! @method
 @discussion Get a string value (potentially coerced from native type) 
 given a field name. 
 Note: Null values are returned as empty strings
 */
-(NSString*) stringValueForName:(NSString*) fieldName;

/*! @method
 @discussion Get a field value given a field index (zero based)
 Note: Null values are returned as NSNull objects
 */
-(id) valueAtIndex:(NSInteger) fieldIndex;

/*! @method
 @discussion Get a string value (potentially coerced) given a field index 
 (zero based).
 Note: Null values are returned as empty strings
 */
-(NSString*) stringValueAtIndex:(NSInteger) fieldIndex;

/*! @method
 @discussion Set/Update a value by field name. Strictly updates local state and does
 not impact the source Factual Table.
 */
-(void) setValueForName:(NSString*) fieldName value:(id) value;

/*! @method
 @discussion Set/Update a value by field index. Strictly updates local state and does
 not impact the source Factual Table.
 */
-(void) setValueAtIndex:(NSUInteger) index value:(id) value;


@end
