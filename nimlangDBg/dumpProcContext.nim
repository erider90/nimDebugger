import winINC

const FALSE* = 0

proc main(): void =
    # var si: STARTUPINFO = [0]
    # var si: STARTUPINFO 
    var si: winINC.STARTUPINFO
    #var pi: PROCESS_INFORMATION
    var pi: winINC.PROCESS_INFORMATION

    ##  Create a new process
    var check = createProcessA(nil, "path to binary", nil, nil, false, 0, nil, nil, si, pi)
    ##  Get the first thread HANDLE
    var hThread: HANDLE = OpenThread(THREAD_ALL_ACCESS, FALSE, GetThreadId(pi.hThread))
    ##  Get the thread context
    var ctx: CONTEXT
    ctx.ContextFlags = CONTEXT_FULL
    
    if GetThreadContext(hThread, addr(ctx)) == false :
        printf("Failed to get thread context\n")
    else: 
        printf("EAX: 0x%X\n", ctx.Rax)
        printf("EBX: 0x%X\n", ctx.Rbx)
        printf("ECX: 0x%X\n", ctx.Rcx)
        printf("EDX: 0x%X\n", ctx.Rdx)
        printf("ESP: 0x%X\n", ctx.Rsp)
        printf("EBP: 0x%X\n", ctx.Rbp)
        printf("EIP: 0x%X\n", ctx.Rip)
        ##  Close HANDLEs
        discard CloseHandle(hThread)
        discard CloseHandle(pi.hProcess)
        discard CloseHandle(pi.hThread)

main() 
