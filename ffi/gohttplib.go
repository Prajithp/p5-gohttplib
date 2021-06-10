package main

/*
#include <stdlib.h>

typedef struct Request_
{
    const char *Method;
    const char *Host;
	const char *URL;
	const char *Body;
    const char *Headers;
} Request;

typedef unsigned int ResponseWriterPtr;

typedef void FuncPtr(ResponseWriterPtr w, Request *r);
extern void Call_HandleFunc(ResponseWriterPtr w, Request *r, FuncPtr *fn);

*/
import "C"
import (
	"bytes"
	"net/http"
	"unsafe"
	"context"
    "github.com/gorilla/mux"
)

var cpointers = PtrProxy()
var srv http.Server = http.Server{}
var r = mux.NewRouter()


//export ListenAndServe
func ListenAndServe(caddr *C.char) {
	addr := C.GoString(caddr)
	srv.Addr = addr
    srv.Handler = r
	srv.ListenAndServe()
}

//export Shutdown
func Shutdown() {
	srv.Shutdown(context.Background())
}

//export HandleFunc
func HandleFunc(cpattern *C.char, cfn *C.FuncPtr) {
	pattern := C.GoString(cpattern)
    method  := C.GoString(methods)    

    
    r.HandleFunc(pattern, func(w http.ResponseWriter, req *http.Request) {

		headerBuffer := new(bytes.Buffer)
		req.Header.Write(headerBuffer)
		headersString := headerBuffer.String()
		bodyBuffer := new(bytes.Buffer)
		bodyBuffer.ReadFrom(req.Body)
		bodyString := bodyBuffer.String()

		creq := C.Request{
			Method:  C.CString(req.Method),
			Host:    C.CString(req.Host),
			URL:     C.CString(req.URL.String()),
			Body:    C.CString(bodyString),
			Headers: C.CString(headersString),
		}

		wPtr := cpointers.Ref(unsafe.Pointer(&w))
	    C.Call_HandleFunc(C.ResponseWriterPtr(wPtr), &creq, cfn)

		C.free(unsafe.Pointer(creq.Method))
		C.free(unsafe.Pointer(creq.Host))
		C.free(unsafe.Pointer(creq.URL))
		C.free(unsafe.Pointer(creq.Body))
		C.free(unsafe.Pointer(creq.Headers))
		cpointers.Free(wPtr)
	})
}

func main() {}
