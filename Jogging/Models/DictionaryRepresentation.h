//
//  DictionaryRepresentation.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#ifndef Jogging_DictionaryRepresentation_h
#define Jogging_DictionaryRepresentation_h

/**
 * `DictionaryRepresentation` is a protocol that can be implemented to add from-to dictionary mappings to a class.
 */
@protocol DictionaryRepresentation <NSObject>

@optional

/**
 * Updates the receiver with the given dictionary.
 * @param dictionary A dictionary containing the key-value pairs to update the properies of the receiver.
 */
- (void)updateWithDictionary:(NSDictionary*)dictionary;

/**
 * Creates a dictionary representation of the receiver.
 * @return Returns a dictionary containing the key-value pairs that represent the receiver as a dictionary.
 */
- (NSMutableDictionary*)dictionary;

@end

#endif
