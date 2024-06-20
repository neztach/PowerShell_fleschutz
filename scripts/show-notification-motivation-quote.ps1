#Api key for quotes https://api.api-ninjas.com
 $headerQuote = @{
    "X-Api-Key"="FZ/rIx6RAn/W7+3S10zrHQ==gWBfP5fO0xcUiKp3"
   }
#calling api and getting quoute
$quote = Invoke-WebRequest -Uri https://api.api-ninjas.com/v1/quotes?category=inspirational -Method GET -Headers $headerQuote
#parsing json response
$quoteObj = ConvertFrom-Json $([String]::new($quote.Content))

$headlineText = $quoteObj.author
$bodyText = $quoteObj.quote
#defualt windows Icon for notification icon
$logo = 'C:\Windows\System32\@WindowsHelloFaceToastIcon.png'

#get random picture of cat
$image = Invoke-WebRequest -Uri 'https://api.thecatapi.com/v1/images/search?size=small' -Method Get
#parsing json response
$jsonObj = ConvertFrom-Json $([String]::new($image.Content))

$wc = New-Object System.Net.WebClient
#put cat picture into your user pictures folder
$wc.DownloadFile($jsonObj.url, "C:\Users\" + $Env:Username + "\Pictures\test.jpg")


$xml = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>$($headlineText)</text>
            <text>$($bodyText)</text>
            <image placement="appLogoOverride" src="$($logo)"/>
            <image placement="hero" addImageQuery="true" src="C:\Users\User\Pictures\test.jpg"/>
        </binding>
    </visual>
    <audio silent="true"/>
</toast>
"@

#play cat mew with notification
$MediaPlayer = [Windows.Media.Playback.MediaPlayer, Windows.Media, ContentType = WindowsRuntime]::New()
$MediaPlayer.Source = [Windows.Media.Core.MediaSource]::CreateFromUri('https://v1.cdnpk.net/videvo_files/audio/premium/audio0023/watermarked/AnimalCat 6003_40_1_preview.mp3')
$MediaPlayer.Volume = 10.
$MediaPlayer.Play()

#show notification
$XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
$XmlDocument.loadXml($xml)
$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier($AppId).Show($XmlDocument)

