using System.Diagnostics;
using System.Management;
using System.Collections.Concurrent;
using Vanara.PInvoke;
using static Vanara.PInvoke.User32;
using static Vanara.PInvoke.User32.WINEVENT;
using static Vanara.PInvoke.User32.EventConstant;
using DisplayGame.Model;

namespace DisplayGame;

[System.Runtime.Versioning.SupportedOSPlatform("windows")]
public static class Callback
{
    private static uint GetWindowProcessID(HWND hWnd)
    {

        GetWindowThreadProcessId(hWnd, out uint pid);
        return pid;
    }

    private static void EventCallback(HWINEVENTHOOK hWinEventHook, EventConstant eventType, HWND hwnd, ObjectIdentifier idObject, int idChild, uint dwEventThread, uint dwmsEventTime)
    {
        int pid = (int)GetWindowProcessID(hwnd);
        String appname = Process.GetProcessById(pid).ProcessName;
        String cmdline = GetCommandLineByPid(pid);
        if (Config.GetGame(appname, cmdline, out GameRecord Game))
            Queue.Add(Game);
        else
            Console.WriteLine($"{appname} : {cmdline}");
    }

    public static string GetCommandLineByPid(int pid)
    {
        string query = $"SELECT CommandLine FROM Win32_Process WHERE ProcessId = {pid}";

        using (var searcher = new ManagementObjectSearcher(query))
        using (var collection = searcher.Get())
        {
            foreach (var obj in collection)
            {
                return obj["CommandLine"]?.ToString() ?? string.Empty;
            }
        }
        return "Not found";
    }

    public static void Monitor()
    {
        Console.CancelKeyPress += (sender, e) =>
        {
            Queue.CompleteAdding();
        };

        var hookHandle = SetWinEventHook(EVENT_SYSTEM_FOREGROUND, EVENT_SYSTEM_FOREGROUND, HINSTANCE.NULL, new(EventCallback), 0, 0, WINEVENT_OUTOFCONTEXT | WINEVENT_SKIPOWNPROCESS);
        if (hookHandle.IsNull || hookHandle.IsInvalid)
        {
            Console.WriteLine("Failed to install window hook.");
            return;
        }

        while (GetMessage(out MSG msg, IntPtr.Zero, 0, 0) > 0)
        {
            TranslateMessage(msg);
            DispatchMessage(msg);
        }

        UnhookWinEvent(hookHandle);
    }

    public static BlockingCollection<GameRecord> Queue
    {
        get; set;
    } = new();
}
