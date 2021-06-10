function build() {
    pushd ffi
    go build -o ../blib/lib/auto/share/dist/GoHttpLib/lib/libgohttplib.so -buildmode=c-shared -ldflags=-w
    popd 
}
