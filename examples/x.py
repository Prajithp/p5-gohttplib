from cffi import FFI

ffi = FFI()
ffi.cdef("""
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
void Call_HandleFunc(ResponseWriterPtr w, Request *r, FuncPtr *fn);
void ListenAndServe(char* p0);
void Shutdown();
void HandleFunc(char* p0, FuncPtr* p1);
int ResponseWriter_Write(unsigned int p0, char* p1, int p2);
void ResponseWriter_WriteHeader(unsigned int p0, int p1);
""")

m = ffi.dlopen('./blib/lib/auto/share/dist/GoHttpLib/lib/libgohttplib.so')

@ffi.callback("void(ResponseWriterPtr, Request*)")
def handler(w, req):
    body = "xxxxxx"
    n = m.ResponseWriter_Write(w, body, len(body))

m.HandleFunc(str.encode("/"), handler)
m.ListenAndServe("0.0.0.0:5000")
