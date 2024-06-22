$releases = Invoke-RestMethod https://api.github.com/repos/rancher/os/releases
$githubStats = @()
forEach($v in $releases) {
	$iso = $v.assets | Where-Object {$_.name -eq "rancheros.iso"}
	$rootfs = $v.assets | Where-Object {$_.name -eq "rootfs.tar.gz"}
	$githubStats += New-Object -TypeName PSObject -Property @{
		name = $v.name
		releaseDate = $v.published_at.ToString("yyyy-MM-dd")
		isoDownloads = $iso.download_count
		pxeDownloads = $rootfs.download_count
	}
}
$githubStats | Sort-Object releaseDate | Select-Object name,releaseDate,isoDownloads,pxeDownloads | Export-Csv RancherOS_GitHubStats.csv -NoType


$osStats = Invoke-RestMethod https://hub.docker.com/v2/repositories/rancher/os/
$osStats | Select-Object last_updated,pull_count | Export-Csv RancherOS_DockerHubTotalPull.csv -NoType


$dockerHubStats = @()
$osTagStats = Invoke-RestMethod "https://hub.docker.com/v2/repositories/rancher/os/tags?page_size=100&page=1&ordering=last_updated"
forEach($osTag in $osTagStats.results) {
	$dockerHubStats += New-Object -TypeName PSObject -Property @{
		name = $osTag.name
		releaseDate = $osTag.tag_last_pushed.ToString("yyyy-MM-dd")
		lastPull = $osTag.tag_last_pulled.ToString("yyyy-MM-dd")
	}
}
$dockerHubStats | Sort-Object releaseDate | Select-Object name,releaseDate,lastPull | Export-Csv RancherOS_DockerHubStats.csv -NoType
