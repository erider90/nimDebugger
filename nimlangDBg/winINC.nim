#######? replace(sub = "\t", by = "    ")
# include windef

proc printf*(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc printf2*(formatstr: cstring) {.header: "<stdio.h>",
                                      importc: "printf", varargs.}
type 
  HANDLE* = int
  WORD* = uint16
  LONG* = int32
  ULONG* = int32
  PULONG* = ptr
  LONG64* = int64
  PLONG64* = ptr int64
  ULONG64* = int64
  PULONG64* = ptr int64
  DWORD64* = int64
  PDWORD64* = ptr int64
  PVOID* = pointer
  BOOL* = int32
  WINBOOL* = int32
  PBOOL* = ptr WINBOOL
  DWORD* = int32
  PDWORD* = ptr DWORD
  LPINT* = ptr int32
  ULONG_PTR* = uint
  PULONG_PTR* = ptr uint
  LONGLONG* = int64
  PLONGLONG* = ptr int64
  ULONGLONG* = int64
  PULONGLONG* = ptr int64
  PCSZ* = ptr char
  HDC* = HANDLE
  HGLRC* = HANDLE
  BYTE* = uint8
  LPCSTR* = cstring

type
 
  SECURITY_ATTRIBUTES* = object
    nLength*: int32
    lpSecurityDescriptor*: pointer
    bInheritHANDLE*: WINBOOL

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
    hStdInput*: HANDLE
    hStdOutput*: HANDLE
    hStdError*: HANDLE

  PROCESS_INFORMATION* = object
    hProcess*: HANDLE
    hThread*: HANDLE
    dwProcessId*: int32
    dwThreadId*: int32

proc createProcessA*(lpApplicationName, lpCommandLine: LPCSTR;
                    lpProcessAttributes: ptr SECURITY_ATTRIBUTES;
                    lpThreadAttributes: ptr SECURITY_ATTRIBUTES;
                    bInheritHANDLEs: bool; dwCreationFlags: int32;
                    lpEnvironment, lpCurrentDirectory: LPCSTR;
                    lpStartupInfo: var STARTUPINFO;
                    lpProcessInformation: var PROCESS_INFORMATION): bool {.
    stdcall, dynlib: "kernel32", importc: "CreateProcessA", sideEffect.}

# HANDLE OpenThread(
  # [in] DWORD dwDesiredAccess,
  # [in] BOOL  bInheritHANDLE,
  # [in] DWORD dwThreadId
# );

# DWORD GetThreadId(
# [in] HANDLE Thread
# );

proc GetThreadId*(
  Thread: HANDLE
): DWORD {. stdcall, dynlib: "kernel32", importc: "GetThreadId", sideEffect.}

proc CloseHandle*(hObject: HANDLE): BOOL {. stdcall, dynlib: "kernel32", importc: "CloseHandle".}

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

const
  EXCEPTION_MAXIMUM_PARAMETERS* = 15
type
  EXCEPTION_RECORD* {.pure.} = object
    ExceptionCode*: DWORD
    ExceptionFlags*: DWORD
    ExceptionRecord*: ptr EXCEPTION_RECORD
    ExceptionAddress*: PVOID
    NumberParameters*: DWORD
    ExceptionInformation*: array[EXCEPTION_MAXIMUM_PARAMETERS, ULONG_PTR]
  PEXCEPTION_RECORD* = ptr EXCEPTION_RECORD
  M128A* {.pure.} = object
    Low*: ULONGLONG
    High*: LONGLONG

type
 XMM_SAVE_AREA32* {.pure.} = object
    ControlWord*: WORD
    StatusWord*: WORD
    TagWord*: BYTE
    Reserved1*: BYTE
    ErrorOpcode*: WORD
    ErrorOffset*: DWORD
    ErrorSelector*: WORD
    Reserved2*: WORD
    DataOffset*: DWORD
    DataSelector*: WORD
    Reserved3*: WORD
    MxCsr*: DWORD
    MxCsr_Mask*: DWORD
    FloatRegisters*: array[8, M128A]
    XmmRegisters*: array[16, M128A]
    Reserved4*: array[96, BYTE]
 CONTEXT_UNION1_STRUCT1* {.pure.} = object
    Header*: array[2, M128A]
    Legacy*: array[8, M128A]
    Xmm0*: M128A
    Xmm1*: M128A
    Xmm2*: M128A
    Xmm3*: M128A
    Xmm4*: M128A
    Xmm5*: M128A
    Xmm6*: M128A
    Xmm7*: M128A
    Xmm8*: M128A
    Xmm9*: M128A
    Xmm10*: M128A
    Xmm11*: M128A
    Xmm12*: M128A
    Xmm13*: M128A
    Xmm14*: M128A
    Xmm15*: M128A
 CONTEXT_UNION1* {.pure, union.} = object
    FltSave*: XMM_SAVE_AREA32
    FloatSave*: XMM_SAVE_AREA32
    struct1*: CONTEXT_UNION1_STRUCT1
 CONTEXT* {.pure.} = object
    P1Home*: DWORD64
    P2Home*: DWORD64
    P3Home*: DWORD64
    P4Home*: DWORD64
    P5Home*: DWORD64
    P6Home*: DWORD64
    ContextFlags*: DWORD
    MxCsr*: DWORD
    SegCs*: WORD
    SegDs*: WORD
    SegEs*: WORD
    SegFs*: WORD
    SegGs*: WORD
    SegSs*: WORD
    EFlags*: DWORD
    Dr0*: DWORD64
    Dr1*: DWORD64
    Dr2*: DWORD64
    Dr3*: DWORD64
    Dr6*: DWORD64
    Dr7*: DWORD64
    Rax*: DWORD64
    Rcx*: DWORD64
    Rdx*: DWORD64
    Rbx*: DWORD64
    Rsp*: DWORD64
    Rbp*: DWORD64
    Rsi*: DWORD64
    Rdi*: DWORD64
    R8*: DWORD64
    R9*: DWORD64
    R10*: DWORD64
    R11*: DWORD64
    R12*: DWORD64
    R13*: DWORD64
    R14*: DWORD64
    R15*: DWORD64
    Rip*: DWORD64
    union1*: CONTEXT_UNION1
    VectorRegister*: array[26, M128A]
    VectorControl*: DWORD64
    DebugControl*: DWORD64
    LastBranchToRip*: DWORD64
    LastBranchFromRip*: DWORD64
    LastExceptionToRip*: DWORD64
    LastExceptionFromRip*: DWORD64
const
    SIZE_OF_80387_REGISTERS* = 80
type
    FLOATING_SAVE_AREA* {.pure.} = object
      ControlWord*: DWORD
      StatusWord*: DWORD
      TagWord*: DWORD
      ErrorOffset*: DWORD
      ErrorSelector*: DWORD
      DataOffset*: DWORD
      DataSelector*: DWORD
      RegisterArea*: array[SIZE_OF_80387_REGISTERS, BYTE]
      Cr0NpxState*: DWORD
const
 MAXIMUM_SUPPORTED_EXTENSION* = 512
type
 CONTEXTA* {.pure.} = object
  ContextFlags*: DWORD
  Dr0*: DWORD
  Dr1*: DWORD
  Dr2*: DWORD
  Dr3*: DWORD
  Dr6*: DWORD
  Dr7*: DWORD
  FloatSave*: FLOATING_SAVE_AREA
  SegGs*: DWORD
  SegFs*: DWORD
  SegEs*: DWORD
  SegDs*: DWORD
  Edi*: DWORD
  Esi*: DWORD
  Ebx*: DWORD
  Edx*: DWORD
  Ecx*: DWORD
  Eax*: DWORD
  Ebp*: DWORD
  Eip*: DWORD
  SegCs*: DWORD
  EFlags*: DWORD
  Esp*: DWORD
  SegSs*: DWORD
  ExtendedRegisters*: array[MAXIMUM_SUPPORTED_EXTENSION, BYTE]

type
  PCONTEXT* = ptr CONTEXT

type
   LPCONTEXT* = ptr CONTEXT
   lpContext* = ptr LPCONTEXT

proc OpenThread*(
  dwDesiredAccess: DWORD;
  bInheritHANDLE: BOOL;
  dwThreadId: DWORD): HANDLE {. stdcall, dynlib: "kernel32", importc: "OpenThread", sideEffect.}
  
proc GetThreadContext*(
 hThread: HANDLE;
 lpContext: LPCONTEXT
): bool {. stdcall, dynlib: "kernel32", importc: "GetThreadContext", sideEffect.}

