//
//  TaglibWrapper.mm
//
//  Created by Ryan Francesconi on 1/2/19.
//  Copyright © 2019 Ryan Francesconi. All rights reserved.
//

#include <iostream>
#include <iomanip>
#include <stdio.h>
#import <tag/tag.h>
#import <tag/fileref.h>
#import <tag/tstring.h>
#import <tag/rifffile.h>
#import <tag/wavfile.h>
#import <tag/aifffile.h>
#import <tag/mpegfile.h>
#import <tag/mp4file.h>
#import <tag/chapterframe.h>
#import <tag/tstringlist.h>
#import <tag/tpropertymap.h>
#import <tag/textidentificationframe.h>
#import <tag/tfilestream.h>
#import "TaglibWrapper.h"

using namespace std;

@implementation TaglibWrapper

+ (nullable NSString *)getTitle:(NSString *)path
{
    TagLib::FileRef fileRef(path.UTF8String);
    if (fileRef.isNull()) {
        return nil;
    }

    TagLib::Tag *tag = fileRef.tag();
    if (!tag) {
        return nil;
    }
    NSString *value = [NSString stringWithUTF8String:tag->title().toCString()];
    return value;
}

+ (nullable NSString *)getComment:(NSString *)path
{
    TagLib::FileRef fileRef(path.UTF8String);
    if (fileRef.isNull()) {
        cout << "FileRef is nil for: " << path.UTF8String << endl;
        return nil;
    }

    TagLib::Tag *tag = fileRef.tag();
    if (!tag) {
        cout << "Tag is nil" << endl;
        return nil;
    }
    NSString *value = [NSString stringWithUTF8String:tag->comment().toCString()];
    return value;
}

+ (nullable NSMutableDictionary *)getMetadata:(NSString *)path
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    TagLib::FileRef fileRef(path.UTF8String);
    if (fileRef.isNull()) {
        return nil;
    }

    TagLib::Tag *tag = fileRef.tag();
    if (!tag) {
        return nil;
    }
//    cout << "-- TAG (basic) --" << endl;
//    cout << "title   - \"" << tag->title()   << "\"" << endl;
//    cout << "artist  - \"" << tag->artist()  << "\"" << endl;
//    cout << "album   - \"" << tag->album()   << "\"" << endl;
//    cout << "year    - \"" << tag->year()    << "\"" << endl;
//    cout << "comment - \"" << tag->comment() << "\"" << endl;
//    cout << "track   - \"" << tag->track()   << "\"" << endl;
//    cout << "genre   - \"" << tag->genre()   << "\"" << endl;

    TagLib::RIFF::WAV::File *waveFile = dynamic_cast<TagLib::RIFF::WAV::File *>(fileRef.file());

    NSString *title = [TaglibWrapper stringFromWchar:tag->title().toCWString()];

    // if title is blank, check the wave info tag instead
    if (title == nil && waveFile) {
        title = [TaglibWrapper stringFromWchar:waveFile->InfoTag()->title().toCWString()];
    }
    [dictionary setValue:title ? : @"" forKey:@"TITLE"];

    NSString *artist = [TaglibWrapper stringFromWchar:tag->artist().toCWString()];

    if ((artist == nil || [artist isEqualToString:@""]) && waveFile) {
        artist = [TaglibWrapper stringFromWchar:waveFile->InfoTag()->artist().toCWString()];
    }
    [dictionary setValue:artist ? : @"" forKey:@"ARTIST"];

    NSString *album = [TaglibWrapper stringFromWchar:tag->album().toCWString()];
    if ((album == nil || [album isEqualToString:@""]) && waveFile) {
        album = [TaglibWrapper stringFromWchar:waveFile->InfoTag()->album().toCWString()];
    }
    [dictionary setValue:album ? : @"" forKey:@"ALBUM"];

    NSString *year = [NSString stringWithFormat:@"%u", tag->year()];
    [dictionary setValue:year forKey:@"YEAR"];

    NSString *comment = [TaglibWrapper stringFromWchar:tag->comment().toCWString()];
    if ((comment == nil || [comment isEqualToString:@""]) && waveFile) {
        comment = [TaglibWrapper stringFromWchar:waveFile->InfoTag()->comment().toCWString()];
    }
    [dictionary setValue:comment ? : @"" forKey:@"COMMENT"];

    NSString *track = [NSString stringWithFormat:@"%u", tag->track()];
    [dictionary setValue:track ? : @"" forKey:@"TRACK"];

    NSString *genre = [TaglibWrapper stringFromWchar:tag->genre().toCWString()];
    if ((genre == nil || [genre isEqualToString:@""]) && waveFile) {
        genre = [TaglibWrapper stringFromWchar:waveFile->InfoTag()->genre().toCWString()];
    }
    [dictionary setValue:genre ? : @"" forKey:@"GENRE"];

    TagLib::PropertyMap tags = fileRef.file()->properties();

    // scan through the tag properties where all the other id3 tags will be kept
    // add those as additional keys to the dictionary
    //cout << "-- TAG (properties) --" << endl;
    for (TagLib::PropertyMap::ConstIterator i = tags.begin(); i != tags.end(); ++i) {
        for (TagLib::StringList::ConstIterator j = i->second.begin(); j != i->second.end(); ++j) {
            // cout << i->first << " - " << '"' << *j << '"' << endl;

            NSString *key = [TaglibWrapper stringFromWchar:i->first.toCWString()];
            NSString *object = [TaglibWrapper stringFromWchar:j->toCWString()];

            if (key != nil && object != nil) {
                [dictionary setValue:object ? : @"" forKey:key];
            }
        }
    }
    return dictionary;
}

