# TagLibKit

TagLibKit is meant to be a drop-in implementation of [TagLib](https://taglib.org) for using Swift/Objective-C projects.

This includes code from [Ryan Francesconi's `TaglibWrapper`](https://github.com/ryanfrancesconi/TaglibWrapper) which gives access to TagLib's C++ code to Swift/Objective-C projects through a thin Objective-C++ wrapper, and a built version of [TagLib's source](https://github.com/taglib/taglib) as an `xcframework`.

The TaglibWrapper and TagLib source is included here in the Sources and Frameworks directories, but if needed, there is a `Makefile` to perform build operations.

- `make`: Does a full clean and rebuild
- `make submodule_init`: Initializes the submodules in the project
- `make submodule_update`: Updates the submodules in the project
- `make build`: Builds the TagLib library into an xcframework, and moves relevant files to their correct locations
- `make clean`: Cleans up build artifacts
