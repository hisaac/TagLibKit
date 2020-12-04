# TagLibKit

TagLibKit is meant to be a drop-in implementation of [TagLib](https://taglib.org) for using Swift/Objective-C projects.

This package includes and a built version of [TagLib's source](https://github.com/taglib/taglib) as an `xcframework`, and [Ryan Francesconi's `TaglibWrapper`](https://github.com/ryanfrancesconi/TaglibWrapper) which allows for calling TagLib from Swift/Objective-C.

The TaglibWrapper and TagLib source is included here in the Sources and Frameworks directories, but if needed, there is a `Makefile` to perform build operations or update to newer versions.

- `make`: Does a full clean and rebuild
- `make submodule_init`: Initializes the submodules in the project
- `make submodule_update`: Updates the submodules in the project
- `make build`: Builds the TagLib library into an xcframework, and moves relevant files to their correct locations
- `make clean`: Cleans up build artifacts

## Future Goals

- Add some tests
	- Maybe tests that use TagLib's own tests?
- Add some Swift code to make calling the TaglibWrapper a little easier
- Figure out how to make it possible to call `TagLibKit` directly
	- Currently, to call a `TagLibKit` method, you need to use `TagLibKit.TaglibWrapper.someMethod()`; I'd prefer to be able to use `TagLibKit.someMethod()`
