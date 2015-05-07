Add-Type -assembly System.Security;
$decoded = [Convert]::FromBase64String($args[0]);
$decrypted = [System.Security.Cryptography.ProtectedData]::Unprotect( `
  $decoded, `
  $null, `
  [System.Security.Cryptography.DataProtectionScope]::LocalMachine);

[System.Text.Encoding]::UTF8.getString($decrypted);