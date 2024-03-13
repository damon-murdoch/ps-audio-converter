<#
    .SYNOPSIS
    Converts audio files to a specified format using ffmpeg.

    .DESCRIPTION
    This script converts audio files from one format to another using ffmpeg. It can process files in a specified directory or recursively in subdirectories. The output files are saved in the specified output directory with the desired format. If the output directory doesn't exist, it will be created. Optionally, it can compare the sizes of the input and output directories to check for any differences after conversion.
    Please note, that ffmpeg will be required to be installed to use this application - You can choose to simply add the ffmpeg.exe binary file in the same directory as this script. For installation instructions, please see https://www.gyan.dev/ffmpeg/builds/

    .PARAMETER InputPath
    Specifies the input directory containing audio files to be converted. Default is the current directory.

    .PARAMETER OutputPath
    Specifies the output directory where converted audio files will be saved. Default is './output'.

    .PARAMETER OutputFormat
    Specifies the format to which the audio files will be converted. Default is '.mp3'. Valid options are: '.aiff', '.flac', '.m4a', '.mp3', '.mp4', '.wav', '.ogg'.

    .PARAMETER WhatIf
    If this switch is set, the command will be tested and no changes will be made.

    .PARAMETER Help
    If this switch is set, the help message is displayed.

    .PARAMETER Recurse
    If this switch is set, folders will be processed recursively.

    .PARAMETER Compare
    If this switch is set, file size differences will be compared after processing.

    .EXAMPLE
    .\Convert-AudioFileFormat.ps1 -InputPath "C:\Audio" -OutputPath "D:\ConvertedAudio" -OutputFormat ".mp3" -Recurse

    Converts all audio files in the "C:\Audio" directory and its subdirectories to the .mp3 format and saves them in the "D:\ConvertedAudio" directory.

    .EXAMPLE
    .\Convert-AudioFileFormat.ps1 -InputPath "C:\Audio" -OutputPath "D:\ConvertedAudio" -OutputFormat ".wav" -Recurse -Compare

    Converts all audio files in the "C:\Audio" directory and its subdirectories to the .wav format, saves them in the "D:\ConvertedAudio" directory, and compares the sizes of input and output directories after conversion.
#>

Param(
    # Input filepath
    [Alias('i','ip')][Parameter(Mandatory = $False)][String]$InputPath = '.', 
    # Output filepath
    [Alias('o','op')][Parameter(Mandatory = $False)][String]$OutputPath = './output', 
    # Format which the output files will be converted to (default: .mp3)
    [Alias('f')][Parameter(Mandatory = $False)][ValidateSet('.aiff', '.flac', '.m4a', '.mp3', '.mp4', '.wav', '.ogg')][String]$OutputFormat = '.mp3',
    # If this switch is set, the command will be tested and no changes will be made
    [Alias('t','w')][Parameter(Mandatory = $False)][Switch]$WhatIf, 
    # If this switch is command, the help message is displayed
    [Alias('h')][Parameter(Mandatory = $False)][Switch]$Help, 
    # If this switch is set, folders will be processed recursively
    [Alias('r')][Parameter(Mandatory = $False)][Switch]$Recurse, 
    # If this switch is set, file size differences will be compared after processing
    [Alias('c')][Parameter(Mandatory = $False)][Switch]$Compare
);

# Allowed Sound File Formats
$SoundFormats = @(
    '.aiff', '.flac', '.m4a', '.mp3', '.mp4', '.wav', '.ogg'
);

