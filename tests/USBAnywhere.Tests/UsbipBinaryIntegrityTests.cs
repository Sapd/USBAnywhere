using System;
using System.IO;
using System.Security.Cryptography;
using USBAnywhere.Services;
using Xunit;

namespace USBAnywhere.Tests;

public class UsbipBinaryIntegrityTests
{
    private static string CalculateSha256(string filePath)
    {
        using var sha256 = SHA256.Create();
        using var stream = File.OpenRead(filePath);
        var bytes = sha256.ComputeHash(stream);
        return BitConverter.ToString(bytes).Replace("-", "").ToUpperInvariant();
    }

    [Fact]
    public void ValidHashes_Contains_Bundled_x64_UsbipBinary()
    {
        // Locate Portable/usbipw.exe from solution root
        var baseDir = AppContext.BaseDirectory;
        // Search upwards for Portable directory
        var dir = new DirectoryInfo(baseDir);
        string? portablePath = null;
        while (dir != null)
        {
            var candidate = Path.Combine(dir.FullName, "Portable", "usbipw.exe");
            if (File.Exists(candidate))
            {
                portablePath = candidate;
                break;
            }
            dir = dir.Parent;
        }

        Assert.NotNull(portablePath);
        var actualHash = CalculateSha256(portablePath);

        Assert.Contains(actualHash, UsbipService.ValidHashes);
    }

    [Fact]
    public void ValidHashes_Contains_Bundled_ARM64_UsbipBinary_IfPresent()
    {
        var baseDir = AppContext.BaseDirectory;
        var dir = new DirectoryInfo(baseDir);
        string? arm64Path = null;
        while (dir != null)
        {
            var candidate = Path.Combine(dir.FullName, "Portable-ARM64", "usbipw.exe");
            if (File.Exists(candidate))
            {
                arm64Path = candidate;
                break;
            }
            dir = dir.Parent;
        }

        if (arm64Path != null)
        {
            var actualHash = CalculateSha256(arm64Path);
            Assert.Contains(actualHash, UsbipService.ValidHashes);
        }
    }

    [Theory]
    [InlineData("0000000000000000000000000000000000000000000000000000000000000000")]
    [InlineData("DEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF")]
    public void ValidHashes_Rejects_Untrusted_Hashes(string untrustedHash)
    {
        Assert.DoesNotContain(untrustedHash, UsbipService.ValidHashes);
    }
}
