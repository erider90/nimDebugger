#######? replace(sub = "\t", by = "    ")
import windef


type 
  Handle* = int
  LONG* = int32
  ULONG* = int32
  PULONG* = ptr int
  BOOL* = int32
  PBOOL* = ptr WINBOOL
  DWORD* = int32
  PDWORD* = ptr DWORD
  LPINT* = ptr int32
  ULONG_PTR* = uint
  PULONG_PTR* = ptr uint
  HDC* = Handle
  HGLRC* = Handle
  BYTE* = uint8

type
 
  SECURITY_ATTRIBUTES* = object
    nLength*: int32
    lpSecurityDescriptor*: pointer
    bInheritHandle*: WINBOOL

  STARTUPINFO* = object
    cb*: int32
    lpReserved*: cstring
    lpDesktop*: cstring
    lpTitle*: cstring
    dwX*: int32
    dwY*: int32
    dwXSize*: int32
    dwYSize*: int32
    dwXCountChars*: int32
    dwYCountChars*: int32
    dwFillAttribute*: int32
    dwFlags*: int32
    wShowWindow*: int16
    cbReserved2*: int16
    lpReserved2*: pointer
    hStdInput*: Handle
    hStdOutput*: Handle
    hStdError*: Handle

  PROCESS_INFORMATION* = object
    hProcess*: Handle
    hThread*: Handle
    dwProcessId*: int32
    dwThreadId*: int32


proc createProcessA*(lpApplicationName, lpCommandLine: LPCSTR;
                    lpProcessAttributes: ptr SECURITY_ATTRIBUTES;
                    lpThreadAttributes: ptr SECURITY_ATTRIBUTES;
                    bInheritHandles: bool; dwCreationFlags: int32;
                    lpEnvironment, lpCurrentDirectory: LPCSTR;
                    lpStartupInfo: var STARTUPINFO;
                    lpProcessInformation: var PROCESS_INFORMATION): bool {. stdcall, dynlib: "kernel32", importc: "CreateProcessA", sideEffect.}
# HANDLE OpenThread(
  # [in] DWORD dwDesiredAccess,
  # [in] BOOL  bInheritHandle,
  # [in] DWORD dwThreadId
# );

proc OpenThread*(
  dwDesiredAccess: DWORD;
  bInheritHandle: BOOL;
  dwThreadId: DWORD): Handle {. stdcall, dynlib: "kernel32", importc: "OpenThread", sideEffect.}
  
  
  
# DWORD GetThreadId(
# [in] HANDLE Thread
# );

proc GetThreadId*(
  Thread: Handle
): DWORD {. stdcall, dynlib: "kernel32", importc: "GetThreadId", sideEffect.}

proc CloseHandle*(hObject: Handle): BOOL {.stdcall, dynlib: "kernel32", importc: "CloseHandle".}
# Constants
const
  DEBUG_PROCESS*         = 0x00000001
  CREATE_NEW_CONSOLE*    = 0x00000010
  PROCESS_ALL_ACCESS*    = 0x001F0FFF
  INFINITE*              = 0xFFFFFFFF
  DBG_CONTINUE*          = 0x00010002


  # Debug event constants
  EXCEPTION_DEBUG_EVENT*      =    0x1
  CREATE_THREAD_DEBUG_EVENT*  =    0x2
  CREATE_PROCESS_DEBUG_EVENT* =    0x3
  EXIT_THREAD_DEBUG_EVENT*    =    0x4
  EXIT_PROCESS_DEBUG_EVENT*   =    0x5
  LOAD_DLL_DEBUG_EVENT*       =    0x6
  UNLOAD_DLL_DEBUG_EVENT*     =    0x7
  OUTPUT_DEBUG_STRING_EVENT*  =    0x8
  RIP_EVENT*                  =    0x9

# debug exception codes.
  EXCEPTION_ACCESS_VIOLATION*     = 0xC0000005
  EXCEPTION_BREAKPOINT*           = 0x80000003
  EXCEPTION_GUARD_PAGE*           = 0x80000001
  EXCEPTION_SINGLE_STEP*          = 0x80000004


  # Thread constants for CreateToolhelp32Snapshot()
  TH32CS_SNAPHEAPLIST* = 0x00000001
  TH32CS_SNAPPROCESS*  = 0x00000002
  TH32CS_SNAPTHREAD*   = 0x00000004
  TH32CS_SNAPMODULE*   = 0x00000008
  TH32CS_INHERIT*      = 0x80000000
#   TH32CS_SNAPALL*      = (TH32CS_SNAPHEAPLIST | TH32CS_SNAPPROCESS | TH32CS_SNAPTHREAD | TH32CS_SNAPMODULE)
  THREAD_ALL_ACCESS*   = 0x001F03FF

  # Context flags for GetThreadContext()
  CONTEXT_FULL*                   = 0x00010007
  CONTEXT_DEBUG_REGISTERS*        = 0x00010010

  # Memory permissions
  PAGE_EXECUTE_READWRITE*         = 0x00000040

  # Hardware breakpoint conditions
  HW_ACCESS*                      = 0x00000003
  HW_EXECUTE*                     = 0x00000000
  HW_WRITE*                       = 0x00000001

  # Memory page permissions, used by VirtualProtect()
  PAGE_NOACCESS*                  = 0x00000001
  PAGE_READONLY*                  = 0x00000002
  PAGE_READWRITE*                 = 0x00000004
  PAGE_WRITECOPY*                 = 0x00000008
  PAGE_EXECUTE*                   = 0x00000010
  PAGE_EXECUTE_READ*              = 0x00000020
#   PAGE_EXECUTE_READWRITE*         = 0x00000040
  PAGE_EXECUTE_WRITECOPY*         = 0x00000080
  PAGE_GUARD*                     = 0x00000100
  PAGE_NOCACHE*                   = 0x00000200
  PAGE_WRITECOMBINE*              = 0x00000400

