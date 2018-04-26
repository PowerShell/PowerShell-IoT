ResGen was copied from [PowerShell/PowerShell](https://github.com/PowerShell/PowerShell/tree/master/src/ResGen).

In this case ResGen is used to process resource file `src\Microsoft.PowerShell.IoT\resources\Resources.resx`
and to generate `src\Microsoft.PowerShell.IoT\gen\Resources.cs` that is used in the build.

For any modification to resources:

1. make required changes in Resources.resx using a text editor
1. generate updated Resources.cs:
   1. `cd src\ResGen`
   1. `dotnet run`
1. compile IoT module as usual to ensure there are no build breaks
1. check in updated `Resources.resx` and `Resources.cs`

[More info on ResGen](https://github.com/PowerShell/PowerShell/blob/master/docs/dev-process/resx-files.md).