+ (bool)setMetadata:(NSString *)path
         dictionary:(NSDictionary *)dictionary
{
    TagLib::FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Error: TagLib::FileRef.isNull: Unable to open file:" << path.UTF8String << endl;
        return false;
    }

    TagLib::Tag *tag = fileRef.tag();
    if (!tag) {
        cout << "Unable to create tag" << endl;
        return false;
    }

    // also duplicate the data into the INFO tag if it's a wave file
    TagLib::RIFF::WAV::File *waveFile = dynamic_cast<TagLib::RIFF::WAV::File *>(fileRef.file());

    // these are the non standard tags
    TagLib::PropertyMap tags = fileRef.file()->properties();

    for (NSString *key in [dictionary allKeys]) {
        NSString *value = [dictionary objectForKey:key];

        if ([key isEqualToString:@"TITLE"]) {
            tag->setTitle(value.UTF8String);
            // also set InfoTag for wave
            if (waveFile) {
                waveFile->InfoTag()->setTitle(value.UTF8String);
            }
        } else if ([key isEqualToString:@"ARTIST"]) {
            tag->setArtist(value.UTF8String);
            if (waveFile) {
                waveFile->InfoTag()->setArtist(value.UTF8String);
            }
        } else if ([key isEqualToString:@"ALBUM"]) {
            tag->setAlbum(value.UTF8String);
            if (waveFile) {
                waveFile->InfoTag()->setAlbum(value.UTF8String);
            }
        } else if ([key isEqualToString:@"YEAR"]) {
            tag->setYear(value.intValue);
            if (waveFile) {
                waveFile->InfoTag()->setYear(value.intValue);
            }
        } else if ([key isEqualToString:@"TRACK"]) {
            tag->setTrack(value.intValue);
            if (waveFile) {
                waveFile->InfoTag()->setTrack(value.intValue);
            }
        } else if ([key isEqualToString:@"COMMENT"]) {
            tag->setComment(value.UTF8String);
            if (waveFile) {
                waveFile->InfoTag()->setComment(value.UTF8String);
            }
        } else if ([key isEqualToString:@"GENRE"]) {
            tag->setGenre(value.UTF8String);
            if (waveFile) {
                waveFile->InfoTag()->setGenre(value.UTF8String);
            }
        } else {
            TagLib::String tagKey = TagLib::String(key.UTF8String);
            tags.replace(TagLib::String(key.UTF8String), TagLib::StringList(value.UTF8String));
        }
    }

    bool result = fileRef.save();

    return result;
}

void printTags(const TagLib::PropertyMap &tags)
{
    unsigned int longest = 0;
    for (TagLib::PropertyMap::ConstIterator i = tags.begin(); i != tags.end(); ++i) {
        if (i->first.size() > longest) {
            longest = i->first.size();
        }
    }
    cout << "-- TAG (properties) --" << endl;
    for (TagLib::PropertyMap::ConstIterator i = tags.begin(); i != tags.end(); ++i) {
        for (TagLib::StringList::ConstIterator j = i->second.begin(); j != i->second.end(); ++j) {
            cout << left << std::setw(longest) << i->first << " - " << '"' << *j << '"' << endl;
        }
    }
}

