Add-Type -assembly System.Security;
$toEncryptBytes = [System.Text.Encoding]::UTF8.GetBytes($args[0]);

$encrypted = `
  [System.Security.Cryptography.ProtectedData]::Protect( `
    $toEncryptBytes, `
    $null, `
    [System.Security.Cryptography.DataProtectionScope]::LocalMachine);

[Convert]::ToBase64String($encrypted);