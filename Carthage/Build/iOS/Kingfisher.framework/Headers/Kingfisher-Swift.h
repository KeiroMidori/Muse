// Generated by Apple Swift version 1.2 (swiftlang-602.0.53.1 clang-602.0.53)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
#if __has_feature(nullability)
#  define SWIFT_NULLABILITY(X) X
#else
# if !defined(__nonnull)
#  define __nonnull
# endif
# if !defined(__nullable)
#  define __nullable
# endif
# if !defined(__null_unspecified)
#  define __null_unspecified
# endif
#  define SWIFT_NULLABILITY(X)
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
@import Foundation.NSURLSession;
@import UIKit;
@import WatchKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class NSMutableURLRequest;
@protocol ImageDownloaderDelegate;


/// <ul><li><p><code>ImageDownloader</code> represents a downloading manager for requesting the image with a URL from server.</p></li></ul>
SWIFT_CLASS("_TtC10Kingfisher15ImageDownloader")
@interface ImageDownloader : NSObject

/// This closure will be applied to the image download request before it being sent. You can modify the request for some customizing purpose, like adding auth token to the header or do a url mapping.
@property (nonatomic, copy) void (^ __nullable requestModifier)(NSMutableURLRequest * __nonnull);

/// The duration before the download is timeout. Default is 15 seconds.
@property (nonatomic) NSTimeInterval downloadTimeout;

/// A set of trusted hosts when receiving server trust challenges. A challenge with host name contained in this set will be ignored. You can use this set to specify the self-signed site.
@property (nonatomic, copy) NSSet * __nullable trustedHosts;

/// Delegate of this <code>ImageDownloader</code> object. See <code>ImageDownloaderDelegate</code> protocol for more.
@property (nonatomic, weak) id <ImageDownloaderDelegate> __nullable delegate;

/// The default downloader.
+ (ImageDownloader * __nonnull)defaultDownloader;

/// Init a downloader with name.
///
/// \param name The name for the downloader. It should not be empty.
///
/// \returns The downloader object.
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithName:(NSString * __nonnull)name OBJC_DESIGNATED_INITIALIZER;
@end

@class NSURL;
@class UIImage;
@class NSError;

@interface ImageDownloader (SWIFT_EXTENSION(Kingfisher))

/// Download an image with a URL.
///
/// \param URL Target URL.
///
/// \param progressBlock Called when the download progress updated.
///
/// \param completionHandler Called when the download progress finishes.
- (void)downloadImageWithURL:(NSURL * __nonnull)URL progressBlock:(void (^ __nullable)(int64_t, int64_t))progressBlock completionHandler:(void (^ __nullable)(UIImage * __nullable, NSError * __nullable, NSURL * __nullable))completionHandler;
- (void)cleanForURL:(NSURL * __nonnull)URL;
@end

@class NSURLSession;
@class NSURLSessionDataTask;
@class NSURLResponse;
@class NSData;
@class NSURLSessionTask;
@class NSURLAuthenticationChallenge;
@class NSURLCredential;

@interface ImageDownloader (SWIFT_EXTENSION(Kingfisher)) <NSURLSessionDataDelegate>

/// This method is exposed since the compiler requests. Do not call it.
- (void)URLSession:(NSURLSession * __nonnull)session dataTask:(NSURLSessionDataTask * __nonnull)dataTask didReceiveResponse:(NSURLResponse * __nonnull)response completionHandler:(void (^ __nonnull)(NSURLSessionResponseDisposition))completionHandler;

/// This method is exposed since the compiler requests. Do not call it.
- (void)URLSession:(NSURLSession * __nonnull)session dataTask:(NSURLSessionDataTask * __nonnull)dataTask didReceiveData:(NSData * __nonnull)data;

/// This method is exposed since the compiler requests. Do not call it.
- (void)URLSession:(NSURLSession * __nonnull)session task:(NSURLSessionTask * __nonnull)task didCompleteWithError:(NSError * __nullable)error;

/// This method is exposed since the compiler requests. Do not call it.
- (void)URLSession:(NSURLSession * __nonnull)session didReceiveChallenge:(NSURLAuthenticationChallenge * __nonnull)challenge completionHandler:(void (^ __nonnull)(NSURLSessionAuthChallengeDisposition, NSURLCredential * __null_unspecified))completionHandler;
@end



/// <ul><li><p>Protocol of <code>ImageDownloader</code>.</p></li></ul>
SWIFT_PROTOCOL("_TtP10Kingfisher23ImageDownloaderDelegate_")
@protocol ImageDownloaderDelegate
@optional

/// Called when the <code>ImageDownloader</code> object successfully downloaded an image from specified URL.
///
/// \param downloader The <code>ImageDownloader</code> object finishes the downloading.
///
/// \param image Downloaded image.
///
/// \param URL URL of the original request URL.
///
/// \param response The response object of the downloading process.
- (void)imageDownloader:(ImageDownloader * __nonnull)downloader didDownloadImage:(UIImage * __nonnull)image forURL:(NSURL * __nonnull)URL withResponse:(NSURLResponse * __nonnull)response;
@end


@interface NSMutableData (SWIFT_EXTENSION(Kingfisher))
@end


@interface UIButton (SWIFT_EXTENSION(Kingfisher))
@end


@interface UIButton (SWIFT_EXTENSION(Kingfisher))
@end


@interface UIButton (SWIFT_EXTENSION(Kingfisher))

/// Get the image URL binded to this button for a specified state. 
///
/// \param state The state that uses the specified image.
///
/// \returns Current URL for image.
- (NSURL * __nullable)kf_webURLForState:(UIControlState)state;
@end


@interface UIButton (SWIFT_EXTENSION(Kingfisher))

/// Get the background image URL binded to this button for a specified state.
///
/// \param state The state that uses the specified background image.
///
/// \returns Current URL for background image.
- (NSURL * __nullable)kf_backgroundWebURLForState:(UIControlState)state;
@end


@interface UIButton (SWIFT_EXTENSION(Kingfisher))
@end


@interface UIImage (SWIFT_EXTENSION(Kingfisher))
@end


@interface UIImage (SWIFT_EXTENSION(Kingfisher))
@end


@interface UIImageView (SWIFT_EXTENSION(Kingfisher))
@end


@interface UIImageView (SWIFT_EXTENSION(Kingfisher))

/// Get the image URL binded to this image view.
@property (nonatomic, readonly) NSURL * __nullable kf_webURL;
@end


@interface UIImageView (SWIFT_EXTENSION(Kingfisher))
@end


@interface WKInterfaceImage (SWIFT_EXTENSION(Kingfisher))
@end


@interface WKInterfaceImage (SWIFT_EXTENSION(Kingfisher))

/// Get the image URL binded to this image view.
@property (nonatomic, readonly) NSURL * __nullable kf_webURL;
@end


@interface WKInterfaceImage (SWIFT_EXTENSION(Kingfisher))

/// Get the hash for a URL in Watch side cache.
///
/// You can use the returned string to check whether the corresponding image is cached in watch or not, by using <code>WKInterfaceDevice.currentDevice().cachedImages</code>
///
/// \param string The absolute string of a URL.
///
/// \returns The hash string used when cached in Watch side cache.
+ (NSString * __nonnull)kf_cacheKeyForURLString:(NSString * __nonnull)string;
@end

#pragma clang diagnostic pop
