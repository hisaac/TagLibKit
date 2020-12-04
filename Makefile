# Usage:
# make                  # Does a full clean and rebuild
# make submodule_init   # Initializes the submodules in the project
# make submodule_update # Updates the submodules in the project
# make build            # Builds the TagLib library into an xcframework,
#                         and moves relevant files to their correct locations
# make clean            # Cleans up build artifacts

all: clean build

submodule_init:
	@echo "Initializing git submodules"
	git submodule update --init

submodule_update:
	@echo "Updating git submodules"
	git submodule update --init --recursive --remote

build: submodule_init
	@echo "Building TagLib library"
	cmake \
		-S modules/taglib \
		-B .build/taglib \
		-DCMAKE_BUILD_TYPE=Release \
		-DBUILD_FRAMEWORK=ON \
		-DCMAKE_C_COMPILER=/usr/bin/clang \
		-DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
		-DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
		-DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 \
		-DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_INSTALL_PREFIX=.build

	make -C .build/taglib

	xcodebuild \
		-create-xcframework \
		-framework .build/taglib/taglib/tag.framework \
		-output Frameworks/tag.xcframework

	@echo "Moving TaglibWrapper files"
	mkdir -p Sources/TaglibWrapper
	cp modules/TaglibWrapper/*.mm Sources/TaglibWrapper
	mkdir -p Sources/TaglibWrapper/include
	cp modules/TaglibWrapper/*.h Sources/TaglibWrapper/include

clean:
	@echo "Cleaning up"
	git submodule deinit -f modules/taglib
	git submodule deinit -f modules/TaglibWrapper
	rm -rf .build/taglib Frameworks Sources/TaglibWrapper
	mkdir Frameworks Sources/TaglibWrapper
