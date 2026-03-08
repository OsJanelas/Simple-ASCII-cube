# A SIMPLE POWERSHELL CUBE
$Host.UI.RawUI.CursorSize = 0
$ErrorActionPreference = "SilentlyContinue"
Clear-Host

$vertices = @(
    @(-1, -1,  1), @( 1, -1,  1), @( 1,  1,  1), @(-1,  1,  1),
    @(-1, -1, -1), @( 1, -1, -1), @( 1,  1, -1), @(-1,  1, -1)
)

$edges = @(
    (0,1), (1,2), (2,3), (3,0),
    (4,5), (5,6), (6,7), (7,4),
    (0,4), (1,5), (2,6), (3,7)
)

$angleX = 0.0
$angleY = 0.0

try {
    while ($true) {
        $points = @()
        
        foreach ($v in $vertices) {
            $x = $v[0]; $y = $v[1]; $z = $v[2]

            $ny = $y * [Math]::Cos($angleX) - $z * [Math]::Sin($angleX)
            $nz = $y * [Math]::Sin($angleX) + $z * [Math]::Cos($angleX)
            $y = $ny; $z = $nz

            $nx = $x * [Math]::Cos($angleY) + $z * [Math]::Sin($angleY)
            $nz = -$x * [Math]::Sin($angleY) + $z * [Math]::Cos($angleY)
            $x = $nx; $z = $nz

            $factor = 20 / ($z + 4)
            $px = [int]($x * $factor * 2 + 40)
            $py = [int]($y * $factor + 15)
            $points += ,($px, $py)
        }

        $frame = New-Object System.Text.StringBuilder
        [void]$frame.Append("`e[H")

        $colors = @("`e[31m", "`e[32m", "`e[34m", "`e[35m", "`e[33m", "`e[36m")

        $out = New-Object 'string[][]' 35, 80
        foreach ($edge in $edges) {
            $p1 = $points[$edge[0]]; $p2 = $points[$edge[1]]
            $color = $colors[$edge[0] % $colors.Count]
            [void]$frame.Append("$color`e[$($p1[1]);$($p1[0])H*")
            [void]$frame.Append("$color`e[$($p2[1]);$($p2[0])H*")
        }

        Write-Host $frame.ToString() -NoNewline
        
        $angleX += 0.05
        $angleY += 0.03
        Start-Sleep -Milliseconds 30
    }
} finally {
    Write-Host "`e[0m"
    Clear-Host
}