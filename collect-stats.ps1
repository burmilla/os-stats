# create_stats.ps1

# Sample content generation for stats.csv
$data = @"
Name,Value
Metric1,100
Metric2,200
"@

# Write the data to stats.csv
$data | Out-File -FilePath "stats.csv" -Encoding utf8
