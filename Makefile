# Usage:
# make                 # does stuff
# make submodule_init  # does some other stuff

taglib_repo_url = "https://github.com/taglib/taglib.git"
taglibwrapper_repo_url = "https://github.com/ryanfrancesconi/TaglibWrapper.git"

all: clean submodule_update build

submodule_init:
	@echo "Initializing git submodules"
	git submodule update --init

submodule_update:
	@echo "Updating git submodules"
	git submodule update --init --recursive --remote

build: submodule_init move_taglib_wrapper build_taglib move_taglib
	@echo "Building"

move_taglib_wrapper:
	@echo "Moving TaglibWrapper files to Sources"
	mkdir -p Sources/TagLibKit
	cp modules/TaglibWrapper/*.mm Sources/TagLibKit
	mkdir -p Sources/TagLibKit/include
	cp modules/TaglibWrapper/*.h Sources/TagLibKit/include

build_taglib:
	@echo "Building TagLib library"
	mkdir -p modules/taglib_build
	cmake -S modules/taglib -B modules/taglib_build -DCMAKE_INSTALL_PREFIX=./taglib -DCMAKE_BUILD_TYPE=Release

move_taglib:
	@echo "Moving taglib files to Sources"

clean:
	@echo "Cleaning up"
	git submodule deinit -f modules/taglib
	git submodule deinit -f modules/TaglibWrapper
	rm -rf Sources modules/taglib_build
	mkdir Sources
	
# To rebuild the public headers, from the root of the taglib repo, run:
# 	cmake -DCMAKE_INSTALL_PREFIX=./taglib -DCMAKE_BUILD_TYPE=Release .
# 	make
# 	make install
