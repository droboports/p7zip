# Download a BZ2 file and unpack it, removing old files.
# $1: file
# $2: url
# $3: folder
_download_bz2() {
  [[ ! -d "download" ]]      && mkdir -p "download"
  [[ ! -d "target" ]]        && mkdir -p "target"
  [[ ! -f "download/${1}" ]] && wget -O "download/${1}" "${2}"
  [[   -d "target/${3}" ]]   && rm -vfr "target/${3}"
  [[ ! -d "target/${3}" ]]   && tar -jxvf "download/${1}" -C target
  return 0
}

### P7ZIP ###
_build_p7zip() {
local VERSION="9.20.1"
local FOLDER="p7zip_${VERSION}"
local FILE="${FOLDER}_src_all.tar.bz2"
local URL="http://sourceforge.net/projects/p7zip/files/p7zip/${VERSION}/${FILE}"

_download_bz2 "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
cp makefile.linux_cross_arm makefile.linux
make all3 CC="${CC} \$(ALLFLAGS)" CXX="${CXX} \$(ALLFLAGS)" OPTFLAGS="${CFLAGS}"
make install DEST_HOME="${DEST}"
popd
}

### BUILD ###
_build() {
  _build_p7zip
  _package
}
