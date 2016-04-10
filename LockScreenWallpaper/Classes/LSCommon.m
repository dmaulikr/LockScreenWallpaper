//
//  LSCommon.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSCommon.h"
#import "AppDelegate.h"

UIStoryboard* LSMainStoryboard()
{
    static UIStoryboard *mainStoryboard;
    if(mainStoryboard)
        return mainStoryboard;
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return mainStoryboard;
}

NSString* LSDocumentsPath()
{
    static NSString *docPath;
    if(docPath)
        return docPath;
    
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return docPath;
}

AppDelegate* LSApplicationDelegate()
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

BOOL LSIsFirstLaunchWithKey(NSString* key) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL retFlag = [defaults boolForKey:key];
    [defaults setBool:YES forKey:key];
    [defaults synchronize];
    
    return !retFlag;
}