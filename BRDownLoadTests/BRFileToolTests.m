//
//  BRFileToolTests.m
//  BRDownLoadTests
//
//  Created by 袁涛 on 2018/6/22.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRFileTool.h"

#define filePath @"/Users/yuantao/Desktop/1.doc"
#define toFilePath @"/Users/yuantao/Desktop/关于学习/1.doc"

@interface BRFileToolTests : XCTestCase

@end

@implementation BRFileToolTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testFilePath {
    BOOL isHas = [BRFileTool br_fileExists:filePath];
    XCTAssertTrue(isHas);
}

- (void)testFileSize {
    long long fileSize = [BRFileTool br_fileSize:filePath];
    XCTAssertTrue(fileSize > 0);
}


- (void)testFileCheckMD5 {
    NSString *fileMD5 = [BRFileTool br_FileMD5HashCreateWithPath:filePath chunkSizeForReadingData:[BRFileTool br_fileSize:filePath]];
    
    XCTAssertTrue([fileMD5 isEqualToString:@"8118c1b5742f30c941fdd349484eb1b2"]);
}


- (void)testMoveFile {
    [BRFileTool br_moveFile:filePath toPath:toFilePath complete:^(NSError *error) {
        XCTAssertTrue(!error);
    }];
}

- (void)testReMoveFile {
    [BRFileTool br_removeFile:filePath complete:^(NSError *error) {
        XCTAssertTrue(!error);
    }];
}




@end
