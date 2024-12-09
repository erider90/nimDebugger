# nim c -d:mingw64 --cpu:amd64 --verbosity:0 .\dumpProcContext.nim
import winINC
import os

var target*:LPCSTR

if paramCount() > 0:
  target = paramStr(1)
else:
  echo "Please provide a filename as an argument"

const FALSE* = 0

proc main(): void =
    var si: winINC.STARTUPINFO
    var pi: winINC.PROCESS_INFORMATION

    ##  Create a new process
    discard createProcessA(nil, target, nil, nil, false, 0, nil, nil, si, pi)
    ##Get the first thread HANDLE
    var hThread: HANDLE = OpenThread(THREAD_ALL_ACCESS, FALSE, GetThreadId(pi.hThread))
    ##  Get the thread context
    var ctx: CONTEXT
    ctx.ContextFlags = CONTEXT_FULL
    
    if GetThreadContext(hThread, addr(ctx)) == false :
        printf("Failed to get thread context\n")
    else:
        echo("[*] the process ", pi.hProcess)
        printf("RAX: 0x%X\n", ctx.Rax)
        printf("RBX: 0x%X\n", ctx.Rbx)
        printf("RCX: 0x%X\n", ctx.Rcx)
        printf("RDX: 0x%X\n", ctx.Rdx)
        printf("RSP: 0x%X\n", ctx.Rsp)
        printf("RBP: 0x%X\n", ctx.Rbp)
        printf("RIP: 0x%X\n", ctx.Rip)
        ##  Close HANDLEs
        discard CloseHandle(hThread)
        discard CloseHandle(pi.hProcess)
        discard CloseHandle(pi.hThread)

main() 
