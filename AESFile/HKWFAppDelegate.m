//
//  HKWFAppDelegate.m
//  AESFile
//
//  Created by elvis on 13-9-1.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "HKWFAppDelegate.h"

#import "NSData+AESEncryption.h"

@implementation HKWFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    
}

-(NSString*)doChoose:(BOOL)chooseDic{
    NSOpenPanel *oPanel = [NSOpenPanel openPanel]; //快捷建立方式不用释放, 我还记得, 你呢?
    [oPanel setCanChooseDirectories:chooseDic]; //可以打开目录
	[oPanel setCanChooseFiles:!chooseDic]; //不能打开文件(我需要处理一个目录内的所有文件)
    //	[oPanel setDirectory:NSHomeDirectory()]; //起始目录为Home
    [oPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    
    if ([oPanel runModal] == NSOKButton) {  //如果用户点OK
        NSString* path = [[[oPanel URLs] objectAtIndex:0] absoluteString];
        if ([path hasPrefix:@"file://localhost/"]) {
            path = [path substringFromIndex:16];
        }
        
        return path;
	}
    return @"";
}

-(void)alertWithMessage:(NSString*)message{
    NSAlert* alert = [NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"" ];
    
    [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];

}

-(BOOL)prepare{
    
    if ([self.secKey.stringValue isEqualToString:@""]) {

        [self alertWithMessage:@"请输入AES的Key值"];
        return NO;
    }
    
    
    NSString* path = self.inFile.stringValue;
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {

        [self alertWithMessage:@"请选择需要加解密的文件！" ];
        
        return NO;
    }
    
    return YES;
}

-(IBAction)chooseInFile:(id)sender
{
    self.inFile.stringValue = [self doChoose:NO];
}

-(IBAction)encrypt:(id)sender{
    if (![self prepare]) {
        return;
    }
    NSString* outpath = [NSString stringWithFormat:@"%@.encrypt",self.inFile.stringValue];
    
    NSData* data = [NSData dataWithContentsOfFile:self.inFile.stringValue];
    NSData* encrypt = [data AES256EncryptWithKey:self.secKey.stringValue];

    [encrypt writeToFile:outpath atomically:YES];
    
    [self alertWithMessage:[NSString stringWithFormat:@"加密成功文件目录：\n%@",outpath]];
}

-(IBAction)decrypt:(id)sender{
    if (![self prepare]) {
        return;
    }
    NSString* outpath = [NSString stringWithFormat:@"%@.decrypt",self.inFile.stringValue];
    
    NSData* data = [NSData dataWithContentsOfFile:self.inFile.stringValue];
    
    NSData* decrypt = [data AES256DecryptWithKey:self.secKey.stringValue];
    
    [decrypt writeToFile:outpath atomically:YES];
    
    [self alertWithMessage:[NSString stringWithFormat:@"解密成功文件目录：\n%@",outpath]];
}
@end
