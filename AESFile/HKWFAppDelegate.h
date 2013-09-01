//
//  HKWFAppDelegate.h
//  AESFile
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HKWFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *inFile;
@property (assign) IBOutlet NSTextField *secKey;

-(IBAction)chooseInFile:(id)sender;

-(IBAction)encrypt:(id)sender;

-(IBAction)decrypt:(id)sender;

@end
