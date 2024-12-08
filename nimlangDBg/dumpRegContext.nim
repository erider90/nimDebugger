#import windef 
import winINC
import winlean #except createProcessW

const FALSE* = 0
# proc createProcessW*(lpApplicationName, lpCommandLine: WideCString,
                   # lpProcessAttributes: ptr  winINC.SECURITY_ATTRIBUTES,
                   # lpThreadAttributes: ptr  winINC.SECURITY_ATTRIBUTES,
                   # bInheritHandles: winINC.WINBOOL, dwCreationFlags: int32,
                   # lpEnvironment, lpCurrentDirectory: WideCString,
                   # lpStartupInfo: var winINC.STARTUPINFO,
                   # lpProcessInformation: var winINC.PROCESS_INFORMATION): winINC.WINBOOL{.
  # stdcall, dynlib: "kernel32", importc: "CreateProcessW", sideEffect.}

proc main*(argc: cint; argv: cstringArray): cint =
  # var si: STARTUPINFO = [0]
  # var si: STARTUPINFO 
  var si: winINC.STARTUPINFO
  #var pi: PROCESS_INFORMATION
  var pi: winINC.PROCESS_INFORMATION
  
  ##  Create a new process
  winlean.CreateProcessW*(nil, argv[1], nil, nil, FALSE, 0, nil, nil, addr(si), addr(pi))
  
  ##  Get the first thread handle
  var hThread: HANDLE = OpenThread(THREAD_ALL_ACCESS, FALSE, GetThreadId(pi.hThread))
  ##  Get the thread context
  var ctx: CONTEXT
  ctx.ContextFlags = CONTEXT_FULL
  if not GetThreadContext(hThread, addr(ctx)):
    printf("Failed to get thread context\n")
    return 1
  printf("EAX: 0x%X\n", ctx.Rax)
  printf("EBX: 0x%X\n", ctx.Rbx)
  printf("ECX: 0x%X\n", ctx.Rcx)
  printf("EDX: 0x%X\n", ctx.Rdx)
  printf("ESP: 0x%X\n", ctx.Rsp)
  printf("EBP: 0x%X\n", ctx.Rbp)
  printf("EIP: 0x%X\n", ctx.Rip)
  ##  Close handles
  CloseHandle(hThread)
  CloseHandle(pi.hProcess)
  CloseHandle(pi.hThread)
  return 0
