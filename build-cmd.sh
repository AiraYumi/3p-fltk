#!/usr/bin/env bash

cd "$(dirname "$0")"

# turn on verbose debugging output for logs.
exec 4>&1; export BASH_XTRACEFD=4; set -x
# make errors fatal
set -e
# bleat on references to undefined shell variables
set -u

VERSION="1.3.5"
SOURCE_DIR="fltk-${VERSION}"

top="$(pwd)"
stage="$top"/stage

# load autobuild provided shell functions and variables
case "$AUTOBUILD_PLATFORM" in
    windows*)
        autobuild="$(cygpath -u "$AUTOBUILD")"
    ;;
    *)
        autobuild="$AUTOBUILD"
    ;;
esac
source_environment_tempfile="$stage/source_environment.sh"
"$autobuild" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

build=${AUTOBUILD_BUILD_ID:=0}
echo "${VERSION}.${build}" > "${stage}/VERSION.txt"

pushd "$SOURCE_DIR"
    case "$AUTOBUILD_PLATFORM" in

        # ------------------------ windows, windows64 ------------------------
        windows*)
        ;;

        # ------------------------- darwin, darwin64 -------------------------
        darwin*)
			;;
        linux64)
			#--disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
			#--enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
			#--enable-cygwin         use the Cygwin libraries [default=no]
			#--enable-x11            with Cygwin or Mac OS, use X11 [default=no]
			#--enable-cairoext       use fltk code instrumentation for cairo extended use [default=no]
			#--enable-cairo          use lib Cairo [default=no]
			#--enable-debug          turn on debugging [default=no]
			#--enable-cp936          turn on CP936 [default=no]
			#--enable-gl             turn on OpenGL support [default=yes]
			#--enable-shared         turn on shared libraries [default=no]
			#--enable-threads        enable multi-threading support [default=yes]
			#--disable-largefile     omit support for large files
			#--enable-localjpeg      use local JPEG library [default=auto]
			#--enable-localzlib      use local ZLIB library [default=auto]
			#--enable-localpng       use local PNG library  [default=auto]
			#--enable-xinerama       turn on Xinerama support [default=yes]
			#--enable-xft            turn on Xft support [default=yes]
			#--enable-xdbe           turn on Xdbe support [default=yes]
			#--enable-xfixes         turn on Xfixes support [default=yes]
			#--enable-xcursor        turn on Xcursor support [default=yes]
			#--enable-xrender        turn on Xrender support [default=yes]


			FLAGS="-m$AUTOBUILD_ADDRSIZE $LL_BUILD_RELEASE"
			CFLAGS="${FLAGS}" CXXFLAGS="${FLAGS}" ./configure --enable-localjpeg --enable-localzlib --enable-localpng \
				  --enable-xdbe=no --enable-xcursor=no --enable-xfixes=no --enable-xrender=no --enable-xft=no \
				  --prefix=${stage} --libdir="$stage/lib/release"
			make -j 6 && make install && make distclean
        ;;
    esac
    mkdir -p "$stage/LICENSES"
    cp COPYING "$stage/LICENSES/fltk.txt"
popd

