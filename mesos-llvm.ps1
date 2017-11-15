$VERSION="2017-11-11"

git clone -q --depth 1 -b release_50 https://git.llvm.org/git/llvm/
git clone -q --depth 1 -b mesos_50 https://github.com/mesos/clang.git llvm/tools/clang
git clone -q --depth 1 -b mesos_50 https://github.com/mesos/clang-tools-extra.git llvm/tools/clang/tools/extra

$arguments = @(
    "-Thost=x64",
    "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG",
    "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG",
    "-DCMAKE_INSTALL_PREFIX=mesos-llvm/${VERSION}",
    "-Wno-dev",
    "llvm")

cmake $arguments

cmake --build . --target clang-format --config Release -- /m

cmake -DCOMPONENT=clang-format -P cmake_install.cmake
cmake --build . --target tools/clang/tools/extra/clang-tidy/install --config Release
cmake --build . --target tools/clang/tools/extra/clang-apply-replacements/install --config Release

Compress-Archive -DestinationPath "mesos-llvm-${VERSION}.windows.zip" -Path mesos-llvm
