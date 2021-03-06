package main

// #include <stdio.h>
import "C"
import (
	"net/http"
	"unsafe"
)

//export ResponseWriter_Write
func ResponseWriter_Write(wPtr C.uint, cbuf *C.char, length C.int) C.int {
	buf := C.GoBytes(unsafe.Pointer(cbuf), length)

	w, ok := cpointers.Deref(wPtr)
	if !ok {
		return C.EOF
	}

	n, err := (*(*http.ResponseWriter)(w)).Write(buf)
	if err != nil {
		return C.EOF
	}
	return C.int(n)
}

//export ResponseWriter_WriteHeader
func ResponseWriter_WriteHeader(wPtr C.uint, header C.int) {
	w, ok := cpointers.Deref(wPtr)
	if !ok {
		return
	}
	(*(*http.ResponseWriter)(w)).WriteHeader(int(header))
}

//export ResponseWriter_SetHeader
func ResponseWriter_SetHeader(wPtr C.uint, key *C.char, value *C.char) {
    w, ok := cpointers.Deref(wPtr)
    if !ok {
        return
    }
    (*(*http.ResponseWriter)(w)).Header().Set(C.GoString(key), C.GoString(value))
}

