import Foundation
import TaglibWrapper

/// A thin Swift wrapper around the `TaglibWrapper`
/// This allows `TaglibWrapper` methods to be called as `TagLibKit.method()` rather than `TagLibKit.TaglibWrapper.method()`
///
public enum TagLibKit {
	public static func getTitle(_ path: String) -> String? {
		return TaglibWrapper.getTitle(path)
	}

	public static func getComment(_ path: String) -> String? {
		return TaglibWrapper.getComment(path)
	}

	public static func getMetadata(_ path: String) -> NSMutableDictionary? {
		return TaglibWrapper.getMetadata(path)
	}

	public static func setMetadata(_ path: String, dictionary: [AnyHashable : Any]) -> Bool {
		return TaglibWrapper.setMetadata(path, dictionary: dictionary)
	}

	public static func writeComment(_ path: String, comment: String) -> Bool {
		return TaglibWrapper.writeComment(path, comment: comment)
	}

	public static func getChapters(_ path: String) -> [Any]? {
		return TaglibWrapper.getChapters(path)
	}

	public static func setChapters(_ path: String, array dictionary: [Any]) -> Bool {
		return TaglibWrapper.setChapters(path, array: dictionary)
	}

	public static func detectFileType(_ path: String) -> String? {
		return TaglibWrapper.detectFileType(path)
	}

	public static func detectStreamType(_ path: String) -> String? {
		return TaglibWrapper.detectStreamType(path)
	}
}