Try {
    # Help Switch
    If ($Help) {
        audioconvert convert --help;
    }
    Else { # Help switch not set

        # Convert files in the root directory
        # 

        # If the output folder does not exist
        If (-Not (Test-Path -PathType Container -Path $OutputPath))
        {
            # Test switch set
            If ($WhatIf)
            {
                Write-Host -ForegroundColor Yellow "[WhatIf]: New-Item -ItemType Container -Path '$OutputPath'";
            }
            Else # Test switch not set
            {
                # Create it
                New-Item -ItemType Container -Path $OutputPath;
            }
        }

        # Get items in root directory (files only)
        $Files = Get-ChildItem -Path $InputPath -File;

        ForEach($File in $Files)
        {
            # Generate input / output file paths
            $InputFile = $File | Select-Object -ExpandProperty FullName;
            $OutputFile = Join-Path -Path $OutputPath -ChildPath ($File | Select-Object -ExpandProperty Name);

            # Get input file extension (Including '.')
            $Extension = ".$($InputFile.Split('.')[-1])";

            # File is a valid input sound format
            If ($SoundFormats.Contains($Extension) -And (-Not ($Extension -Eq $OutputFormat)))
            {
                # Replace the extension of the output file
                $OutputFile = $OutputFile.Replace($Extension, $OutputFormat);

                # File already exists
                If (Test-Path $OutputFile)
                {
                    Write-Host -ForegroundColor Yellow "[Warning] File already exists: $OutputFile, skipping ...";
                }
                Else # File does not exist
                {
                    # Test switch set
                    If ($WhatIf)
                    {
                        Write-Host -ForegroundColor Yellow "[WhatIf] ffmpeg -i '$InputFile' '$OutputFile'";
                    }
                    Else # Test switch not set
                    {
                        Write-Host -ForegroundColor Cyan "[Info] Converting '$InputFile' to '$OutputFile' ...";

                        ffmpeg -i $InputFile $OutputFile | Out-Null;
                    }
                }
            }
            Else # File is not a valid input sound format
            {
                # File already exists
                If (Test-Path $OutputFile)
                {
                    Write-Host -ForegroundColor Yellow "[Warning] File already exists: $OutputFile, skipping ...";
                }
                Else # File does not exist
                {
                    Write-Host -ForegroundColor Cyan "[Info] File '$File' already matches the desired format, or is not a valid sound file - Copying as-is.";

                    # Test switch set
                    If ($WhatIf)
                    {
                        Write-Host -ForegroundColor Yellow "[WhatIf] Copy-Item -Path '$InputFile' -Destination '$OutputFile'";
                    }
                    Else # Test switch not set
                    {
                        Copy-Item -Path $InputFile -Destination $OutputFile;
                    }
                }
            }
        }

        # Recursive switch set
        If ($Recurse)
        {
            # Get items in root directory (folders only)
            $Folders = Get-ChildItem -Path $InputPath -Directory;

            ForEach($Folder in $Folders)
            {
                $FolderName = $Folder | Select-Object -ExpandProperty Name;

                # Get full path to subfolder
                $FolderPath = $Folder | Select-Object -ExpandProperty FullName;

                ./Convert-AudioFileFormat.ps1 -InputPath $FolderPath -OutputPath (Join-Path -Path $OutputPath -ChildPath $FolderName) -OutputFormat $OutputFormat -Recurse:$Recurse -WhatIf:$WhatIf -Compare:$Compare;
            }
        }

        Write-Host -ForegroundColor Green "Processed path '$InputPath' successfully!";

        If ($Compare)
        {
            # Get size of both input, output folders ...
            $InputSize = [Int](Get-ChildItem -Path $InputPath -Recurse | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum);
            $OutputSize = [Int](Get-ChildItem -Path $OutputPath -Recurse | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum);

            # Ensure both folders are not empty
            If ($InputSize -Gt 0 -And $OutputSize -Gt 0)
            {
                Write-Host -ForegroundColor Cyan "Size Comparison (Input -> Output): $([Math]::Round($InputSize/1MB, 2))MB -> $([Math]::Round($OutputSize/1MB, 2))MB ($([Math]::Round($OutputSize/$InputSize*100,2))%) ...";
            }
        }
    }
}
Catch { # Failed to run audioconvert
    Write-Host -ForegroundColor Red "Audio conversion failed! $($_.Exception.Message)";
}