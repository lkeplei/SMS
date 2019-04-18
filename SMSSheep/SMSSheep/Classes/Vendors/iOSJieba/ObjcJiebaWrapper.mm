//
//  ObjcJiebaWrapper.m
//  SMSSheep
//
//  Created by ken.liu on 2019/4/18.
//  Copyright © 2019 ken.liu. All rights reserved.
//

#import "ObjcJiebaWrapper.h"

#include <stdio.h>

#include "cppjieba/MixSegment.hpp"
#include <string>
#include <vector>
#include <iostream>

#pragma mark - segment
using namespace cppjieba;

cppjieba::MixSegment * globalSegmentor;

void JiebaInit(const string& dictPath, const string& hmmPath, const string& userDictPath) {
    if(globalSegmentor == NULL) {
        globalSegmentor = new MixSegment(dictPath, hmmPath, userDictPath);
    }
    cout << __FILE__ << __LINE__ << endl;
}

void JiebaCut(const string& sentence, vector<string>& words) {
    assert(globalSegmentor);
    globalSegmentor->Cut(sentence, words);
    cout << __FILE__ << __LINE__ << endl;
    cout << words << endl;
}

#pragma mark - wrapper
@implementation ObjcJiebaWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        [self objcJiebaInit:[[NSBundle mainBundle] pathForResource:@"iosjieba.bundle/dict/jieba.dict.small" ofType:@"utf8"]
                     forPath:[[NSBundle mainBundle] pathForResource:@"iosjieba.bundle/dict/hmm_model" ofType:@"utf8"]
                 forDictPath:[[NSBundle mainBundle] pathForResource:@"iosjieba.bundle/dict/user.dict" ofType:@"utf8"]];
    }
    return self;
}

- (void)objcJiebaInit:(NSString *)dictPath forPath:(NSString *)hmmPath forDictPath:(NSString *)userDictPath {
    const char *cDictPath = [dictPath UTF8String];
    const char *cHmmPath = [hmmPath UTF8String];
    const char *cUserDictPath = [userDictPath UTF8String];
    
    JiebaInit(cDictPath, cHmmPath, cUserDictPath);
}

- (void)objcJiebaCut:(NSString *)sentence toWords:(NSMutableArray *)words {
    const char* cSentence = [sentence UTF8String];
    
    std::vector<std::string> wordsList;
    for (int i = 0; i < [words count];i++) {
        wordsList.push_back(wordsList[i]);
    }
    JiebaCut(cSentence, wordsList);
    
    [words removeAllObjects];
    std::for_each(wordsList.begin(), wordsList.end(), [&words](std::string str) {
        id nsstr = [NSString stringWithUTF8String:str.c_str()];
        [words addObject:nsstr];
    });
}

@end
