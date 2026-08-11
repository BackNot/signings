#include <ntddk.h>

DRIVER_UNLOAD DriverUnload;

VOID DriverUnload(_In_ PDRIVER_OBJECT DriverObject)
{
    UNREFERENCED_PARAMETER(DriverObject);
    KdPrint(("DummyDriver: unloaded\n"));
}

NTSTATUS DriverEntry(_In_ PDRIVER_OBJECT DriverObject, _In_ PUNICODE_STRING RegistryPath)
{
    UNREFERENCED_PARAMETER(RegistryPath);
    DriverObject->DriverUnload = DriverUnload;
    KdPrint(("DummyDriver: loaded\n"));
    return STATUS_SUCCESS;
}