// convenience function to update the comment tag in a file
+ (bool)writeComment:(NSString *)path
             comment:(NSString *)comment
{
    TagLib::FileRef fileRef(path.UTF8String);

    if (fileRef.isNull()) {
        cout << "Unable to write comment" << endl;
        return false;
    }

    cout << "Updating comment to: " << comment.UTF8String << endl;
    TagLib::Tag *tag = fileRef.tag();
    if (!tag) {
        cout << "Unable to write tag" << endl;
        return false;
    }

    tag->setComment(comment.UTF8String);
    bool result = fileRef.save();
    return result;
}

/// markers as chapters in mp3 and mp4 files
+ (NSArray *)getChapters:(NSString *)path
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    TagLib::FileRef fileRef(path.UTF8String);
    if (fileRef.isNull()) {
        return nil;
    }

    TagLib::Tag *tag = fileRef.tag();
    if (!tag) {
        return nil;
    }

    TagLib::MPEG::File *mpegFile = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());

    if (!mpegFile) {
        return nil;
    }
    // cout << "Parsing MPEG File" << endl;

    TagLib::ID3v2::FrameList chapterList = mpegFile->ID3v2Tag()->frameList("CHAP");

    for (TagLib::ID3v2::FrameList::ConstIterator it = chapterList.begin();
         it != chapterList.end();
         ++it) {
        TagLib::ID3v2::ChapterFrame *frame = dynamic_cast<TagLib::ID3v2::ChapterFrame *>(*it);
        if (frame) {
            // cout << "FRAME " << frame->toString() << endl;

            if (!frame->embeddedFrameList().isEmpty()) {
                for (TagLib::ID3v2::FrameList::ConstIterator it = frame->embeddedFrameList().begin(); it != frame->embeddedFrameList().end(); ++it) {
                    // the chapter title is a sub frame
                    if ((*it)->frameID() == "TIT2") {
                        // cout << (*it)->frameID() << " = " << (*it)->toString() << endl;
                        NSString *marker = [TaglibWrapper stringFromWchar:(*it)->toString().toCWString()];

                        marker = [marker stringByAppendingString:[NSString stringWithFormat:@"@%d", frame->startTime()] ];
                        [array addObject:marker];
                    }
                }
            }
        }
    }

    return array;
}

// only works with mp3 files
+ (bool)setChapters:(NSString *)path
              array:(NSArray *)array
{
    TagLib::FileRef fileRef(path.UTF8String);
    if (fileRef.isNull()) {
        return false;
    }

    TagLib::Tag *tag = fileRef.tag();
    if (!tag) {
        return false;
    }
    TagLib::MPEG::File *mpegFile = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());

    if (!mpegFile) {
        cout << "TaglibWrapper.setChapters: Not a MPEG File" << endl;
        return false;
    }

    // parse array

    // remove CHAPter tags
    mpegFile->ID3v2Tag()->removeFrames("CHAP");

    // add new CHAP tags
    TagLib::ID3v2::Header header;

    // expecting NAME@TIME right now
    for (NSString *object in array) {
        NSArray *items = [object componentsSeparatedByString:@"@"];
        NSString *name = [items objectAtIndex:0];   //shows Description
        int time = [[items objectAtIndex:1] intValue];

        TagLib::ID3v2::ChapterFrame *chapter = new TagLib::ID3v2::ChapterFrame(&header, "CHAP");
        chapter->setStartTime(time);
        chapter->setEndTime(time);

        // set the chapter title
        TagLib::ID3v2::TextIdentificationFrame *eF = new TagLib::ID3v2::TextIdentificationFrame("TIT2");
        eF->setText(name.UTF8String);
        chapter->addEmbeddedFrame(eF);
        mpegFile->ID3v2Tag()->addFrame(chapter);
    }
    bool result = mpegFile->save();
    return result;
}

+ (NSString *)detectFileType:(NSString *)path
{
    if (![path.pathExtension isEqualToString:@""]) {
        // NSLog(@"returning via extension %@", path.pathExtension);
        return [path.pathExtension lowercaseString];
    }
    return [TaglibWrapper detectStreamType:path];
}

