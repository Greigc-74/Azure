$storageAccountName = "ENTER STORAGE ACCOUNT NAME"
$storageContainer =  "ENTER STORAGE CONTAINER"
$prefix = ""
$MaxReturn = 10000
$count = 0
$StorageAccountKey = "ENTER YOUR KEY HERE" 

write-host "Starting script"

$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $StorageAccountKey 
$Token = $Null

do  
{  
    $listOfBlobs = Get-AzStorageBlob -Container $storageContainer -Context $ctx -MaxCount $MaxReturn  -ContinuationToken $Token -Prefix $prefix
  
    foreach($blob in $listOfBlobs) {  
        if($blob.ICloudBlob.Properties.StandardBlobTier -eq "Archive") 
        { 
        $blob.ICloudBlob.SetStandardBlobTier("Hot")
        #write-host "the blob " $blob.name " is being set to Hot"
        $count++
        }
    }  
    $Token = $blob[$blob.Count -1].ContinuationToken;  
    
    write-host "Processed "  ($count)  " items. Continuation token = " $Token.NextMarker
}while ($Null -ne $Token)

write-host "Complete processing of all blobs returned with prefix " $prefix