+ (NSString *)detectStreamType:(NSString *)path
{
    const char *filepath = path.UTF8String;
    TagLib::FileStream *stream = new TagLib::FileStream(filepath);

    if (!stream->isOpen()) {
        NSLog(@"Unable to open FileStream: %@", path);
        delete stream;
        return nil;
    }
    const char *value = nil;

    if (TagLib::MPEG::File::isSupported(stream)) {
        value = "mp3";
    } else if (TagLib::MP4::File::isSupported(stream)) {
        value = "m4a";
    } else if (TagLib::RIFF::WAV::File::isSupported(stream)) {
        value = "wav";
    } else if (TagLib::RIFF::AIFF::File::isSupported(stream)) {
        value = "aif";
    }

    delete stream;

    if (value) {
        // NSLog(@"Returning stream file type: %s", value);
        return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSString *)stringFromWchar:(const wchar_t *)charText
{
    //used ARC
    return [[NSString alloc] initWithBytes:charText length:wcslen(charText) * sizeof(*charText) encoding:NSUTF32LittleEndianStringEncoding];
}

@end

/**
 // see: http://id3.org/id3v2.4.0-frames
 const char *frameTranslation[][2] = {
 // Text information frames
 { "TALB", "ALBUM"},
 { "TBPM", "BPM" },
 { "TCOM", "COMPOSER" },
 { "TCON", "GENRE" },
 { "TCOP", "COPYRIGHT" },
 { "TDEN", "ENCODINGTIME" },
 { "TDLY", "PLAYLISTDELAY" },
 { "TDOR", "ORIGINALDATE" },
 { "TDRC", "DATE" },
 // { "TRDA", "DATE" }, // id3 v2.3, replaced by TDRC in v2.4
 // { "TDAT", "DATE" }, // id3 v2.3, replaced by TDRC in v2.4
 // { "TYER", "DATE" }, // id3 v2.3, replaced by TDRC in v2.4
 // { "TIME", "DATE" }, // id3 v2.3, replaced by TDRC in v2.4
 { "TDRL", "RELEASEDATE" },
 { "TDTG", "TAGGINGDATE" },
 { "TENC", "ENCODEDBY" },
 { "TEXT", "LYRICIST" },
 { "TFLT", "FILETYPE" },
 //{ "TIPL", "INVOLVEDPEOPLE" }, handled separately
 { "TIT1", "CONTENTGROUP" },
 { "TIT2", "TITLE"},
 { "TIT3", "SUBTITLE" },
 { "TKEY", "INITIALKEY" },
 { "TLAN", "LANGUAGE" },
 { "TLEN", "LENGTH" },
 //{ "TMCL", "MUSICIANCREDITS" }, handled separately
 { "TMED", "MEDIA" },
 { "TMOO", "MOOD" },
 { "TOAL", "ORIGINALALBUM" },
 { "TOFN", "ORIGINALFILENAME" },
 { "TOLY", "ORIGINALLYRICIST" },
 { "TOPE", "ORIGINALARTIST" },
 { "TOWN", "OWNER" },
 { "TPE1", "ARTIST"},
 { "TPE2", "ALBUMARTIST" }, // id3's spec says 'PERFORMER', but most programs use 'ALBUMARTIST'
 { "TPE3", "CONDUCTOR" },
 { "TPE4", "REMIXER" }, // could also be ARRANGER
 { "TPOS", "DISCNUMBER" },
 { "TPRO", "PRODUCEDNOTICE" },
 { "TPUB", "LABEL" },
 { "TRCK", "TRACKNUMBER" },
 { "TRSN", "RADIOSTATION" },
 { "TRSO", "RADIOSTATIONOWNER" },
 { "TSOA", "ALBUMSORT" },
 { "TSOP", "ARTISTSORT" },
 { "TSOT", "TITLESORT" },
 { "TSO2", "ALBUMARTISTSORT" }, // non-standard, used by iTunes
 { "TSRC", "ISRC" },
 { "TSSE", "ENCODING" },
 // URL frames
 { "WCOP", "COPYRIGHTURL" },
 { "WOAF", "FILEWEBPAGE" },
 { "WOAR", "ARTISTWEBPAGE" },
 { "WOAS", "AUDIOSOURCEWEBPAGE" },
 { "WORS", "RADIOSTATIONWEBPAGE" },
 { "WPAY", "PAYMENTWEBPAGE" },
 { "WPUB", "PUBLISHERWEBPAGE" },
 //{ "WXXX", "URL"}, handled specially
 // Other frames
 { "COMM", "COMMENT" },
 //{ "USLT", "LYRICS" }, handled specially
 // Apple iTunes proprietary frames
 { "PCST", "PODCAST" },
 { "TCAT", "PODCASTCATEGORY" },
 { "TDES", "PODCASTDESC" },
 { "TGID", "PODCASTID" },
 { "WFED", "PODCASTURL" },
 { "MVNM", "MOVEMENTNAME" },
 { "MVIN", "MOVEMENTNUMBER" },
 };
 **/
